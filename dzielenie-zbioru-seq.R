args <- commandArgs(trailingOnly = TRUE)
# wiersz ponizej - dac w cudzyslowia
# args <- array(c(prost_cancer_mln.csv 3 Split-data\\zbior_))

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
unlink("Split-data", recursive = TRUE)

# utworzenie katalogu na nowe pliki z danymi wejsciowymi
dir.create(file.path("Split-data"), showWarnings = FALSE)

# zapisze dane statystyczne / logi do pliku tekstowego
# sink("Split-data\\splitting-data-logs.txt") # zakomentowane na czas testow

# print("Proporcje z jakimi rozdzielono obserwacje miedzy watkami: ") # zakomentowane na czas testow
# zwraca proporcje - najlepiej po 25% (jesli dzielimy na 4), wtedy jest dobrze
# trzeba zbadac czy dobrze dzieli, bo musi byc rowne obciazenie watkow
# prop.table(table(numery_zbiorow)) # zakomentowane na czas testow
# 
# start.time <- Sys.time() # zakomentowane na czas testow



# tworzy pusta liste - konstruktor utworzenia pustej listy
lista_zbiorow <- list()


#library(doParallel)
#library(foreach)

#register a parallel backend (clusters)
#cl <- parallel::makeCluster(4)
#doParallel::registerDoParallel(cl)

for(numer in 1:liczba_zbiorow){
#foreach(numer=1:liczba_zbiorow) %dopar% {
  # wybrane_idx <- which(numery_zbiorow == 1)
  wybrane_idx <- which(numery_zbiorow == numer)
  
  lista_zbiorow[[numer]] <- df[wybrane_idx, ]
  
  write.csv(df[wybrane_idx, ], paste0(plik_output, numer,".csv"), row.names = F)
}

#parallel::stopCluster(cl)

# zakomentowane na czas testow ponizsze
# end.time <- Sys.time()
# time.taken <- as.numeric(end.time - start.time)
# time.taken <- format(round(time.taken, 2), nsmall = 2) # formatowanie do dwoch miejsc po przecinku
# cat("\n\n") # zakomentowane na czas testow
# print(paste0("Dzielenie zbioru danych wejsciowych zajelo: ",time.taken, " sekund(y)")) # zakomentowane na czas testow
# print(paste0("Start wykonania skryptu: ",start.time)) # zakomentowane na czas testow
# print(paste0("Koniec wykonania skryptu: ",end.time)) # zakomentowane na czas testow

#zamkniecie pliku
# sink() # zakomentowane na czas testow