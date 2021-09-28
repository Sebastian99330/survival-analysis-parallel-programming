
podziel_zbior <- function (input_sciezka, liczba_zbiorow, plik_output){
  df <- read.table(input_sciezka, sep = "," , header = T)
  licza_wierszy <- nrow(df)
  numery_zbiorow <- sample(1:liczba_zbiorow, size = licza_wierszy,
                           replace = TRUE)

  # Usuniecie katalogu jesli istnieje
  unlink("output//split-data", recursive = TRUE)
  # utworzenie katalogu na nowe pliki z danymi wejsciowymi
  dir.create(file.path("output//split-data"), showWarnings = FALSE)
  
  # tworzy pusta liste - konstruktor utworzenia pustej listy
  lista_zbiorow <- list()

  for(numer in 1:liczba_zbiorow){
    # foreach(numer=1:liczba_zbiorow) %dopar% {
    wybrane_idx <- which(numery_zbiorow == numer)
    lista_zbiorow[[numer]] <- df[wybrane_idx, ]
    # write.csv(df[wybrane_idx, ], paste0(plik_output, numer,".csv"), row.names = F)
    saveRDS(df[wybrane_idx, ], paste0(plik_output, numer,".rds"))
  }
}


