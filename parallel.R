args <- commandArgs(trailingOnly = TRUE)
# args <- array(c("input//turnover.csv", "3", "output\\split-data\\zbior_"))

input_sciezka <- args[1]
liczba_watkow <- as.numeric(args[2]) # wczesniej byl string i rzucalo blad przy tworzeniu klastra do obliczen rownoleglych
dzielenie_zbioru_plik <- args[3] #np. zbior_ , co bedzie oznaczalo ze podzielone zbiory beda mialy nazwy zbior_1, zbior_2 itd

# library(snow)
# z=vector('list',4)
# z=1:4
# system.time(lapply(z,function(x) Sys.sleep(1)))
# cl<-makeCluster(liczba_watkow,type="SOCK")
# system.time(clusterApply(cl, z,function(x) Sys.sleep(1)))
# stopCluster(cl)
## UWAGA - TRZEBA ZROBIC TUTAJ UTWORZENIE KLASTRA, POTEM DOPAR WSZYSTKO, A POTEM NA SAMYM KONCU DOPIERO ZAMKANC KLASTER


source("dzielenie-zbioru-par.R")

lista_df <- podziel_zbior(input_sciezka, liczba_watkow)

source("script-par.R")

lista_ramek_modeli <- lapply(lista_df, oblicz_cox, "exp, event", "branch + pipeline")

