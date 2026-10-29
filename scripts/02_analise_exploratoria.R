# 02_analise_exploratoria.R
# Objetivo: descrever os dados antes dos testes estatísticos

# Se os dados ainda não estiverem carregados,
# executa automaticamente a importação
if (!exists("dados")) {
  source("scripts/01_importacao.R")
}

# Criar resumo para cada tempo
resumo <- do.call(
  rbind,
  lapply(split(dados, dados$tempo_h), function(x) {

    total_tratado <- sum(x$tratado)
    total_nao_tratado <- sum(x$nao_tratado)
    total <- total_tratado + total_nao_tratado

    data.frame(
      tempo_h = unique(x$tempo_h),
      n_repeticoes = nrow(x),

      tratado_total = total_tratado,
      nao_tratado_total = total_nao_tratado,
      total_observado = total,

      prop_tratado = total_tratado / total,
      prop_nao_tratado = total_nao_tratado / total,

      media_tratado = mean(x$tratado),
      media_nao_tratado = mean(x$nao_tratado),

      sd_tratado = sd(x$tratado),
      sd_nao_tratado = sd(x$nao_tratado),

      erro_padrao_tratado =
        sd(x$tratado) / sqrt(nrow(x)),

      erro_padrao_nao_tratado =
        sd(x$nao_tratado) / sqrt(nrow(x))
    )
  })
)

rownames(resumo) <- NULL

# Mostrar resultado
print(resumo)

# Salvar tabela
write.csv(
  resumo,
  "resultados/tabelas/resumo_exploratorio.csv",
  row.names = FALSE
)