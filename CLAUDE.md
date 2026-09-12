# Estrutura de branches deste repo

Uso este repo em 3 máquinas: desktop Windows com Ubuntu no WSL, desktop Omarchy e
notebook Omarchy.

- `main`: branch base, compartilhada entre as máquinas. É onde entra qualquer mudança
  que não seja específica de uma máquina.
- `notebook`: só diverge da `main` em config específica do notebook (hoje,
  `hyprland-omarchy/.config/hypr/monitors.lua`, por causa do layout de monitor
  diferente). Fora isso, deve ter o mesmo conteúdo da `main`.
- `laptop`: existe no remoto mas está em desuso, não sincronizar.

## Procedimento padrão após dar push na `main`

Sempre que um commit for enviado pra `main`, fazer merge da `main` pra dentro da
`notebook` (`git checkout notebook && git merge main && git push origin notebook`) e
dar push. Isso mantém a `notebook` atualizada sem perder o override de monitor. Não
costuma dar conflito, já que a única diferença de propósito é o `monitors.lua`; se
aparecer conflito nesse arquivo, manter a versão da `notebook`.
