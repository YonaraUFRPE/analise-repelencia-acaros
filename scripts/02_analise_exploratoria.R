# ============================================================
# 02_analise_exploratoria.R
# Resumo descritivo das frequencias por tempo
# ============================================================

library(writexl)

if (!exists("dados")) {
  source("scripts/01_importacao.R")
}

# Trabalhar somente com as colunas necessarias
dados_base <- dados[, c(
  "tempo_h",
  "repeticao",
  "tratado",
  "nao_tratado"
)]

# Tempos existentes
tempos <- sort(unique(dados_base$tempo_h))

resumos <- vector(
  "list",
  length(tempos)
)

for (i in seq_along(tempos)) {

  tempo <- tempos[i]

  x <- dados_base[
    dados_base$tempo_h == tempo,
  ]

  tratado_total <-
    sum(
      x$tratado,
      na.rm = TRUE
    )

  nao_tratado_total <-
    sum(
      x$nao_tratado,
      na.rm = TRUE
    )

  total_observado <-
    tratado_total +
    nao_tratado_total

  resumos[[i]] <- data.frame(

    tempo_h = tempo,

    n_repeticoes =
      nrow(x),

    tratado_total =
      tratado_total,

    nao_tratado_total =
      nao_tratado_total,

    total_observado =
      total_observado,

    prop_tratado =
      tratado_total /
      total_observado,

    prop_nao_tratado =
      nao_tratado_total /
      total_observado,

    percentual_tratado =
      100 *
      tratado_total /
      total_observado,

    percentual_nao_tratado =
      100 *
      nao_tratado_total /
      total_observado,

    media_tratado =
      mean(
        x$tratado,
        na.rm = TRUE
      ),

    media_nao_tratado =
      mean(
        x$nao_tratado,
        na.rm = TRUE
      ),

    sd_tratado =
      sd(
        x$tratado,
        na.rm = TRUE
      ),

    sd_nao_tratado =
      sd(
        x$nao_tratado,
        na.rm = TRUE
      ),

    erro_padrao_tratado =
      sd(
        x$tratado,
        na.rm = TRUE
      ) /
      sqrt(nrow(x)),

    erro_padrao_nao_tratado =
      sd(
        x$nao_tratado,
        na.rm = TRUE
      ) /
      sqrt(nrow(x))
  )
}

resumo <-
  do.call(
    rbind,
    resumos
  )

rownames(resumo) <- NULL

cat(
  "\n============= ANALISE EXPLORATORIA =============\n\n"
)

print(resumo)

# Exportar CSV
write.csv(
  resumo,
  "resultados/tabelas/resumo_exploratorio.csv",
  row.names = FALSE
)

# Exportar Excel
write_xlsx(
  list(
    resumo_exploratorio = resumo
  ),
  "resultados/tabelas/resumo_exploratorio.xlsx"
)

# Grafico
png(
  "resultados/graficos/proporcoes_por_tempo.png",
  width = 1200,
  height = 700,
  res = 120
)

matplot(
  x = resumo$tempo_h,

  y = cbind(
    resumo$percentual_tratado,
    resumo$percentual_nao_tratado
  ),

  type = "b",

  pch = c(
    16,
    17
  ),

  lty = c(
    1,
    2
  ),

  xlab =
    "Tempo (h)",

  ylab =
    "Percentual das frequencias agregadas (%)",

  main =
    "Distribuicao tratado x nao tratado ao longo do tempo",

  ylim =
    c(
      0,
      100
    )
)

# Linha de referencia 50:50
abline(
  h = 50,
  lty = 3
)

legend(
  "right",

  legend = c(
    "Tratado",
    "Nao tratado"
  ),

  pch = c(
    16,
    17
  ),

  lty = c(
    1,
    2
  )
)

dev.off()

cat(
  "\nResumo e grafico salvos em resultados/.\n"
)