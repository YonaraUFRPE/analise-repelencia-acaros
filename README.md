# analise-repelencia-acaros

# 🕷️ Análise de Repelência de Ácaros em R

Este repositório contém os dados, scripts e resultados da análise estatística de um ensaio de **dupla escolha**, comparando as frequências observadas entre:

- 🧪 **Tratado**
- 🌿 **Não tratado / controle**

A análise foi desenvolvida em **R** e pode ser executada no **RStudio** ou no **Visual Studio Code**.

> 💡 Para quem vai apenas executar e analisar os resultados em R, recomendamos utilizar o **RStudio**.

---

# 📁 Estrutura do projeto

O repositório está organizado da seguinte forma:

```text
analise-repelencia-acaros/
│
├── dados/
│   └── dados_brutos.xlsx
│
├── docs/
│   └── metodologia.md
│
├── resultados/
│   ├── graficos/
│   └── tabelas/
│
├── scripts/
│   ├── 01_importacao.R
│   ├── 02_analise_exploratoria.R
│   ├── 03_testes_estatisticos.R
│   └── 04_replicacao_metodo_sas.R
│
├── README.md
└── LICENSE
```

---

# 🖥️ 1. Instalar o R

Primeiro é necessário instalar o **R**.

Acesse:

https://cran.r-project.org/

Depois:

1. Clique em **Download R for Windows**.
2. Clique em **base**.
3. Clique em **Download R for Windows**.
4. Execute o instalador.
5. Durante a instalação, pode manter as opções padrão.
6. Finalize a instalação.

✅ Após isso, o R estará instalado no computador.

---

# 📊 2. Instalar o RStudio

Depois de instalar o R, instale o **RStudio Desktop**.

Acesse:

https://posit.co/download/rstudio-desktop/

Baixe a versão gratuita:

**RStudio Desktop**

Depois:

1. Execute o instalador.
2. Avance utilizando as opções padrão.
3. Finalize a instalação.
4. Abra o RStudio.

Se tudo estiver correto, aparecerá uma área chamada:

```text
Console
```

com o símbolo:

```text
>
```

---

# 🧪 3. Testar se o R está funcionando

No Console do RStudio, digite:

```r
1 + 1
```

Pressione **Enter**.

O resultado esperado é:

```text
[1] 2
```

Se aparecer esse resultado, o R está funcionando corretamente. ✅

---

# 🐙 4. Baixar o projeto do GitHub

## Opção mais simples: Download ZIP

Abra o link do repositório no GitHub.

Na página principal:

1. Clique no botão verde **Code**.
2. Clique em **Download ZIP**.
3. Aguarde o download.
4. Extraia o arquivo `.zip`.

No Windows:

- clique com o botão direito no arquivo;
- selecione **Extrair Tudo**.

A pasta deverá ficar semelhante a:

```text
analise-repelencia-acaros
```

⚠️ O repositório é privado.

Para acessar pelo GitHub, é necessário que o proprietário do projeto adicione seu usuário como colaborador.

---

# 📂 5. Abrir o projeto no RStudio

Abra o **RStudio**.

Depois vá em:

```text
File
→ Open Project
```

Caso não exista um arquivo `.Rproj`, utilize:

```text
File
→ New Project
→ Existing Directory
```

Clique em:

**Browse**

e selecione a pasta:

```text
analise-repelencia-acaros
```

Depois clique em:

```text
Create Project
```

O RStudio passará a utilizar a pasta do projeto como diretório principal.

---

# 📍 6. Confirmar se o RStudio está na pasta correta

No Console, execute:

```r
getwd()
```

O resultado deverá terminar com algo semelhante a:

```text
analise-repelencia-acaros
```

Por exemplo:

```text
C:/Users/NOME/Documents/analise-repelencia-acaros
```

✅ Se aparecer isso, está correto.

---

# 📦 7. Instalar os pacotes necessários

No Console do RStudio, execute:

```r
install.packages(c("readxl", "writexl"))
```

Na primeira instalação, o R pode solicitar a escolha de um servidor do CRAN.

Pode selecionar, por exemplo:

```text
Brazil (SP 1) [https]
```

ou qualquer servidor HTTPS disponível.

Aguarde a instalação terminar.

⚠️ Essa instalação precisa ser feita apenas uma vez no computador.

---

# 📚 8. Testar os pacotes

Depois da instalação, execute:

```r
library(readxl)
library(writexl)
```

Se nenhuma mensagem de erro aparecer, os pacotes estão funcionando corretamente. ✅

---

# ▶️ 9. Executar a análise

Os scripts devem ser executados **na ordem numérica**.

---

## 01 — Importação e validação

Execute:

```r
source("scripts/01_importacao.R")
```

Esse script:

- importa `dados/dados_brutos.xlsx`;
- verifica as colunas;
- verifica valores ausentes;
- verifica valores negativos;
- verifica a soma das frequências;
- gera uma tabela de validação.

Resultados:

```text
resultados/tabelas/validacao_dados.csv
resultados/tabelas/validacao_dados.xlsx
```

⚠️ Pode aparecer um aviso informando que algumas somas ultrapassam 30 ácaros.

Esse aviso já é esperado e está sendo mantido como controle metodológico.

---

## 02 — Análise exploratória

Execute:

```r
source("scripts/02_analise_exploratoria.R")
```

Esse script calcula:

- total tratado;
- total não tratado;
- proporções;
- percentuais;
- médias;
- desvios-padrão;
- erros-padrão.

Também gera um gráfico da distribuição ao longo do tempo.

Resultados:

```text
resultados/tabelas/resumo_exploratorio.csv
resultados/tabelas/resumo_exploratorio.xlsx
resultados/graficos/proporcoes_por_tempo.png
```

---

## 03 — Teste binomial exato

Execute:

```r
source("scripts/03_testes_estatisticos.R")
```

Esse script realiza um **teste binomial exato** para verificar se as frequências diferem de uma distribuição esperada de:

```text
50% tratado
50% não tratado
```

Hipóteses:

```text
H0: proporção tratado = 0,50
H1: proporção tratado ≠ 0,50
```

Também é aplicada a correção de **Holm** porque existem vários tempos sendo testados.

Resultados:

```text
resultados/tabelas/teste_binomial_exato.csv
resultados/tabelas/teste_binomial_exato.xlsx
```

---

# 🧮 04 — Reprodução do método utilizado no SAS

Execute:

```r
source("scripts/04_replicacao_metodo_sas.R")
```

Esse script reproduz no R o método anteriormente utilizado no SAS:

```text
PROC FREQ
Chi-Square Test for Equal Proportions
```

O teste compara as frequências observadas com a distribuição esperada:

```text
50% × 50%
```

O script primeiro valida o exemplo utilizado anteriormente no SAS:

```text
testA = 33
testB = 50
```

Resultado esperado aproximadamente:

```text
Chi-Square = 3,4819
DF = 1
p ≈ 0,0620
```

Depois, o mesmo teste é aplicado aos tempos:

```text
1h
3h
6h
12h
24h
48h
```

Resultados:

```text
resultados/tabelas/replicacao_metodo_sas.csv
resultados/tabelas/replicacao_metodo_sas.xlsx
```

---

# ✅ 10. Executar tudo em sequência

Também é possível executar toda a análise de uma vez:

```r
source("scripts/01_importacao.R")
source("scripts/02_analise_exploratoria.R")
source("scripts/03_testes_estatisticos.R")
source("scripts/04_replicacao_metodo_sas.R")
```

Depois disso, basta abrir:

```text
resultados/
```

---

# 📊 11. Onde ficam os resultados?

## Gráficos

```text
resultados/graficos/
```

Atualmente:

```text
proporcoes_por_tempo.png
```

---

## Tabelas

```text
resultados/tabelas/
```

São gerados automaticamente arquivos `.csv` e `.xlsx`.

Os principais são:

```text
validacao_dados.xlsx
resumo_exploratorio.xlsx
teste_binomial_exato.xlsx
replicacao_metodo_sas.xlsx
```

---

# 🔬 12. O que está sendo testado?

A pergunta principal é:

> Os ácaros apresentam preferência por um dos lados do ensaio de dupla escolha?

A hipótese nula utilizada nos testes de proporção é:

```text
H0:
50% tratado
50% não tratado
```

A hipótese alternativa é:

```text
H1:
a distribuição é diferente de 50% × 50%
```

Foi adotado:

```text
α = 0,05
```

---

# 📌 13. Como interpretar o p-value?

De forma simplificada:

### Se:

```text
p < 0,05
```

há evidência estatística suficiente para rejeitar H0 dentro das condições daquele teste.

### Se:

```text
p ≥ 0,05
```

não existe evidência estatística suficiente para rejeitar H0.

⚠️ Isso **não significa que H0 foi provada**.

Também é importante lembrar que o p-value:

- não mede o tamanho do efeito;
- não mede a importância biológica;
- não representa a probabilidade de H0 ser verdadeira.

---

# ⚠️ 14. Atenção metodológica importante

Os mesmos ácaros são observados ao longo dos tempos:

```text
1h
↓
3h
↓
6h
↓
12h
↓
24h
↓
48h
```

Portanto, existe uma estrutura de **medidas repetidas**.

Isso significa que as observações realizadas em diferentes horários não são automaticamente independentes.

Os testes atualmente implementados são utilizados para:

- reproduzir a análise anterior;
- explorar os dados;
- comparar os resultados entre R e SAS;
- verificar as frequências observadas.

Eles **não devem ser considerados automaticamente como o modelo inferencial definitivo** do experimento.

---

# ⚠️ 15. Outra questão a ser confirmada

Foi informado que cada repetição contém:

```text
30 ácaros
```

Entretanto, algumas frequências da tabela original apresentam:

```text
tratado + não tratado > 30
```

Por exemplo, existem registros em que as duas frequências somadas ultrapassam 30 indivíduos.

Portanto, ainda precisa ser confirmado se esses valores representam:

- frequências acumuladas;
- soma de múltiplas observações;
- registros derivados;
- ou outra estrutura experimental.

Os scripts sinalizam automaticamente esses casos.

---

# 📖 16. Metodologia detalhada

A explicação metodológica completa está disponível em:

```text
docs/metodologia.md
```

Esse documento apresenta:

- desenho experimental;
- hipóteses;
- organização dos dados;
- teste binomial;
- qui-quadrado;
- reprodução do SAS;
- correção de Holm;
- medidas repetidas;
- risco de pseudorreplicação;
- limitações atuais.

---

# 🛠️ 17. Se aparecer erro de arquivo não encontrado

Exemplo:

```text
Arquivo nao encontrado: dados/dados_brutos.xlsx
```

Execute:

```r
getwd()
```

Confirme se o diretório termina em:

```text
analise-repelencia-acaros
```

Caso contrário, abra novamente o projeto pelo RStudio utilizando:

```text
File
→ Open Project
```

ou:

```text
File
→ New Project
→ Existing Directory
```

---

# 🛠️ 18. Se aparecer erro de pacote

Exemplo:

```text
there is no package called 'readxl'
```

Execute:

```r
install.packages("readxl")
```

Para `writexl`:

```r
install.packages("writexl")
```

Depois:

```r
library(readxl)
library(writexl)
```

---

# 🔄 19. Como baixar uma versão nova do projeto

Se houver atualizações no GitHub e estiver utilizando o projeto por ZIP:

1. abra novamente o repositório;
2. clique em **Code**;
3. clique em **Download ZIP**;
4. extraia a versão nova.

⚠️ Antes de substituir arquivos, preserve qualquer dado novo que tenha sido inserido localmente.

---

# 💾 20. Ordem resumida para executar

Depois que R + RStudio + pacotes estiverem instalados, basta abrir o projeto e executar:

```r
source("scripts/01_importacao.R")
source("scripts/02_analise_exploratoria.R")
source("scripts/03_testes_estatisticos.R")
source("scripts/04_replicacao_metodo_sas.R")
```

Depois, consultar:

```text
resultados/tabelas/
```

e:

```text
resultados/graficos/
```

---

## ✅ Checklist rápido

Antes de começar:

- [ ] R instalado
- [ ] RStudio instalado
- [ ] Projeto baixado do GitHub
- [ ] Pasta do projeto aberta no RStudio
- [ ] Pacote `readxl` instalado
- [ ] Pacote `writexl` instalado
- [ ] `dados/dados_brutos.xlsx` presente
- [ ] Script 01 executado
- [ ] Script 02 executado
- [ ] Script 03 executado
- [ ] Script 04 executado
- [ ] Resultados conferidos

---

🧪 **Projeto de análise estatística de ensaio de dupla escolha/repelência de ácaros utilizando R.**
