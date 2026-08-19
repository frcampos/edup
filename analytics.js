/* ============================================================================
   analytics.js — Cloudflare Web Analytics, por domínio.
   Autor: Fernando Rui Campos | Licença: CC BY-NC-SA

   Um único ficheiro, incluído nas quatro páginas do ecossistema. Escolhe o
   token correto consoante o domínio onde a página está a correr — o mesmo
   HTML serve, sem alterações, tanto em cardosolopes.net como em GitHub Pages.

   Preencher os dois tokens abaixo depois de criar cada "site" no painel
   Cloudflare (Web Analytics → Add a site). Um domínio sem token aqui listado
   simplesmente não é medido — inclui automaticamente o file:// e o
   localhost durante testes, sem necessidade de os excluir à parte.
   ============================================================================ */
(function () {
  "use strict";

  var TOKENS = {
    "cardosolopes.net":     "8952d64ef9d04ddb92504d3bf0f8289b",
    "frcampos.github.io":   "052252b6518e4b2fa5dfbac0e16ac297"
    // Se um dia ativar o subdomínio próprio, acrescente aqui:
    // "edup.cardosolopes.net": "TOKEN_SUBDOMINIO_AQUI"
  };

  var host = String(location.hostname || "").replace(/^www\./, "");
  var token = TOKENS[host];

  if (!token || token.indexOf("_AQUI") !== -1) return; // domínio não configurado, ou token por preencher

  var s = document.createElement("script");
  s.type = "module";   // formato atual do beacon Cloudflare (substitui 'defer')
  s.src = "https://static.cloudflareinsights.com/beacon.min.js";
  s.setAttribute("data-cf-beacon", JSON.stringify({ token: token }));
  document.head.appendChild(s);
})();
