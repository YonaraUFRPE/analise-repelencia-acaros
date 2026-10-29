# ============================================================
# 03_testes_estatisticos.R
# Teste binomial exato - analise exploratoria
# ============================================================

# OBJETIVO
#
# Para cada tempo, testar se a frequencia agregada entre
# tratado e nao tratado difere de 50:50.
#
# H0: p_tratado = 0.50
# H1: p_tratado != 0.50
#
# IMPORTANTE:
#
# Esta analise NAO resolve a dependencia decorrente das
# medidas repetidas.
#
# Os mesmos acaros foram observados ao longo do tempo.
# Portanto, este teste deve ser interpretado como uma
# verificacao exploratoria das frequencias agregadas.

library(writexl)

if (!exists("dados")) {
  source("scripts/01_importacao.R")
}

# Nivel de significancia
alpha <- 0.05

# Tempos
tempos <-
  sort(
    unique(
      dados$tempo_h
    )
  )

resultados <-
  vector(
    "list",
    length(tempos)
  )

for (i in seq_along(tempos)) {

  tempo <-
    tempos[i]

  x <-
    dados[
      dados$tempo_h == tempo,
    ]

  tratado <-
    sum(
      x$tratado,
      na.rm = TRUE
    )

  nao_tratado <-
    sum(
      x$nao_tratado,
      na.rm = TRUE
    )

  total <-
    tratado +
    nao_tratado

  if (total <= 0) {
    next
  }

  # Teste binomial exato
  teste <-
    binom.test(

      x =
        tratado,

      n =
        total,

      p =
        0.5,

      alternative =
        "two.sided",

      conf.level =
        0.95
    )

  resultados[[i]] <-
    data.frame(

      tempo_h =
        tempo,

      n_repeticoes =
        nrow(x),

      tratado =
        tratado,

      nao_tratado =
        nao_tratado,

      total =
        total,

      percentual_tratado =
        100 *
        tratado /
        total,

      percentual_nao_tratado =
        100 *
        nao_tratado /
        total,

      p_value =
        teste$p.value,

      ic95_inferior_tratado =
        teste$conf.int[1],

      ic95_superior_tratado =
        teste$conf.int[2]
    )
}

resultado_binomial <-
  do.call(
    rbind,
    resultados
  )

rownames(
  resultado_binomial
) <- NULL

# ------------------------------------------------------------
# Correcao para multiplos testes
# ------------------------------------------------------------

resultado_binomial$p_ajustado_holm <-
  p.adjust(

    resultado_binomial$p_value,

    method =
      "holm"
  )

# ------------------------------------------------------------
# Conclusao usando p bruto
# ------------------------------------------------------------

resultado_binomial$conclusao_p_bruto <-
  ifelse(

    resultado_binomial$p_value <
      alpha,

    "Rejeita H0",

    "Nao rejeita H0"
  )

# ------------------------------------------------------------
# Conclusao usando p corrigido
# ------------------------------------------------------------

resultado_binomial$conclusao_holm <-
  ifelse(

    resultado_binomial$p_ajustado_holm <
      alpha,

    "Rejeita H0",

    "Nao rejeita H0"
  )

# ------------------------------------------------------------
# Lado com maior frequencia
# ------------------------------------------------------------

resultado_binomial$maior_frequencia <-
  ifelse(

    resultado_binomial$tratado >
      resultado_binomial$nao_tratado,

    "Tratado",

    ifelse(

      resultado_binomial$tratado <
        resultado_binomial$nao_tratado,

      "Nao tratado",

      "Igual"
    )
  )

# ------------------------------------------------------------
# Mostrar resultados
# ------------------------------------------------------------

cat("\n====================================================\n")

cat(
  " TESTE BINOMIAL EXATO - FREQUENCIAS AGREGADAS\n"
)

cat(
  "====================================================\n\n"
)

print(
  resultado_binomial
)

cat(
  "\nNivel de significancia: alpha =",
  alpha,
  "\n"
)

cat(
  "\nATENCAO METODOLOGICA:\n"
)

cat(
  "Os mesmos acaros sao acompanhados ao longo do tempo.\n"
)

cat(
  "Logo, esta analise nao deve ser tratada como modelo final\n"
)

cat(
  "de medidas repetidas; ela e uma verificacao exploratoria\n"
)

cat(
  "das frequencias agregadas em relacao a 50:50.\n"
)

# ------------------------------------------------------------
# Exportar
# ------------------------------------------------------------

write.csv(

  resultado_binomial,

  "resultados/tabelas/teste_binomial_exato.csv",

  row.names = FALSE
)

write_xlsx(

  list(
    teste_binomial =
      resultado_binomial
  ),

  "resultados/tabelas/teste_binomial_exato.xlsx"
)

cat(
  "\nResultados salvos em resultados/tabelas/.\n"
)