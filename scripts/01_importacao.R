# ============================================================
# 01_importacao.R
# Importacao e validacao inicial dos dados
# ============================================================

library(readxl)
library(writexl)

# Pastas de saida
if (!dir.exists("resultados/tabelas")) {
  dir.create("resultados/tabelas", recursive = TRUE)
}

if (!dir.exists("resultados/graficos")) {
  dir.create("resultados/graficos", recursive = TRUE)
}

# Arquivo de entrada
arquivo <- "dados/dados_brutos.xlsx"

if (!file.exists(arquivo)) {
  stop(paste("Arquivo nao encontrado:", arquivo))
}

# Importar a aba principal
dados <- read_excel(
  arquivo,
  sheet = "dados_brutos"
)

# Colunas obrigatorias
colunas_necessarias <- c(
  "tempo_h",
  "repeticao",
  "tratado",
  "nao_tratado"
)

if (!all(colunas_necessarias %in% names(dados))) {
  stop(
    paste(
      "A planilha precisa conter as colunas:",
      paste(colunas_necessarias, collapse = ", ")
    )
  )
}

# Converter para numerico
dados$tempo_h <- as.numeric(dados$tempo_h)
dados$repeticao <- as.numeric(dados$repeticao)
dados$tratado <- as.numeric(dados$tratado)
dados$nao_tratado <- as.numeric(dados$nao_tratado)

# Validacoes basicas
if (anyNA(dados[, colunas_necessarias])) {
  warning("Existem valores ausentes nas colunas principais.")
}

if (
  any(dados$tratado < 0, na.rm = TRUE) ||
  any(dados$nao_tratado < 0, na.rm = TRUE)
) {
  stop("Foram encontrados valores negativos nas contagens.")
}

# Numero de acaros informado para cada repeticao
N_ACAROS_DECLARADO <- 30

dados$soma_linha <- dados$tratado + dados$nao_tratado

dados$flag_maior_que_30 <-
  dados$soma_linha > N_ACAROS_DECLARADO

if (any(dados$flag_maior_que_30, na.rm = TRUE)) {

  warning(
    paste0(
      "ATENCAO: ha linhas em que tratado + nao_tratado > ",
      N_ACAROS_DECLARADO,
      ". Como foi informado que cada repeticao acompanha 30 acaros, ",
      "isso sugere que os valores da planilha podem ser agregados/cumulativos ",
      "e nao contagens instantaneas simples por arena."
    )
  )
}

# Exibir conferencias
cat("\n================ IMPORTACAO ================\n\n")

print(names(dados))

cat("\nDimensoes (linhas, colunas):\n")
print(dim(dados))

cat("\nPrimeiras linhas:\n")
print(head(dados))

cat("\nEstrutura:\n")
str(dados)

# Tabela de validacao
validacao <- dados[, c(
  "tempo_h",
  "repeticao",
  "tratado",
  "nao_tratado",
  "soma_linha",
  "flag_maior_que_30"
)]

write.csv(
  validacao,
  "resultados/tabelas/validacao_dados.csv",
  row.names = FALSE
)

write_xlsx(
  list(validacao = validacao),
  "resultados/tabelas/validacao_dados.xlsx"
)

cat("\nImportacao concluida.\n")
cat("Validacao salva em resultados/tabelas/.\n")