args <- commandArgs(trailingOnly = TRUE)
# args <- array(c("input//turnover.csv", "3", "output//split-data\\zbior_"))

# ten skrypt przyjmuje argumenty:
# 1 sciezka do pliku z danymi wejsciowymi
# 2 ilosc watkow (na ile czesci podzielic zbior danych wejsciowych)
# 3 czesc nazwy pliku wyjsciowego (np zbior_ , ktore dalej bedzie uzupelniony w petli zeby bylo np. zbior_3.csv)
# Jak przy wywolaniu skryptu nie podano pierwszego argumentu to rzucamy blad
if (length(args)==0) {
  stop("Sciezka do pliku wejsciowego jest wymagana.", call.=FALSE)
}

input_sciezka <- args[1]
liczba_zbiorow <- as.numeric(args[2]) # wczesniej byl string i rzucalo blad przy tworzeniu klastra do obliczen rownoleglych
plik_output <- args[3]



# wczytanie danych
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


# library(doParallel)
# library(foreach)

#register a parallel backend (clusters)
# cl <- parallel::makeCluster(liczba_zbiorow)
# doParallel::registerDoParallel(cl)

for(numer in 1:liczba_zbiorow){
# foreach(numer=1:liczba_zbiorow) %dopar% {
  wybrane_idx <- which(numery_zbiorow == numer)
  
  lista_zbiorow[[numer]] <- df[wybrane_idx, ]
  
  # write.csv(df[wybrane_idx, ], paste0(plik_output, numer,".csv"), row.names = F)
  saveRDS(df[wybrane_idx, ], paste0(plik_output, numer,".rds"))
}

# parallel::stopCluster(cl)
