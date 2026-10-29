# ============================================================
# 03_testes_estatisticos.R
# Análise exploratória de preferência: tratado x não tratado
# ============================================================

# Objetivo:
# Testar, em cada tempo, se a distribuição dos ácaros entre
# tratado e não tratado difere de uma proporção 50:50.
#
# H0: p_tratado = 0.50
# H1: p_tratado != 0.50
#
# IMPORTANTE:
# Esta análise usa as contagens agregadas de ácaros.
# Ela considera os indivíduos como observações independentes.
# Portanto, deve ser interpretada como EXPLORATÓRIA caso os
# ácaros estejam agrupados nas mesmas arenas/repetições ou
# sejam acompanhados repetidamente ao longo do tempo.


# ------------------------------------------------------------
# 1. Carregar dados
# ------------------------------------------------------------

if (!exists("dados")) {
  source("scripts/01_importacao.R")
}


# ------------------------------------------------------------
# 2. Verificar se as colunas necessárias existem
# ------------------------------------------------------------

colunas_necessarias <- c(
  "tempo_h",
  "repeticao",
  "tratado",
  "nao_tratado"
)

if (!all(colunas_necessarias %in% names(dados))) {
  stop(
    "Erro: a planilha não contém todas as colunas necessárias."
  )
}


# ------------------------------------------------------------
# 3. Definir nível de significância
# ------------------------------------------------------------

alpha <- 0.05


# ------------------------------------------------------------
# 4. Criar objeto para armazenar os resultados
# ------------------------------------------------------------

resultados <- list()


# ------------------------------------------------------------
# 5. Executar teste binomial exato para cada tempo
# ------------------------------------------------------------

for (tempo in sort(unique(dados$tempo_h))) {

  # Selecionar apenas os dados daquele tempo
  dados_tempo <- dados[dados$tempo_h == tempo, ]

  # Somar as repetições
  tratado <- sum(
    dados_tempo$tratado,
    na.rm = TRUE
  )

  nao_tratado <- sum(
    dados_tempo$nao_tratado,
    na.rm = TRUE
  )

  total <- tratado + nao_tratado

  # Verificação de segurança
  if (total == 0) {
    next
  }

  # ----------------------------------------------------------
  # Teste binomial exato
  #
  # H0: 50% dos indivíduos no tratado
  # H1: proporção diferente de 50%
  # ----------------------------------------------------------

  teste <- binom.test(
    x = tratado,
    n = total,
    p = 0.5,
    alternative = "two.sided",
    conf.level = 0.95
  )

  # Guardar resultados
  resultados[[as.character(tempo)]] <- data.frame(

    tempo_h = tempo,

    n_repeticoes = nrow(dados_tempo),

    tratado = tratado,

    nao_tratado = nao_tratado,

    total = total,

    prop_tratado =
      tratado / total,

    prop_nao_tratado =
      nao_tratado / total,

    p_value =
      teste$p.value,

    ic95_inferior_tratado =
      teste$conf.int[1],

    ic95_superior_tratado =
      teste$conf.int[2]
  )
}


# ------------------------------------------------------------
# 6. Juntar todos os tempos em uma única tabela
# ------------------------------------------------------------

resultado_testes <- do.call(
  rbind,
  resultados
)

rownames(resultado_testes) <- NULL


# ------------------------------------------------------------
# 7. Corrigir os p-values para múltiplas comparações
#
# Como foram feitos testes em vários tempos, aplicamos
# a correção de Holm.
# ------------------------------------------------------------

resultado_testes$p_ajustado_holm <-
  p.adjust(
    resultado_testes$p_value,
    method = "holm"
  )


# ------------------------------------------------------------
# 8. Conclusão usando o p-value bruto
# ------------------------------------------------------------

resultado_testes$conclusao_p_bruto <-
  ifelse(
    resultado_testes$p_value < alpha,
    "Rejeita H0",
    "Nao rejeita H0"
  )


# ------------------------------------------------------------
# 9. Conclusão usando o p-value ajustado por Holm
# ------------------------------------------------------------

resultado_testes$conclusao_holm <-
  ifelse(
    resultado_testes$p_ajustado_holm < alpha,
    "Rejeita H0",
    "Nao rejeita H0"
  )


# ------------------------------------------------------------
# 10. Identificar qual lado apresentou maior proporção
# ------------------------------------------------------------

resultado_testes$maior_ocorrencia <-
  ifelse(
    resultado_testes$prop_tratado >
      resultado_testes$prop_nao_tratado,

    "Tratado",

    ifelse(
      resultado_testes$prop_tratado <
        resultado_testes$prop_nao_tratado,

      "Nao tratado",

      "Igual"
    )
  )


# ------------------------------------------------------------
# 11. Criar porcentagens para facilitar interpretação
# ------------------------------------------------------------

resultado_testes$percentual_tratado <-
  resultado_testes$prop_tratado * 100

resultado_testes$percentual_nao_tratado <-
  resultado_testes$prop_nao_tratado * 100


# ------------------------------------------------------------
# 12. Organizar ordem das colunas
# ------------------------------------------------------------

resultado_testes <- resultado_testes[
  ,
  c(
    "tempo_h",
    "n_repeticoes",

    "tratado",
    "nao_tratado",
    "total",

    "percentual_tratado",
    "percentual_nao_tratado",

    "p_value",
    "p_ajustado_holm",

    "ic95_inferior_tratado",
    "ic95_superior_tratado",

    "maior_ocorrencia",

    "conclusao_p_bruto",
    "conclusao_holm"
  )
]


# ------------------------------------------------------------
# 13. Mostrar resultados no console
# ------------------------------------------------------------

cat("\n")
cat("====================================================\n")
cat(" TESTE BINOMIAL EXATO - TRATADO x NAO TRATADO\n")
cat("====================================================\n\n")

print(resultado_testes)

cat("\n")
cat("Nivel de significancia utilizado: alpha =", alpha, "\n")

cat("\n")
cat("ATENCAO:\n")
cat(
  "Os testes binomiais acima consideram cada individuo como\n"
)

cat(
  "uma observacao independente. Caso os mesmos acaros ou\n"
)

cat(
  "arenas sejam acompanhados ao longo do tempo, esta analise\n"
)

cat(
  "deve ser considerada exploratoria, pois existe dependencia\n"
)

cat(
  "entre as observacoes.\n"
)


# ------------------------------------------------------------
# 14. Salvar resultados
# ------------------------------------------------------------

write.csv(
  resultado_testes,
  "resultados/tabelas/teste_binomial_exploratorio.csv",
  row.names = FALSE
)


# ------------------------------------------------------------
# 15. Mensagem final
# ------------------------------------------------------------

cat("\n")
cat(
  "Arquivo salvo em:\n"
)

cat(
  "resultados/tabelas/teste_binomial_exploratorio.csv\n"
)

cat("\n")