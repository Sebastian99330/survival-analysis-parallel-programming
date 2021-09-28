
podziel_zbior <- function (input_sciezka, liczba_zbiorow){
  
  df <- read.table(input_sciezka, sep = "," , header = T)
  licza_wierszy <- nrow(df)
  numery_zbiorow <- sample(1:liczba_zbiorow, size = licza_wierszy,
                           replace = TRUE)

  # tworzy pusta liste - konstruktor utworzenia pustej listy
  lista_df <- list()
  
  for(numer in 1:liczba_zbiorow){
    wybrane_idx <- which(numery_zbiorow == numer)
    lista_df[[numer]] <- df[wybrane_idx, ]
  }
  return (lista_df)
}
