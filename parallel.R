args <- commandArgs(trailingOnly = TRUE)
# args <- array(c("input//turnover.csv", "3", "exp, event", "branch + pipeline"))
# args <- array(c("input//turnover-mln-7.csv", "10", "exp, event", "branch + pipeline"))
# args <- array(c("input//turnover-mln-0-8.csv", "10", "exp, event", "branch + pipeline"))
# args <- array(c("input//prostate_cancer.csv", "3", "time, status", "treatment + age + sh + size + index"))

input_sciezka <- args[1]
liczba_watkow <- as.numeric(args[2]) # wczesniej byl string i rzucalo blad przy tworzeniu klastra do obliczen rownoleglych
time_status <- paste0("\"",args[3],"\"")
# time_status <- args[3]
zmienne_grupowanie_cox <- paste0("\"",args[4],"\"")
# zmienne_grupowanie_cox <- args[4]

# cat(paste("time_status: ",time_status))
# cat(paste0("zmienne_grupowanie_cox: ",zmienne_grupowanie_cox))


# library(snow)
# z=vector('list',4)
# z=1:4
# system.time(lapply(z,function(x) Sys.sleep(1)))
# cl<-makeCluster(liczba_watkow,type="SOCK")
# system.time(clusterApply(cl, z,function(x) Sys.sleep(1)))
# stopCluster(cl)

# library(doParallel)
# library(foreach)
# library(snow)

# register a parallel backend (clusters)
# cl <- parallel::makeCluster(liczba_watkow,type="SOCK")
### cl<-makeCluster(liczba_watkow,type="SOCK") # lub PSOCK
# doParallel::registerDoParallel(cl)

source("dzielenie-zbioru-par.R")
start.time <- Sys.time()
lista_df <- podziel_zbior(input_sciezka, liczba_watkow)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
# head(lista_df[[1]])


source("script-par.R")

instrukcja <- sprintf("lapply(lista_df, oblicz_cox, %s, %s)", time_status, zmienne_grupowanie_cox)
lista_ramek_modeli <- eval(parse(text=instrukcja)) # uruchomienie instrukcji zapisanej w zmiennej "instrukcja"

source("laczenie-par.R")

polacz_ramki(lista_ramek_modeli, liczba_watkow)


parallel::stopCluster(cl)