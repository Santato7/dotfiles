---
name: explica
description: Explica um assunto do zero, partindo do negócio e chegando no técnico, para alguém que não conhece o vocabulário envolvido. Use SEMPRE que o usuário digitar /explica, ou pedir "me explica esse card", "explica esse PR", "não entendi nada", "me explica antes", "o que é isso", "explica esse código", "explica esse conceito", "primeiro me explica", ou qualquer variação que peça entendimento antes da execução. Aciona tanto para cards do Jira quanto para PRs, trechos de código, pacotes PL/SQL, conceitos de NestJS/Oracle/AWS, siglas e jargão. NÃO aciona quando o usuário só quer o resultado de uma tarefa.
---

# Explica

Explicação de baixo para cima, para quem não tem o vocabulário do assunto ainda.

## Para quem é

O usuário é **desenvolvedor Delphi experiente**, novo em NestJS, arquitetura hexagonal,
Oracle/ORDS e no ecossistema AWS. Ele entende programação muito bem — o que falta é
vocabulário e os "porquês" das convenções desses stacks. Então:

- **Nunca** explicar o que é variável, laço, exceção, transação, índice.
- **Sempre** explicar sigla, jargão de framework e convenção que não existe no mundo Delphi.
- Analogia com Delphi quando encurtar o caminho — mas só quando for honesta, não forçar.

## A estrutura que funciona

Nesta ordem. É a ordem que faz a explicação "colar".

### 1. Começar pelo negócio, não pelo código

Quem é o usuário real, o que ele está tentando fazer, por que isso existe. Uma pessoa
concreta com um problema concreto. Só depois disso o código significa alguma coisa.

Se for um card, é aqui que as regras de negócio (RN01, RN02...) entram — agrupadas pelo
que elas querem dizer juntas, não recitadas uma a uma.

### 2. Mostrar o caminho do dado

As camadas, com um diagrama ASCII simples, e **uma linha** dizendo o que cada uma faz:

```
Angular  →  BFF (NestJS)  →  ORDS  →  pacote Oracle  →  middleware  →  Gestão
```

Aqui é onde se diz o que é de casa e o que é de terceiro — isso muda tudo na leitura
do resto.

### 3. Aterrissar no concreto

As rotas, as assinaturas, os nomes de arquivo de verdade. Curto. É a âncora para o
usuário achar as coisas depois.

### 4. Fechar com as restrições que explicam o resto

A parte mais valiosa: **"as N coisas que tornam isso mais chato do que parece"**.

São os fatos não óbvios do ambiente — o sistema de terceiro que não filtra por cliente,
o middleware que falha 1 em 4, a operação que não tem desfazer. Quase toda decisão
estranha de código sai de uma dessas. Listadas aqui, o que vier depois (review, bug,
proposta de mudança) fica auto-explicativo em vez de precisar de justificativa a cada item.

## Regras de conduta

- **Explicar é a tarefa.** Não emendar o review/a análise/o conserto na mesma resposta.
  Terminar oferecendo o próximo passo e esperar.
- **Separar o que foi verificado do que foi inferido.** Se uma sigla ou um comportamento
  foi deduzido do contexto e não confirmado, dizer isso na hora — e, quando fizer
  diferença, sugerir com quem confirmar.
- **Jargão próprio conta.** Se usar "nit", "QAS", "idempotente", "circuit breaker",
  explicar na hora ou não usar. O usuário perguntar o que significa uma palavra é sinal
  de que ela devia ter vindo explicada.
- Sem bajulação e sem encher linguiça. Denso e curto ganha de longo e macio.

## Fontes, conforme o assunto

- **Card do Jira** — ler descrição *e* comentários (MCP Atlassian). Os comentários costumam
  ter a decisão que contradiz a descrição.
- **PR** — `gh pr view <n>` e `gh pr diff <n>`; o corpo do PR normalmente já traz o
  "porquê" das decisões.
- **Oracle/PL-SQL** — o working copy SVN em `/mnt/c/SVN/Cockpit` (`svn update` antes de ler,
  `svn log -v`, `svn diff -c <rev>`).
- **Código do BFF** — o repo, mais o `CLAUDE.local.md`, que tem os padrões estabelecidos.

Ler antes de explicar. Explicação inventada é pior que nenhuma.
