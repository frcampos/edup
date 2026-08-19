# EduPrompt no Mac — do zero à publicação

Fernando Rui Campos · CC BY-NC-SA

---

## Decisão de arquitetura: **um** repositório, não três

Os três ficheiros ligam-se por caminhos relativos. Em repositórios separados ficariam em endereços diferentes e os links partiam-se. Um repositório, um `main`, quatro páginas:

```
edup/                                 ← o repositório
├── index.html                        ← porta de entrada (novo)
├── eduprompt.html                    ← gerador
├── repositorio_prompts.html          ← arquivo
├── Manual_EduPrompt_Interativo.html  ← manual
├── README.md  LICENSE  LICENSE-CONTEUDOS.md
├── SECURITY.md  CONTRIBUTING.md  .gitignore
└── .github/workflows/verificacao.yml
```

Se um dia um componente ganhar vida própria, separa-se nessa altura. Começar separado paga o custo de imediato sem colher benefício nenhum.

---

## Passo 1 · Preparar o Mac (uma vez)

Abrir o **Terminal** (Cmd+Espaço → «Terminal»).

```bash
# Git — vem com as ferramentas de linha de comandos da Apple
xcode-select --install          # se já estiver instalado, dá erro inofensivo
git --version                   # confirmar

# Identidade (aparece em cada commit)
git config --global user.name "Fernando Rui Campos"
git config --global user.email "frcamposri@gmail.com"
git config --global init.defaultBranch main

# GitHub CLI — simplifica tudo o resto
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gh
gh auth login
```

Em `gh auth login` responda: **GitHub.com** → **HTTPS** → **Yes** → **Login with a web browser**.

> ⚠️ **Não coloque a pasta do projeto no iCloud Drive, no Ambiente de Trabalho nem em Documentos se tiver o iCloud ativo.** O iCloud sincroniza e às vezes descarrega ficheiros da pasta `.git`, corrompendo o repositório. A pasta de destino `/Users/fernandocampos/edup` está diretamente na pasta pessoal, fora de Desktop/Documents, pelo que fica salvaguardada mesmo com o iCloud ativo.

```bash
mkdir -p /Users/fernandocampos/edup && cd /Users/fernandocampos/edup
```

---

## Passo 2 · Montar a pasta

1. A pasta `/Users/fernandocampos/edup` já foi criada no passo anterior.
2. Copiar para lá os **três HTML** do EduPrompt.
3. Copiar os ficheiros do pacote: `index.html`, `README.md`, `LICENSE`, `LICENSE-CONTEUDOS.md`, `SECURITY.md`, `CONTRIBUTING.md`, `.gitignore`, `PRE-PUBLICACAO.md`, `preparar_eduprompt.sh` e a pasta `.github`.

> Para ver os ficheiros que começam por ponto no Finder: **Cmd+Shift+.**

4. Confirmar que os nomes coincidem com os do `index.html`. Se forem diferentes, edite os três `href` do `index.html` — **o macOS distingue maiúsculas de minúsculas no servidor**, ainda que o Finder pareça não distinguir. `Manual.html` e `manual.html` são ficheiros diferentes para o GitHub Pages.

---

## Passo 3 · Correr o script de preparação

```bash
cd /Users/fernandocampos/edup
bash preparar_eduprompt.sh
```

Verifica os ficheiros, limpa os `.DS_Store`, procura credenciais e dados, e faz o primeiro commit **local**. Nada sai do computador ainda.

---

## Passo 4 · Enviar para o GitHub, em privado

```bash
gh repo create edup --private --source=. --remote=origin --push
```

Confirme em `github.com/frcampos/edup` que só lá está o que devia.

> ⚠️ **Mantenha privado** até confirmar o endurecimento do endpoint de escrita do Arquivo (ponto 3 do `PRE-PUBLICACAO.md`). É o único bloqueante real.

---

## Passo 5 · Tornar público e ativar

```bash
gh repo edit --visibility public --accept-visibility-change-consequences
```

Depois, na página do repositório:

- **Settings → Code security**: Secret scanning, **Push protection**, Dependabot, CodeQL, Private vulnerability reporting;
- **Settings → Pages**: Source *Deploy from a branch* → `main` → `/ (root)` → **Save**;
- **Settings → Branches**: proteger `main` contra *force push*.

Ao fim de um ou dois minutos: **`https://frcampos.github.io/edup/`**

---

## Passo 6 · Um nome curto

Do mais fácil para o melhor:

| Opção | Endereço | Custo | Observação |
|---|---|---|---|
| Repositório com nome curto | `frcampos.github.io/edup/` | — | Já é o caso |
| Repositório `frcampos.github.io` | `frcampos.github.io/` | — | O mais curto sem domínio próprio |
| Subdomínio do domínio da escola | `edup.cardosolopes.net` | — | **Recomendado.** Já controla o domínio |
| Domínio próprio | `eduprompt.pt` | ~15 €/ano | Independente da escola |

### Subdomínio — como fazer

1. No painel de DNS do `cardosolopes.net`, criar um registo **CNAME**:
   `edup` → `frcampos.github.io`
2. No repositório: **Settings → Pages → Custom domain** → `edup.cardosolopes.net` → **Save**.
3. Esperar a validação e marcar **Enforce HTTPS**.

O GitHub cria um ficheiro `CNAME` na raiz — faça `git pull` antes de continuar a trabalhar.

> ⚠️ **Risco institucional a ponderar.** Um subdomínio da escola dá autoridade ao projeto, mas amarra-o à instituição: se um dia sair do agrupamento, o endereço deixa de ser seu. Um domínio próprio custa 15 €/ano e é portável. Se o objetivo é durar mais do que a sua permanência na escola, o domínio próprio é a escolha certa — e pode apontar ambos para o mesmo sítio.

---

## Passo 7 · Estatísticas de acesso

O GitHub Pages **não** tem estatísticas. O separador *Insights → Traffic* do repositório mostra visitas ao **código**, não ao site, e só guarda 14 dias.

| Solução | Custo | RGPD | Nota |
|---|---|---|---|
| **Cloudflare Web Analytics** | Grátis | **Sem cookies** | Recomendada |
| Plausible / Umami (alojado) | ~9 €/mês | Sem cookies | Melhor interface |
| Umami auto-alojado | Grátis | Sem cookies | Exige servidor |
| Google Analytics | Grátis | **Problemático** | Ver aviso |

### Cloudflare Web Analytics — instalação

O ecossistema vive em dois sítios ao mesmo tempo: `cardosolopes.net` (produção atual) e `frcampos.github.io/edup` (novo). Para saber qual está efetivamente a ser usado, cada domínio precisa do seu próprio *token* — mas o Cloudflare **não permite dois `<script>` de beacon na mesma página**. A solução está já pronta: `analytics.js`, um único ficheiro que escolhe o token certo consoante o domínio onde a página corre naquele momento. As quatro páginas incluem-no da mesma forma; nada muda entre os dois sítios.

1. Conta gratuita em `dash.cloudflare.com`.
2. **Web Analytics → Add a site** → hostname `cardosolopes.net` → **Done** → copiar o token de **Manage site**.
3. Repetir para `frcampos.github.io` → copiar o segundo token.
4. Abrir `analytics.js` e substituir os dois marcadores:
   ```js
   var TOKENS = {
     "cardosolopes.net":   "TOKEN_CARDOSOLOPES_AQUI",   // ← colar aqui
     "frcampos.github.io": "TOKEN_GITHUB_AQUI"          // ← colar aqui
   };
   ```
5. `git add . && git commit -m "Ativa estatísticas de acesso por domínio" && git push`.

Cada página no `frcampos.github.io` reporta ao token do GitHub; as mesmas páginas em `cardosolopes.net` reportam ao token da escola. Dois painéis separados no Cloudflare, uma só base de código.

Dá visitas, páginas mais vistas, origem do tráfego, país e dispositivo. Sem cookies, sem identificar pessoas, **sem necessidade de banner de consentimento**.

> ⚠️ **Não use Google Analytics num projeto escolar.** Usa cookies, exige consentimento explícito, e a transferência de dados para os EUA já levou várias autoridades europeias de proteção de dados a considerá-la ilegal. Num projeto que ensina RGPD a docentes, seria contraditório.

---

## Trabalho diário, a partir daqui

```bash
cd /Users/fernandocampos/edup
git pull                                  # antes de começar
# ... editar os HTML ...
git status                                # ver o que mudou
git add .
git commit -m "Corrige ligação do manual para o Arquivo"
git push                                  # o site republica sozinho
```

Entre o `push` e o site atualizado passam um a dois minutos. Se não mudar, force o recarregamento com **Cmd+Shift+R**.

---

## Problemas típicos no Mac

| Sintoma | Causa e solução |
|---|---|
| `.DS_Store` aparece no GitHub | Finder. O script já o bloqueia; se escapou: `git rm --cached .DS_Store` |
| Ligações partidas só online | Maiúsculas nos nomes. No servidor, `Manual.html` ≠ `manual.html` |
| `xcrun: error` | Falta `xcode-select --install` |
| Repositório corrompido | Pasta dentro do iCloud Drive (Desktop/Documentos). Mova para `/Users/fernandocampos/edup` |
| `Permission denied (publickey)` | Autenticação. Refaça `gh auth login` |
| Ficheiros abertos em TextEdit ficam `.rtf` | Use VS Code: `brew install --cask visual-studio-code` |

---

## O que fica por resolver

1. **Endpoint do Arquivo.** O único bloqueante. XSS é o vetor mais provável de toda a aplicação: texto de qualquer pessoa, sem autenticação, mostrado a todos.
2. **Dados pessoais já no Arquivo.** Vivem na base de dados, não no repositório. Exigem revisão periódica do conteúdo.
3. **Dependência de pessoa única.** Nenhuma configuração resolve. Um colega com acesso de escrita, sim.
