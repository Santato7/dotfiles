---
name: jira-attachment
description: Baixa anexos (screenshots, PDFs, logs) de issues do Jira da DS3 (ds3digital.atlassian.net) via REST API, pra poder dar Read neles, porque o MCP do Atlassian só devolve metadado do anexo, não o binário. Ativar sempre que um card do Jira com anexo relevante entrar em jogo, mesmo sem pedido explícito de "baixa o anexo": investigar, planejar, reproduzir bug, ou fazer code review de um PR/card citando o número do card (ex: "code review do card PCGRF-491") — nesses casos, ler o card e, se ele tiver anexo, baixar e olhar antes de responder.
---

# Download de anexo do Jira (DS3)

Site: `ds3digital.atlassian.net`. Auth: HTTP Basic via `~/.netrc` (configurado fora desta sessão, ver Setup).
Diretório de saída: `/tmp/jira-attachments/` (criado sob demanda, sobrevive à sessão).

## Aviso de segurança do próprio setup

O token do `~/.netrc` usado aqui precisa ser um API token clássico sem escopo: token
com escopo não funciona em Basic Auth contra a URL do site, só contra
`api.atlassian.com/ex/jira/{cloudId}` via OAuth (caminho que o MCP usa, sem suporte a
baixar o binário do anexo hoje). Na prática isso dá acesso amplo à conta Atlassian, não
só leitura de anexo. Tratar esse arquivo como credencial sensível: permissão 600, nunca
colar o conteúdo em lugar nenhum, revogar em
id.atlassian.com/manage-profile/security/api-tokens se desconfiar de vazamento.

## Setup (uma vez, fora da sessão)

1. Gerar um API token clássico (sem escopo) em
   id.atlassian.com/manage-profile/security/api-tokens.
2. Criar/editar `~/.netrc`:

```
machine ds3digital.atlassian.net
login lucas.santato@ds3digital.com
password {api-token}
```

3. `chmod 600 ~/.netrc`.

## Quando investigar uma issue (fluxo principal)

1. Chamar `getJiraIssue` (ou equivalente) com `fields` incluindo `"attachment"`, junto
   do que mais precisar (`summary`, `description`, `status`, `comment`...).
2. Se `fields.attachment` não vier vazio, baixar os anexos relevantes pra investigação:
   - Sempre baixar imagens (`image/*`), quase sempre é a evidência do bug.
   - Baixar PDF/texto/log se a issue referenciar.
   - Pular mídia grande (> 10 MB) a menos que peçam explicitamente.
3. Antes do primeiro download da sessão, avisar em uma linha que vai usar a credencial
   do `~/.netrc` pra buscar o(s) anexo(s), e seguir. Downloads seguintes dentro da mesma
   investigação não precisam de aviso novo.
4. Depois de baixar, dar `Read` em cada arquivo salvo pra entrar no contexto.
5. Só depois montar o plano/resposta.

## Comando de download

```bash
mkdir -p /tmp/jira-attachments
curl --netrc --fail --show-error --silent -L \
  -o "/tmp/jira-attachments/<ID>-<NOME_SEGURO>" \
  "https://ds3digital.atlassian.net/rest/api/3/attachment/content/<ID>"
```

- `<ID>`: vem de `attachment[].id` no payload da issue.
- `<NOME_SEGURO>`: nome original do arquivo com espaço/metacaractere de shell trocado
  por `_`, mantendo a extensão.
- Se o caminho já existir de algo baixado antes na mesma sessão, reaproveitar em vez de
  baixar de novo.

## Fluxo B — por nome do arquivo, sem ID

Quando o usuário citar um arquivo mas não o ID do anexo:

1. `getJiraIssue` com `fields: ["attachment"]`.
2. Bater `attachment[].filename` contra a pista dada (sem diferenciar
   maiúscula/minúscula, parcial serve).
3. Se mais de um bater, listar candidatos com tamanho e perguntar qual.
4. Usar o ID escolhido no comando de download acima.

Se a issue não tiver nenhum anexo, avisar isso direto.

## Retorno pro usuário

Uma linha por arquivo: `nome-original · NN KB · <caminho>`, seguido do `Read`. Não colar
saída do curl no chat.

## Modos de falha

- `401 Unauthorized` em qualquer endpoint: `.netrc` ausente, credencial errada, ou token
  com escopo (Bearer-only) no lugar de clássico. Avisar o usuário; a configuração é feita
  fora desta sessão, não tentar consertar sozinho.
- `403 Forbidden` num anexo específico: usuário do `.netrc` sem acesso àquela issue.
  Confirmar se a conta tem acesso.
- `404 Not Found`: ID errado ou desatualizado (reupload muda o ID). Buscar o metadado da
  issue de novo.
- Corpo HTML em vez do arquivo: autenticação redirecionou pro login, `.netrc`
  malconfigurado, avisar o usuário.
- Arquivo vazio: instabilidade transitória do servidor. Tentar de novo uma vez, depois
  avisar.

## Notas

- Usar a URL do site (`ds3digital.atlassian.net/rest/api/3/...`), não a forma
  `api.atlassian.com/ex/jira/{cloudId}/...` (essa é só OAuth, usada pelo MCP; Basic Auth
  via `.netrc` só funciona contra a URL do site).
- `/rest/api/3/attachment/content/{id}` redireciona (302) pra uma URL assinada da
  Atlassian, manter `-L`.
- Só download. Upload/exclusão de anexo está fora do escopo desta skill.
