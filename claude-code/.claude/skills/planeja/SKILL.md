---
name: planeja
description: Investiga um card do Jira a fundo (descrição, comentários, links, código do BFF e do SVN) e gera um prompt pronto pra colar em OUTRA sessão do Claude Code, que vai entrar em plan mode e montar o plano de implementação. Use SEMPRE que o usuário digitar /planeja, ou pedir "gera um prompt pra plano desse card", "prepara esse card pra eu implementar em outra sessão", "monta o prompt de plano", "quero levar isso pra planejar depois", ou qualquer variação que peça preparação de um card pra virar plano em outra sessão — não a implementação em si. NÃO aciona quando o usuário quer o card implementado agora nesta sessão, nem quando só quer estimativa (isso é conversa direta, não gera prompt).
---

# Planeja

Recebe a URL de um card do Jira (e observações opcionais do usuário) e devolve um
prompt pronto pra copiar/colar em outra sessão do Claude Code — que vai entrar em
plan mode e montar o plano de implementação daquele card.

**A tarefa aqui é só investigar e escrever o prompt.** Não implementar nada, não
entrar em plan mode nesta sessão, não criar a outra sessão. Termina entregando o
prompt num bloco de código, pronto pra usar.

## Uso

```
/planeja <url-do-card-jira> (observações, se existirem)
```

Extraia a chave do card (ex: `PCGRF-280`) da URL. As observações do usuário — se
houver — são contexto extra pra investigação e podem virar restrições explícitas no
prompt final (ex: "não mexer no módulo X", "já sei que Y foi decidido assim").

## Por que isso existe

Um prompt de plano bom não é "implementa o card X" — é o resultado de já ter
investigado o card a fundo *nesta* sessão, achado o que já existe, o que é novo, e
onde tem bloqueio ou ambiguidade real, pra a sessão de plano não perder tempo
redescobrindo tudo do zero nem — pior — assumir coisa errada porque não teve o
contexto. Delegar a investigação também pro plan mode é jogar fora o trabalho que
esta sessão já pode fazer com calma.

## Passo 1 — Ler o card por completo

Via MCP Atlassian (site normalmente `ds3digital.atlassian.net`, mas confirme se
mudou). Buscar:

- **Descrição inteira.**
- **Todos os comentários** — costumam ter decisão/correção que contradiz ou completa
  a descrição (ex: um "pós-daily" resumido num comentário definindo uma regra que a
  descrição não menciona). Prestar atenção na data do comentário.
- **Issue links** — clones/is cloned by, blocks/is blocked by, relates to, parent
  epic. Um card pode ser clone de outro já concluído (ver se o "concluído" é
  trabalho de verdade ou só o card original sendo splitado — checar se tem
  comentário/PR de verdade, não só o status), ou depender de um card irmão ainda no
  backlog que o card atual pressupõe existir (ex: uma ação que abre uma modal cujo
  backend é outro card).
- **Anexos/imagens** — a descrição/comentários costumam ter imagens embutidas como
  `blob:https://media.staging.atl-paas.net/...`, que não são acessíveis por fetch
  direto. Não invente o que a imagem mostra. Se algo no card depender visualmente de
  uma imagem (mockup, layout de export, tela de cadastro), isso precisa aparecer no
  prompt final como um pedido explícito pro usuário: qual anexo baixar e informar o
  caminho local (ex: `~/Downloads/arquivo.png`) pra sessão de plano ler.

## Passo 2 — Investigar o BFF (este repositório Git)

Pra cada funcionalidade/regra de negócio distinta do card, procurar se já existe
algo equivalente no código — **nunca assumir reaproveitamento só pelo nome do
arquivo/módulo bater; ler o conteúdo antes de afirmar que serve.** Interessa
especialmente:

- Módulos existentes com padrão parecido (`src/<feature>/` com
  port/use-case/mapper/adapter/controller/dto).
- Como a identidade do usuário é resolvida nos casos de uso existentes — o padrão
  atual do projeto é resolver `userId` via `USER_ID_RESOLVER_PORT`
  (`resolveInternalUserId`) no BFF **antes** de chamar o ORDS, nunca passar
  `cognito_sub` cru pra procedure Oracle. Alguns módulos mais antigos (ex:
  `financial` histórico, `acelere`) não seguem isso — são exceção documentada no
  `CLAUDE.local.md`, não modelo a copiar.
- `CLAUDE.local.md` da raiz do projeto — sempre relevante, tem os padrões de módulo
  novo e as regras de Git/SVN já estabelecidas.

## Passo 3 — Investigar o SVN (Oracle)

Working copy em `/mnt/c/SVN/Cockpit`. **Rodar `svn update` primeiro**, sempre —
antes de qualquer leitura, pra não trabalhar em cima de revisão desatualizada.

- Procurar (find/grep por palavra-chave) procedures/packages já existentes que
  cobrem pedaços do card, mesmo que parcialmente ou com propósito ligeiramente
  diferente (ex: uma procedure que já existe pro fluxo interno do Cockpit desktop,
  mas autentica por token de funcionário em vez de Cognito — ainda vale como base
  de reaproveitamento, só precisa de wrapper novo).
- **Ler o corpo inteiro da procedure antes de afirmar que ela cobre um campo/regra**
  — não só a assinatura. Um campo que o card pede pode simplesmente não estar lá.
- Prestar atenção a comentários no próprio código que revelem limitação estrutural
  real (ex: um campo hardcoded `false`/`null` com comentário explicando por quê —
  isso costuma ser um bloqueio de verdade, não suposição).
- Checar se falta validação de posse/segurança (ex: procedure recebe um ID de
  pedido/entidade sem checar se pertence ao usuário logado) — isso é achado
  relevante pro escopo, não só nota lateral.
- O `/mnt/c/SVN/Cockpit/CLAUDE.md` (se existir) **não carrega sozinho** numa sessão
  cujo diretório de trabalho é o repo Git do BFF, porque fica fora dessa árvore.
  Isso precisa ser dito explicitamente no prompt final, apontando o caminho, pra
  sessão de plano saber que precisa ler esse arquivo antes de editar algo no SVN.

## Passo 4 — Conferir nomenclatura real usada no projeto

Não assumir convenção — checar o que é praticado de fato:

- `git log --oneline` recente e `gh pr list --json number,title,headRefName` pra ver
  padrão real de nome de branch e título de PR.
- `git log` pra ver formato de mensagem de commit — comparar com o que o
  `CLAUDE.local.md` prescreve (Conventional Commits); se o histórico real não bater
  100% com o que o `CLAUDE.local.md` pede, dizer isso no prompt em vez de escolher
  um dos dois calado.
- `svn log -l 15` (ou mais) pra ver o padrão de mensagem de commit do SVN — costuma
  ser bem mais minimalista que o Git (às vezes só a chave do card, sem descrição).

## Passo 5 — Montar o prompt final

O prompt é pra uma sessão **sem nenhum contexto desta conversa** — precisa ser
autocontido. Estrutura que funciona (nessa ordem):

1. **Instrução de plan mode primeiro** — a sessão deve entrar em plan mode antes de
   qualquer edição, e buscar o card no Jira ela mesma (descrição + comentários) em
   vez de confiar cegamente só no resumo que este prompt entrega.
2. **Como lidar com anexo/imagem** — se precisar ver algo visual do card, pedir ao
   usuário pra baixar e informar o caminho do arquivo local, nunca tentar acessar a
   blob URL.
3. **"Contexto já levantado"** — tudo que foi confirmado lendo código nos passos 2 e
   3, com arquivo (e linha, quando fizer diferença) citado por afirmação. Separar
   claramente:
   - o que já existe e serve de base (citar arquivo);
   - o que é bloqueio real, com a evidência concreta que sustenta isso (não incluir
     bloqueio especulativo sem evidência de código);
   - o que está em aberto/ambíguo — **instruir explicitamente a sessão a não
     assumir a resposta**, e sim perguntar ao usuário ou tratar como pendência
     explícita no plano.
4. **Onde ficam os repositórios** (BFF = este projeto; SVN = caminho completo) e o
   lembrete do `CLAUDE.md` do SVN não carregar sozinho.
5. **Nomenclatura** — o que foi confirmado no passo 4, incluindo qualquer
   divergência entre o documentado e o praticado, sem decidir sozinho qual seguir
   quando havia tensão real — apontar pro usuário revisar/aprovar antes de commitar.
6. **O que o plano final precisa conter obrigatoriamente** — normalmente: separar
   reaproveitamento de trabalho novo, tratar pontos em aberto como perguntas
   explícitas (não decisões já tomadas), incluir qualquer achado de segurança como
   obrigatório, excluir explicitamente o que for bloqueio confirmado sem solução
   viável agora.

## Regras de conduta

- **Só gera o prompt.** Não entrar em plan mode, não implementar, não abrir outra
  sessão — isso é decisão e ação do usuário.
- **Nada de bloqueio ou reaproveitamento inventado.** Cada afirmação no prompt final
  precisa ter vindo de ter lido o card, o código do BFF ou o SVN nesta sessão — não
  de suposição por nome de arquivo/módulo parecido.
- Quando não der pra confirmar algo (ex: não achou geração de PDF de pedido em lugar
  nenhum, mas existe algo parecido pra outro propósito), dizer isso como está —
  "não confirmei, investigue antes de assumir que serve" — em vez de apagar a
  incerteza.
- Terminar a resposta com o prompt final num bloco de código, e nada essencial
  depois dele — é pra ser copiável direto.
