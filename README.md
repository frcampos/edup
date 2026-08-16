# EduPrompt

Gerador de prompts pedagógicas para docentes, ancorado no quadro normativo português: **Decreto-Lei n.º 54/2018**, **PASEO** e **Aprendizagens Essenciais**.

**Aplicação em funcionamento:** https://cardosolopes.net/recursos/edup/eduprompt.html

---

## O problema que resolve

Três obstáculos recorrentes na utilização de IA generativa em contexto escolar:

- o tempo necessário para construir um pedido bem estruturado;
- a dificuldade em recordar todos os elementos que o pedido deve conter;
- a tendência para prompts demasiado genéricas, que devolvem materiais genéricos.

O EduPrompt converte um formulário pedagógico numa prompt estruturada — contexto, tarefa, conteúdo, requisitos, abordagens, formato e restrições — pronta a enviar a qualquer assistente de IA.

## Componentes

| Ficheiro | Função |
|---|---|
| `eduprompt.html` | Gerador de prompts |
| `repositorio_prompts.html` | Arquivo público de prompts submetidas |
| `Manual_EduPrompt_Interativo.html` | Manual de utilização e formação |

Aplicação estática: HTML, CSS e JavaScript, sem framework e sem processo de build. Abre-se com duplo clique ou serve-se de qualquer servidor de ficheiros.

## Executar localmente

```bash
git clone https://github.com/frcampos/<NOME-DO-REPOSITORIO>.git
cd <NOME-DO-REPOSITORIO>
python3 -m http.server 8000
```

Abrir `http://localhost:8000/eduprompt.html`.

## Dados e privacidade

- Os **modelos pessoais** e os **favoritos** ficam no `localStorage` do navegador. Não são enviados para lado nenhum e perdem-se ao limpar os dados do navegador.
- As **prompts geradas** são registadas automaticamente no Arquivo público quando o utilizador as copia, guarda ou envia a um assistente de IA.
- O Arquivo **não regista** o nome, a conta ou o endereço do autor. É anónimo quanto à autoria.
- O Arquivo **não regista** as respostas da IA — apenas os pedidos.

> **Aviso.** O Arquivo é público, mundial e sem autenticação. Uma prompt que contenha nomes, números de processo ou diagnósticos fica pesquisável por qualquer pessoa. Escreva sempre por **contagens e barreiras funcionais**, nunca por identificação. Ver o capítulo de proteção de dados no manual.
>
> Para remoção de um registo submetido por engano: ver [SECURITY.md](SECURITY.md).

## O que esta ferramenta não faz

- Não produz o recurso pedagógico — produz o **pedido**. A geração cabe ao assistente de IA escolhido.
- Não verifica factos nem valida conteúdo científico. Essa responsabilidade é do docente.
- Não substitui juízo profissional em matéria de medidas de suporte à aprendizagem.

## Adaptação a outros sistemas educativos

As referências legais são portuguesas, mas a estrutura é transferível: *desenho universal → barreiras funcionais → múltiplas vias de acesso → avaliação adaptada*. Substituir as referências normativas pelas do país de destino (IEP, SEN, PDI, Nachteilsausgleich) mantém o andaime intacto.

## Contribuir

Ver [CONTRIBUTING.md](CONTRIBUTING.md). Reportes de segurança em [SECURITY.md](SECURITY.md) — não abrir *issue* pública.

## Licenças

Licenciamento duplo, com fronteira explícita:

| Âmbito | Licença |
|---|---|
| Código-fonte (HTML, CSS, JavaScript) | [MIT](LICENSE) |
| Conteúdos pedagógicos, manual, documentação e textos | [CC BY-NC-SA 4.0](LICENSE-CONTEUDOS.md) |

Em caso de dúvida sobre a fronteira: se é executado por um navegador, é MIT; se é lido por uma pessoa, é CC BY-NC-SA.

## Autoria

**Fernando Rui Campos** — Agrupamento de Escolas Cardoso Lopes.

O conteúdo das prompts submetidas ao Arquivo é da responsabilidade dos respetivos autores.
