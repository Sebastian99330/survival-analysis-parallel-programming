
podziel_zbior <- function (input_sciezka, liczba_watkow){
  df <- read.table(input_sciezka, sep = "," , header = T)
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
    # zapisuje do pliku, ale nie zostaje zmienna po petli
    # zamiast tego wypisuje na ekran to co obliczy
    # write.csv(df[wybrane_idx, ], paste0("output//split-data\\zbior_", numer,".csv"), row.names = F)
    # saveRDS(df[wybrane_idx, ], paste0("output//split-data\\zbior_", numer,".rds"))
  }
  # parallel::stopCluster(cl)
  return (lista_df)
}

