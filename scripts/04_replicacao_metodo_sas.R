# ============================================================
# 04_replicacao_metodo_sas.R
#
# Reproducao do:
#
# SAS PROC FREQ
# Chi-Square Test for Equal Proportions
#
# ============================================================

# OBJETIVO
#
# Reproduzir em R a logica observada na tela do SAS:
#
# comparar duas frequencias contra a proporcao esperada
# de 50% para cada lado.
#
# H0:
# proporcoes iguais
#
# p_tratado = 0.50
# p_nao_tratado = 0.50
#
# H1:
# as proporcoes nao sao iguais.
#
# Em R:
#
# chisq.test(
#   c(tratado, nao_tratado),
#   p = c(0.5, 0.5)
# )

library(writexl)

if (!exists("dados")) {
  source("scripts/01_importacao.R")
}

alpha <- 0.05

# ============================================================
# 1. VALIDACAO COM O EXEMPLO MOSTRADO NO SAS
# ============================================================

exemplo_sas <-
  chisq.test(

    x =
      c(
        33,
        50
      ),

    p =
      c(
        0.5,
        0.5
      )
  )

cat(
  "\n================ VALIDACAO SAS =================\n"
)

cat(
  "Exemplo da imagem: 33 vs 50\n"
)

cat(
  "Qui-quadrado esperado ~ 3.4819\n"
)

cat(
  "p esperado ~ 0.0620\n\n"
)

print(
  exemplo_sas
)

# ============================================================
# 2. APLICAR O MESMO METODO A CADA TEMPO
# ============================================================

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

  frequencias <-
    c(

      tratado =
        tratado,

      nao_tratado =
        nao_tratado
    )

  # ----------------------------------------------------------
  # Mesmo teste apresentado pelo SAS
  # ----------------------------------------------------------

  teste <-
    chisq.test(

      x =
        frequencias,

      p =
        c(
          0.5,
          0.5
        )
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

      qui_quadrado =
        unname(
          teste$statistic
        ),

      graus_liberdade =
        unname(
          teste$parameter
        ),

      p_value =
        teste$p.value
    )
}

resultado_sas <-
  do.call(
    rbind,
    resultados
  )

rownames(
  resultado_sas
) <- NULL

# ============================================================
# 3. CORRECAO PARA MULTIPLOS TEMPOS
# ============================================================

resultado_sas$p_ajustado_holm <-
  p.adjust(

    resultado_sas$p_value,

    method =
      "holm"
  )

# ============================================================
# 4. CONCLUSAO COM P BRUTO
# ============================================================

resultado_sas$conclusao_p_bruto <-
  ifelse(

    resultado_sas$p_value <
      alpha,

    "Rejeita H0",

    "Nao rejeita H0"
  )

# ============================================================
# 5. CONCLUSAO COM HOLM
# ============================================================

resultado_sas$conclusao_holm <-
  ifelse(

    resultado_sas$p_ajustado_holm <
      alpha,

    "Rejeita H0",

    "Nao rejeita H0"
  )

# ============================================================
# 6. IDENTIFICAR O LADO COM MAIOR FREQUENCIA
# ============================================================

resultado_sas$maior_frequencia <-
  ifelse(

    resultado_sas$tratado >
      resultado_sas$nao_tratado,

    "Tratado",

    ifelse(

      resultado_sas$tratado <
        resultado_sas$nao_tratado,

      "Nao tratado",

      "Igual"
    )
  )

# ============================================================
# 7. MOSTRAR RESULTADOS
# ============================================================

cat(
  "\n====================================================\n"
)

cat(
  " QUI-QUADRADO PARA PROPORCOES IGUAIS - METODO SAS\n"
)

cat(
  "====================================================\n\n"
)

print(
  resultado_sas
)

cat(
  "\nINTERPRETACAO:\n"
)

cat(
  "p_value reproduz a logica do SAS para cada tempo isolado.\n"
)

cat(
  "p_ajustado_holm corrige a realizacao de varios testes.\n"
)

cat(
  "\nATENCAO:\n"
)

cat(
  "Este script reproduz o metodo historico de frequencias agregadas.\n"
)

cat(
  "Ele nao modela a dependencia dos mesmos acaros observados\n"
)

cat(
  "repetidamente ao longo do tempo.\n"
)

# ============================================================
# 8. EXPORTAR CSV
# ============================================================

write.csv(

  resultado_sas,

  "resultados/tabelas/replicacao_metodo_sas.csv",

  row.names = FALSE
)

# ============================================================
# 9. EXPORTAR EXCEL
# ============================================================

write_xlsx(

  list(

    validacao_exemplo_sas =
      data.frame(

        testA = 33,

        testB = 50,

        qui_quadrado =
          unname(
            exemplo_sas$statistic
          ),

        graus_liberdade =
          unname(
            exemplo_sas$parameter
          ),

        p_value =
          exemplo_sas$p.value
      ),

    resultados_por_tempo =
      resultado_sas
  ),

  "resultados/tabelas/replicacao_metodo_sas.xlsx"
)

cat(
  "\nResultados salvos em resultados/tabelas/.\n"
)