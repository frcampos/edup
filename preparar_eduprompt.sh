#!/bin/bash
# ============================================================
#  Preparar o repositorio EduPrompt  ·  macOS
#  Autor: Fernando Rui Campos  ·  Licenca: CC BY-NC-SA
#
#  Correr DENTRO da pasta onde estao os 3 ficheiros HTML:
#      cd ~/Documents/eduprompt
#      bash preparar_eduprompt.sh
# ============================================================

set -e
UTIL="frcampos"
REPO="edup"

echo ""
echo "==> 1. Verificar os ficheiros do ecossistema"
FALTA=0
for f in eduprompt.html repositorio_prompts.html Manual_EduPrompt_Interativo.html index.html; do
  if [ -f "$f" ]; then echo "    OK   $f"
  else echo "    FALTA  $f"; FALTA=1; fi
done
if [ "$FALTA" = "1" ]; then
  echo ""
  echo "  ERRO: coloque todos os ficheiros nesta pasta antes de continuar."
  echo "  Se os nomes forem outros, edite o index.html e este script."
  exit 1
fi

echo ""
echo "==> 2. Ficheiros de governanca"
for f in README.md LICENSE LICENSE-CONTEUDOS.md SECURITY.md CONTRIBUTING.md .gitignore; do
  [ -f "$f" ] && echo "    OK   $f" || echo "    FALTA  $f  (copie do pacote enviado)"
done
mkdir -p .github/workflows

echo ""
echo "==> 3. Bloquear o .DS_Store do macOS"
# O Finder cria .DS_Store em cada pasta visitada. Sem isto, vai parar ao GitHub.
grep -q "^.DS_Store$" .gitignore 2>/dev/null || echo ".DS_Store" >> .gitignore
find . -name ".DS_Store" -not -path "./.git/*" -delete 2>/dev/null || true
echo "    .DS_Store ignorado e limpo"

echo ""
echo "==> 4. Verificacao de seguranca antes do primeiro commit"
DADOS=$(find . -type f \( -name "*.xlsx" -o -name "*.xls" -o -name "*.csv" -o -name "*.ods" \) -not -path "./.git/*" 2>/dev/null || true)
if [ -n "$DADOS" ]; then
  echo "    ATENCAO — ficheiros de dados encontrados nesta pasta:"
  echo "$DADOS" | sed 's/^/      /'
  echo "    Estao cobertos pelo .gitignore, mas confirme que nao devem sair daqui."
else
  echo "    Sem ficheiros de dados na pasta."
fi

SEGREDOS=$(grep -rilE "api[_-]?key|apikey|secret|bearer [a-z0-9]{20,}" --include="*.html" --include="*.js" . 2>/dev/null || true)
if [ -n "$SEGREDOS" ]; then
  echo "    ATENCAO — possiveis credenciais em:"
  echo "$SEGREDOS" | sed 's/^/      /'
  echo "    Verifique ANTES de tornar o repositorio publico."
else
  echo "    Sem credenciais aparentes."
fi

echo ""
echo "==> 5. Inicializar o Git"
if ! command -v git >/dev/null 2>&1; then
  echo "  ERRO: o Git nao esta instalado."
  echo "  Instale com:  xcode-select --install"
  exit 1
fi
if [ -z "$(git config --global user.email)" ] || [ -z "$(git config --global user.name)" ]; then
  echo "  ERRO: identidade do Git por configurar. Execute uma vez:"
  echo ""
  echo "    git config --global user.name \"Fernando Rui Campos\""
  echo "    git config --global user.email \"frcamposri@gmail.com\""
  echo ""
  echo "  Depois volte a correr este script."
  exit 1
fi
if [ -d ".git" ]; then
  echo "    Ja existe repositorio Git nesta pasta. Nada feito."
else
  git init -q
  git branch -M main
  git add .
  git commit -q -m "Versao inicial do ecossistema EduPrompt"
  echo "    Repositorio criado, primeiro commit feito (ainda LOCAL)."
fi

echo ""
echo "==> 6. O que ficou versionado"
git ls-files | sed 's/^/    /'

cat <<FIM

============================================================
 PROXIMOS PASSOS (a fazer por si, com atencao)
============================================================

 1. Criar o repositorio PRIVADO no GitHub:
      gh repo create $REPO --private --source=. --remote=origin --push

    (Sem o gh: criar em github.com/new, VAZIO, e depois:)
      git remote add origin https://github.com/$UTIL/$REPO.git
      git push -u origin main

 2. NAO tornar publico ainda. Confirmar primeiro o endurecimento
    do endpoint de escrita do Arquivo — ver PRE-PUBLICACAO.md.

 3. Depois de publico: Settings > Pages > main > / (root)
    O ecossistema fica em:  https://$UTIL.github.io/$REPO/

============================================================
FIM
