# Metodologia da análise de preferência/repelência de ácaros

## 1. Objetivo

Este projeto tem como objetivo organizar, reproduzir e documentar a análise estatística de um ensaio de dupla escolha envolvendo ácaros expostos a duas condições:

- **Tratado**
- **Não tratado / controle**

A pergunta principal da análise é verificar se os ácaros apresentam uma distribuição compatível com ausência de preferência entre os dois lados ou se ocorre maior frequência em uma das condições.

A análise foi implementada em **R**, de forma reprodutível, com os dados, scripts e resultados versionados neste repositório.

---

## 2. Hipóteses estatísticas

Para as análises de proporção realizadas em cada tempo, foram consideradas as seguintes hipóteses:

### Hipótese nula — H0

A distribuição entre tratado e não tratado é igual:

\[
p_{tratado} = p_{não\ tratado} = 0,50
\]

Ou seja, sob H0 não existe evidência de preferência por um dos lados.

### Hipótese alternativa — H1

A distribuição não é igual a 50:50:

\[
p_{tratado} \neq p_{não\ tratado}
\]

Nesse caso, existe evidência de distribuição desigual entre os dois lados.

O nível de significância adotado nas análises foi:

\[
\alpha = 0,05
\]

---

## 3. Desenho experimental informado

O experimento utiliza um sistema de **dupla escolha**, composto por disco tratado e disco não tratado/controle.

Cada repetição experimental corresponde a uma dupla de discos.

Foi informado que existem **30 ácaros por repetição**, acompanhados ao longo dos seguintes tempos:

- 1 hora;
- 3 horas;
- 6 horas;
- 12 horas;
- 24 horas;
- 48 horas.

Os indivíduos não são substituídos entre os tempos. Portanto, os mesmos ácaros são acompanhados sucessivamente ao longo do experimento.

Essa característica é importante porque estabelece uma estrutura de **medidas repetidas**, isto é, as observações realizadas em diferentes tempos não são necessariamente independentes.

---

## 4. Estrutura dos dados

A base utilizada nos scripts está localizada em:

```text
dados/dados_brutos.xlsx
```

A aba principal utilizada pelo R é:

```text
dados_brutos
```

Cada linha contém:

| Campo | Descrição |
|---|---|
| `identificador_original` | Identificação presente na tabela original |
| `tempo_h` | Tempo da observação em horas |
| `repeticao` | Número da repetição experimental |
| `tratado` | Frequência registrada para a condição tratada |
| `nao_tratado` | Frequência registrada para a condição não tratada |

Também são realizadas verificações automáticas durante a importação.

---

## 5. Verificação de consistência dos dados

Foi informado que cada repetição contém 30 ácaros.

Entretanto, algumas linhas da tabela original apresentam:

```text
tratado + não tratado > 30
```

Por exemplo, determinadas frequências registradas somam valores superiores ao número de indivíduos informado para uma repetição.

Por esse motivo, os scripts não assumem automaticamente que essas frequências representam a posição instantânea de 30 indivíduos em cada tempo.

Essa inconsistência precisa ser esclarecida experimentalmente.

É possível que os números representem:

- frequências acumuladas;
- somas de observações;
- registros produzidos por algum procedimento anterior;
- ou outra forma de agregação.

Até que essa origem seja confirmada, os testes estatísticos baseados nessas frequências devem ser interpretados com cautela.

---

# 6. Pipeline de análise

A análise foi dividida em quatro scripts.

## 6.1. Script 01 — Importação e validação

Arquivo:

```text
scripts/01_importacao.R
```

Funções principais:

1. importar o arquivo Excel;
2. verificar a existência das colunas necessárias;
3. converter as variáveis numéricas;
4. identificar valores ausentes;
5. identificar valores negativos;
6. calcular `tratado + não tratado`;
7. sinalizar registros cuja soma seja superior a 30;
8. exportar uma tabela de validação.

Os resultados são salvos em:

```text
resultados/tabelas/validacao_dados.csv
resultados/tabelas/validacao_dados.xlsx
```

---

## 6.2. Script 02 — Análise exploratória

Arquivo:

```text
scripts/02_analise_exploratoria.R
```

O objetivo é descrever o comportamento dos dados antes dos testes inferenciais.

Para cada tempo são calculados:

- total da condição tratada;
- total da condição não tratada;
- total observado;
- proporção tratada;
- proporção não tratada;
- percentual tratado;
- percentual não tratado;
- média entre repetições;
- desvio-padrão;
- erro-padrão.

O erro-padrão utilizado no script é calculado como:

\[
EP = \frac{SD}{\sqrt{n}}
\]

onde:

- `SD` = desvio-padrão entre repetições;
- `n` = número de repetições.

O script também gera um gráfico das proporções ao longo do tempo, utilizando 50% como referência visual de ausência de preferência.

Arquivos produzidos:

```text
resultados/tabelas/resumo_exploratorio.csv
resultados/tabelas/resumo_exploratorio.xlsx
resultados/graficos/proporcoes_por_tempo.png
```

---

# 7. Teste binomial exato

Arquivo:

```text
scripts/03_testes_estatisticos.R
```

Como análise exploratória, foi utilizado o **teste binomial exato**.

Para cada tempo, o teste avalia:

\[
H_0: p = 0,50
\]

contra:

\[
H_1: p \neq 0,50
\]

A condição tratada foi utilizada como categoria de referência.

O teste produz:

- proporção observada;
- valor-p;
- intervalo de confiança de 95%;
- conclusão utilizando o valor-p bruto.

Além disso, como são realizados testes em seis tempos distintos, também é aplicada a **correção de Holm para múltiplas comparações**.

São relatados:

```text
p_value
p_ajustado_holm
conclusao_p_bruto
conclusao_holm
```

Um valor-p inferior a 0,05 indica evidência contra H0 dentro das condições do teste.

Um valor-p maior ou igual a 0,05 não significa que H0 foi comprovada, mas apenas que não houve evidência estatística suficiente para rejeitá-la.

Arquivos produzidos:

```text
resultados/tabelas/teste_binomial_exato.csv
resultados/tabelas/teste_binomial_exato.xlsx
```

---

# 8. Reprodução do método utilizado anteriormente no SAS

Arquivo:

```text
scripts/04_replicacao_metodo_sas.R
```

Foi fornecida como referência uma análise anteriormente executada no SAS utilizando:

```text
PROC FREQ
Chi-Square Test for Equal Proportions
```

O método avalia se duas frequências apresentam proporções iguais.

A hipótese nula é:

\[
H_0:
p_A = p_B = 0,50
\]

O equivalente utilizado no R é:

```r
chisq.test(
  c(frequencia_A, frequencia_B),
  p = c(0.5, 0.5)
)
```

Como teste de validação da equivalência entre os softwares, foi utilizado o exemplo apresentado no resultado do SAS:

```text
testA = 33
testB = 50
```

No SAS foi obtido aproximadamente:

```text
Chi-Square = 3,4819
DF = 1
p = 0,0620
```

O script em R reproduz esse resultado, demonstrando que a implementação corresponde ao teste de proporções iguais utilizado anteriormente.

Depois da validação, o mesmo procedimento é aplicado às frequências de cada tempo experimental.

Também é calculada a correção de Holm para os testes realizados em vários tempos.

Arquivos produzidos:

```text
resultados/tabelas/replicacao_metodo_sas.csv
resultados/tabelas/replicacao_metodo_sas.xlsx
```

---

# 9. Interpretação dos resultados atuais

Descritivamente, os dados agregados apresentam maior frequência na condição não tratada em todos os tempos analisados.

As proporções observadas permanecem aproximadamente em:

```text
Tratado:      38%–40%
Não tratado:  60%–62%
```

Esse padrão sugere uma distribuição consistente em direção ao lado não tratado.

Entretanto, a interpretação inferencial deve distinguir:

1. o padrão descritivo observado;
2. o resultado estatístico de cada teste individual;
3. os resultados após correção para múltiplas comparações;
4. as limitações decorrentes do desenho experimental.

---

# 10. Medidas repetidas e independência

O principal ponto metodológico ainda em avaliação é a dependência temporal.

Os mesmos ácaros são observados em:

```text
1h → 3h → 6h → 12h → 24h → 48h
```

Portanto, as observações de diferentes tempos não devem ser consideradas automaticamente independentes.

Os testes atualmente implementados:

- teste binomial exato;
- qui-quadrado para proporções iguais;

são úteis para:

- análise exploratória;
- comparação com a metodologia anterior;
- validação da rotina estatística;
- reprodução do resultado obtido no SAS.

Entretanto, eles não modelam diretamente a correlação existente entre observações repetidas dos mesmos indivíduos/unidades experimentais.

Por isso, neste projeto, esses resultados não devem ser considerados automaticamente como a análise inferencial definitiva do experimento.

---

# 11. Pseudorreplicação

Também é necessário distinguir:

```text
número de ácaros
```

de:

```text
número de unidades experimentais independentes
```

A presença de vários indivíduos dentro da mesma arena não significa necessariamente que todos possam ser tratados como repetições experimentais independentes.

Caso múltiplos ácaros compartilhem a mesma unidade experimental, existe potencial risco de **pseudorreplicação** se cada indivíduo for tratado estatisticamente como uma réplica independente.

A definição final da unidade experimental deve ser baseada no protocolo experimental.

---

# 12. Próximas etapas metodológicas

Antes da definição do modelo estatístico definitivo, recomenda-se esclarecer:

1. O significado exato das frequências registradas como `tratado` e `não tratado`.

2. Por que algumas somas ultrapassam os 30 ácaros informados por repetição.

3. Se existe identificação individual dos ácaros ao longo do tempo.

4. Quantas unidades experimentais independentes foram utilizadas no experimento completo.

5. Se R1 e R2 são as únicas repetições ou se existem outras repetições ainda não inseridas na base.

6. Como são tratados indivíduos que ficam fora dos dois discos, quando isso ocorre.

7. Como são tratados indivíduos mortos, perdidos ou não observados.

Após essas confirmações, poderá ser avaliado um método que considere explicitamente a estrutura longitudinal/medidas repetidas.

---

# 13. Interpretação do valor-p

O valor-p não representa:

- a probabilidade de H0 ser verdadeira;
- o tamanho do efeito;
- a importância biológica da diferença.

Ele representa a compatibilidade dos dados observados com a hipótese nula, considerando o modelo estatístico utilizado.

Assim:

```text
p < 0,05
```

permite rejeitar H0 dentro das condições do teste.

Enquanto:

```text
p ≥ 0,05
```

indica que não existe evidência estatística suficiente para rejeitar H0 naquele nível de significância.

A interpretação deve ser acompanhada das proporções observadas, intervalos de confiança, desenho experimental e relevância biológica.

---

# 14. Reprodutibilidade

Para reproduzir toda a análise, executar no R, a partir da raiz do projeto:

```r
source("scripts/01_importacao.R")
source("scripts/02_analise_exploratoria.R")
source("scripts/03_testes_estatisticos.R")
source("scripts/04_replicacao_metodo_sas.R")
```

Os resultados serão gerados automaticamente nas pastas:

```text
resultados/tabelas/
resultados/graficos/
```

---

# 15. Situação atual da análise

| Etapa | Situação |
|---|---|
| Importação dos dados | Concluída |
| Validação da estrutura | Concluída |
| Análise descritiva | Concluída |
| Teste binomial exploratório | Implementado |
| Correção de Holm | Implementada |
| Reprodução do qui-quadrado do SAS | Validada |
| Avaliação de medidas repetidas | Pendente |
| Confirmação da origem das frequências > 30 | Pendente |
| Modelo inferencial definitivo | Pendente |

---

# 16. Referência metodológica interna

A organização deste projeto considera também o documento interno:

**POP-EST-REP-001 — Análise estatística de repelência no R: teste qui-quadrado e alternativa exata.**

O POP orienta a verificação da independência das observações, das frequências esperadas, da estrutura experimental e da necessidade de cautela quando existem observações repetidas ou dados agregados.

A análise implementada neste repositório amplia essas verificações para o desenho experimental atualmente informado.