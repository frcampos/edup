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

## 3 · O Arquivo — avaliação real (Google Forms + Sheets, não backend próprio)

Verificado por leitura de código e por teste prático (payloads de XSS injetados via `ingest()` num browser real, em `cardHTML` e em `openModal`): **zero execução**. `esc()` é aplicado de forma consistente em toda a superfície de saída; o identificador mostrado é recalculado no browser (hash, charset seguro) e nunca o valor submetido; o campo `destino` usa lista branca. Não há vulnerabilidade de XSS armazenado nos caminhos testados.

- [x] Escape sistemático confirmado (`esc()`) — nada a corrigir
- [x] `id_prompt` não é refletido diretamente — seguro por construção
- [x] `destino` filtrado por lista branca — seguro por construção

**O que fica por resolver — e não é um bloqueio à publicação do repositório:**

- [ ] Qualquer pessoa com as `entry.NNNNNN` pode submeter diretamente ao Google Forms, ignorando a interface do gerador. **Isto já é verdade hoje, no site em produção** — os `entry.NNNNNN` estão visíveis a quem abrir "Ver código-fonte" em `cardosolopes.net/.../eduprompt.html`. Tornar o repositório GitHub público **não aumenta esta exposição**; o código já está de facto público.
- [x] Confirmado com Fernando: o campo `prompt` é "Texto de resposta longa" — sem validação de comprimento disponível nesse tipo de campo. Ver nota abaixo.
- [ ] Não existe CAPTCHA nem limite de taxa nativo em formulários anónimos do Google Forms. A defesa prática contra abuso de volume continua a ser a moderação e o canal de remoção já documentado no `SECURITY.md`.
- [ ] Nota de severidade baixa: um `id_prompt` forjado pode inflacionar artificialmente a contagem "repetida ×N" de um registo legítimo (efeito cosmético, sem risco de execução de código nem de corrupção do texto mostrado).
- [ ] **Nota registada, sem ação — decisão de 2026-08-16.** O campo `prompt` no Google Forms é "Texto de resposta longa", que não suporta validação de comprimento nativa. Um texto anormalmente longo (acidental ou deliberado) não é risco de segurança — não permite execução de código —, apenas pode degradar a leitura de um registo ou o desempenho da página. Fernando decidiu não aplicar limite por agora. Retomar se algum dia se observar um registo assim no Arquivo: opção mais simples é um limite de comprimento em `repositorio_prompts.html` ao guardar `r.full`.

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
