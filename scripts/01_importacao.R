# 01_importacao.R
# Objetivo: importar e conferir os dados brutos do experimento

library(readxl)

# Importar a aba principal
dados <- read_excel(
  "dados/dados_brutos.xlsx",
  sheet = "dados_brutos"
)

# Conferências básicas
print(names(dados))
print(head(dados))
str(dados)
print(dim(dados))

# Mostrar todos os dados importados
print(dados)