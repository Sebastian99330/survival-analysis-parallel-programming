
podziel_zbior <- function (input_sciezka, liczba_watkow){
  df <- read.table(input_sciezka, sep = "," , header = T)
  licza_wierszy <- nrow(df)
  numery_zbiorow <- sample(1:liczba_watkow, size = licza_wierszy,
                           replace = TRUE)

  # tworzy pusta liste - konstruktor utworzenia pustej listy
  lista_df <- list()
  
  
  # for(numer in 1:liczba_watkow){
  lista_df <- foreach(numer=1:liczba_watkow) %dopar% {
    wybrane_idx <- which(numery_zbiorow == numer)
    lista_df[[numer]] <- df[wybrane_idx, ]
    # zapisuje do pliku, ale nie zostaje zmienna po petli
    # zamiast tego wypisuje na ekran to co obliczy
    #write.csv(df[wybrane_idx, ], paste0("output//split-data\\zbior_", numer,".csv"), row.names = F)
  }
  # lista_df # po normalnej petli for to ma wartosc, po foreach nie ma
  
  return (lista_df)
}

