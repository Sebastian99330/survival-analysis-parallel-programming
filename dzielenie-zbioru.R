args <- commandArgs(trailingOnly = TRUE)

# ten skrypt przyjmuje argumenty:
# 1 sciezka do pliku z danymi wejsciowymi
# 2 ilosc watkow (na ile czesci podzielic zbior danych wejsciowych)
# 3 czesc nazwy pliku wyjsciowego (np zbior_ , ktore dalej bedzie uzupelniony w petli zeby bylo np. zbior_3.csv)
# Jak przy wywolaniu skryptu nie podano pierwszego argumentu to rzucamy blad
if (length(args)==0) {
  stop("Sciezka do pliku wejsciowego jest wymagana.", call.=FALSE)
}

input_sciezka <- args[1]
ilosc_zbiorow <- as.numeric(args[2]) # wczesniej byl string i rzucalo blad przy tworzeniu klastra do obliczen rownoleglych
plik_output <- args[3]



# wczytanie danych
#df <- read.table(input_sciezka, sep = "" , header = T)
df <- read.table("prostate_cancer.txt", sep = "" , header = T)

licza_wierszy <- nrow(df)

numery_zbiorow <- sample(1:ilosc_zbiorow, size = licza_wierszy,
                         replace = TRUE)


# Usuniecie katalogu jesli istnieje
unlink("Split-data", recursive = TRUE)

# utworzenie katalogu na nowe pliki z danymi wejsciowymi
dir.create(file.path("Split-data"), showWarnings = FALSE)

# zapisze dane statystyczne / logi do pliku tekstowego
sink("Split-data\\splitting-data-logs.txt")

print("Proporcje z jakimi rozdzielono obserwacje miedzy watkami: ")
# zwraca proporcje - najlepiej po 25% (jesli dzielimy na 4), wtedy jest dobrze
# trzeba zbadac czy dobrze dzieli, bo musi byc rowne obciazenie watkow
prop.table(table(numery_zbiorow))




# tworzy pusta liste - konstruktor utworzenia pustej listy
lista_zbiorow <- list()


library(doParallel)
library(foreach)

#register a parallel backend (clusters)
cl <- parallel::makeCluster(ilosc_zbiorow)
doParallel::registerDoParallel(cl)

start.time <- Sys.time()

#for(numer in 1:ilosc_zbiorow){
foreach(numer=1:ilosc_zbiorow) %dopar% {
  wybrane_idx <- which(numery_zbiorow == 1)
  
  #lista_zbiorow[[numer]] <- df[wybrane_idx, ]
  
  write.csv(df[wybrane_idx, ], paste0(plik_output, numer,".csv"), row.names = F) # to dziala
}
end.time <- Sys.time()

parallel::stopCluster(cl)


time.taken <- as.numeric(end.time - start.time)
time.taken <- format(round(time.taken, 2), nsmall = 2) # formatowanie do dwoch miejsc po przecinku
cat("\n\n")
print(paste0("Dzielenie zbioru danych wejsciowych zajelo: ",time.taken, " sekund(y)"))
print(paste0("Start wykonania skryptu: ",start.time))
print(paste0("Koniec wykonania skryptu: ",end.time))

#zamkniecie pliku
sink()