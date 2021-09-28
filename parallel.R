args <- commandArgs(trailingOnly = TRUE)
# args <- array(c("input//turnover.csv", "3", "exp, event", "branch + pipeline"))

input_sciezka <- args[1]
liczba_watkow <- as.numeric(args[2]) # wczesniej byl string i rzucalo blad przy tworzeniu klastra do obliczen rownoleglych
time_status <- paste0("\"",args[3],"\"")
zmienne_grupowanie_cox <- paste0("\"",args[4],"\"")

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

instrukcja <- sprintf("lapply(lista_df, oblicz_cox, %s, %s)", time_status, zmienne_grupowanie_cox)
print(instrukcja)
lista_ramek_modeli <- eval(parse(text=instrukcja)) # uruchomienie instrukcji zapisanej w zmiennej "instrukcja"

source("laczenie-par.R")

polacz_ramki(lista_ramek_modeli)
