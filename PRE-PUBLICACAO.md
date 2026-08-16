# Verificação pré-publicação

Executar **na raiz do repositório, antes de mudar a visibilidade para público**. Ficheiro de uso interno — apagar do repositório depois de concluído.

---

## 1 · Varrer o histórico completo, não os ficheiros atuais

Apagar num commit novo **não remove nada**. O que interessa é o histórico.

```bash
# Segredos e endpoints
git log -p --all | grep -inE "api[_-]?key|apikey|token|secret|senha|password|bearer|authorization" | head -40

# Endpoints de escrita do Arquivo
git log -p --all | grep -inE "https?://[^ \"']+(api|write|submit|insert|post)" | head -40

# Indícios de dados pessoais
git log -p --all | grep -inE "n\.?º? ?processo|encarregado|@(gmail|hotmail|sapo|outlook)" | head -40

# Ficheiros de dados alguma vez versionados
git log --all --pretty=format: --name-only --diff-filter=A | sort -u | grep -iE "\.(xlsx|xls|csv|ods|db|sqlite)$"
```

**Se algo aparecer:** limpar com `git filter-repo` (instalar com `pip install git-filter-repo`) e forçar o push. Rodar de imediato qualquer credencial exposta — considerá-la comprometida, mesmo que removida.

```bash
git filter-repo --path <ficheiro-a-remover> --invert-paths
```

## 2 · Verificar o estado atual

```bash
git ls-files | grep -iE "\.(xlsx|xls|csv|ods)$"     # deve devolver vazio
grep -rniE "api[_-]?key|token|secret" --include="*.js" --include="*.html" .
```

## 3 · Endpoint do Arquivo — o ponto crítico

O URL de escrita já está no JavaScript do lado do cliente, logo **já é público de facto**. Publicar o repositório não o expõe mais — mas expõe a sua *lógica*, e isso baixa o custo do abuso.

Confirmar, antes de publicar, que o backend tem:

- [ ] limite de tamanho por submissão;
- [ ] limite de taxa por IP;
- [ ] validação dos campos aceites (rejeitar o que não corresponda ao esquema);
- [ ] sanitização de HTML na submissão **e** na leitura;
- [ ] procedimento de remoção de um registo, testado e funcional;
- [ ] cópia de segurança da base do Arquivo.

**Este é o único item verdadeiramente bloqueante desta lista.**

## 4 · Substituições no pacote de ficheiros

- [x] `SECURITY.md` — email de contacto preenchido (`frcamposri@gmail.com`)
- [ ] `README.md` — substituir `<NOME-DO-REPOSITORIO>`
- [ ] `README.md` — inserir o nome de um **co-*maintainer***

## 5 · Ativar no separador Security do GitHub

- [ ] Secret scanning + **push protection**
- [ ] Dependabot alerts
- [ ] CodeQL (*Default setup*, deteta XSS em JavaScript)
- [ ] Private vulnerability reporting
- [ ] Settings → Branches → proteger `main` contra *force push*

## 6 · Depois de público

- [ ] Confirmar que o GitHub Pages **não** está ativo por engano se o repositório contiver algo não destinado a publicação
- [ ] Criar a *tag* `v1.0.0` — permite referir uma versão concreta em ata ou reunião de departamento
- [ ] Verificar que as ligações do README abrem

---

## Riscos que este processo **não** elimina

1. **Dados pessoais já no Arquivo**, submetidos por docentes. Vivem na base de dados, não no repositório. Exigem revisão periódica do conteúdo, não limpeza de código.
2. **Dependência de pessoa única.** Publicar não resolve; nomear um co-*maintainer* resolve.
3. **XSS no Arquivo.** É o vetor mais provável em toda a aplicação: texto submetido por qualquer pessoa, sem autenticação, mostrado a todos. A sanitização na leitura é a última linha de defesa e tem de existir.
