library(survivalROC)
library(tidyr)

## Define a helper functio nto evaluate at various t
survivalROC_helper <- function(t) {
  print(paste0(Sys.time(), " survivalROC for t=",t))
  survivalROC(Stime        = q$exp,
              status       = q$event,
              marker       = q$lp,
              predict.time = t,
              method       = "NNE",
              span = 0.25 * nrow(q)^(-0.20))
}



## Evaluate every 1 month
plot_ROC_curve <-function(max_t)
{

  survivalROC_data <- data_frame(t = seq(1,max_t,1)) %>%
    mutate(survivalROC = map(t, survivalROC_helper),
           ## Extract scalar AUC
           auc = map_dbl(survivalROC, magrittr::extract2, "AUC"),
           ## Put cut off dependent values in a data_frame
           df_survivalROC = map(survivalROC, function(obj) {
             as_data_frame(obj[c("cut.values","TP","FP")])
           })) %>%
    dplyr::select(-survivalROC) %>%
    unnest() %>%
    arrange(t, FP, TP)

  ## Plot
  survivalROC_data %>%
    ggplot(mapping = aes(x = FP, y = TP)) +
    geom_point() +
    geom_line() +
    geom_label(data = survivalROC_data %>% dplyr::select(t,auc) %>% unique,
               mapping = aes(label = sprintf("%.3f", auc)), x = 0.5, y = 0.5) +
    facet_wrap( ~ t) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          legend.key = element_blank(),
          plot.title = element_text(hjust = 0.5),
          strip.background = element_blank())

}

#--------- risk set ----------------

library(risksetROC)
## Define a helper functio nto evaluate at various t
risksetROC_helper <- function(t) {
  risksetROC(Stime        = q$exp,
             status       = q$event,
             marker       = q$lp,
             predict.time = t,
             method       = "Cox",
             plot         = FALSE)
}
## Evaluate every 1 month
plot_risk_set <-function(max_t)
{
  risksetROC_data <- data_frame(t = seq(1,max_t,1)) %>%
    mutate(risksetROC = map(t, risksetROC_helper),
           ## Extract scalar AUC
           auc = map_dbl(risksetROC, magrittr::extract2, "AUC"),
           ## Put cut off dependent values in a data_frame
           df_risksetROC = map(risksetROC, function(obj) {
             ## marker column is too short!
             marker <- c(-Inf, obj[["marker"]], Inf)
             bind_cols(data_frame(marker = marker),
                       as_data_frame(obj[c("TP","FP")]))
           })) %>%
    dplyr::select(-risksetROC) %>%
    unnest() %>%
    arrange(t, FP, TP)
  ## Plot
  risksetROC_data %>%
    ggplot(mapping = aes(x = FP, y = TP)) +
    geom_point() +
    geom_line() +
    geom_label(data = risksetROC_data %>% dplyr::select(t,auc) %>% unique,
               mapping = aes(label = sprintf("%.3f", auc)), x = 0.5, y = 0.5) +
    facet_wrap( ~ t) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          legend.key = element_blank(),
          plot.title = element_text(hjust = 0.5),
          strip.background = element_blank())

}



