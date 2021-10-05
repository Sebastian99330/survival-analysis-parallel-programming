
podziel_zbior <- function (input_sciezka, liczba_watkow){
  # library(future)
  # install.packages("future_promise")
  # plan(multisession)
  
  df <- read.table(input_sciezka, sep = "," , header = T)
  # head(df,2)
  # print("dopiero")
  # df <- promises::future_promise(read.table(input_sciezka, sep = "," , header = T))
  # print(5)
  licza_wierszy <- nrow(df)
  numery_zbiorow <- sample(1:liczba_watkow, size = licza_wierszy,
                           replace = TRUE)
  
  # tworzy pusta liste - konstruktor utworzenia pustej listy
  lista_df <- list()
  
  # library(doParallel)
  # library(foreach)
  # register a parallel backend (clusters)
  # cl <- parallel::makeCluster(liczba_watkow)
  ### cl<-makeCluster(liczba_watkow,type="SOCK") # lub PSOCK
  # doParallel::registerDoParallel(cl)
  
  
  for(numer in 1:liczba_watkow){
    # lista_df <- foreach(numer=1:liczba_watkow) %dopar% {
    wybrane_idx <- which(numery_zbiorow == numer)
    lista_df[[numer]] <- df[wybrane_idx, ]
    # saveRDS(df, paste0("output//split-data\\zbior_", numer,".rds"))
  }
  # parallel::stopCluster(cl)
  # cl <- parallel::makeCluster(4)
  # future::plan(cluster, workers=cl)
  # 
  # promises::future_promise(lapply(seq_along(lista_df),zapisz_do_pliku,lista=lista_df))
  library(promises)
  # lapply(seq_along(lista_df),zapisz_do_pliku,lista=lista_df)
  lapply(seq_along(lista_df),zapisz_do_pliku_async,lista=lista_df)
  # 
  # parallel::stopCluster(cl)
  # library(future.apply)
  # future.apply::future_lapply(seq_along(lista_df),zapisz_do_pliku,lista=lista_df)

  # library(parallel)
  # cl <- parallel::makeCluster(liczba_watkow)
  # parallel::parLapply(cl, seq_along(lista_df),zapisz_do_pliku,lista=lista_df)
  # 
  # parallel::stopCluster(cl)
  return (lista_df)
}


zapisz_do_pliku <- function(numer, lista){
  # write.csv(df[wybrane_idx, ], paste0("output//split-data\\zbior_", numer,".csv"), row.names = F)
  saveRDS(lista[[numer]], paste0("output//split-data\\zbior_", numer,".rds"))
}


zapisz_do_pliku_async <- function(numer, lista) {
  promises::future_promise({
    zapisz_do_pliku(numer, lista)
  })
}