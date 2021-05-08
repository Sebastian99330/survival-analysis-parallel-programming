args = commandArgs(trailingOnly = TRUE)

# ten skrypt przyjmuje jeden argument:
# sciezka do pliku z danymi wejsciowymi
# Jak przy wywolaniu skryptu nie podano pierwszego argumentu to rzucamy blad
if (length(args)==0) {
  stop("Sciezka do pliku wejsciowego jest wymagana.", call.=FALSE)
} 

# wczytanie danych
df <- read.table(args[1], sep = "" , header = T)
#df <- read.table("prostate_cancer.txt", sep = "" , header = T)

licza_wierszy = nrow(df)
ilosc_zbiorow = 4

# trzeba dzielic zbior na mozliwie rowne czesci - ale nie od gory do dolu dzielac np. na 4,
# tylko tak bardziej losowo, powyciagac wartosci z roznych wierszy i przyporzadkowac do roznych czesci

# numery_zbiorow dostaja tyle wierszy, ile jest obserwacji w danych wejsciowych (df)
# losujemy tutaj indeksy - sample zwraca wektor liczb. Wektor indeksow od 1 do ilosci zbiorow (np. 4).
# dzieki temu przyporzadkowuje kazdej wartosci z wejsciowego zbioru (df) indeks - do ktorego zbioru ma trafic
# np. jak mamy dane wejsciowe df "63 10 63 18 24", to mozemy miec tutaj wartosci typu "1 3 3 2 4" 
# i to daje informacje do ktorego zbioru (1-4) ma trafic kazda z danych wejsciowych df
numery_zbiorow = sample(1:ilosc_zbiorow, size = licza_wierszy,
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

start.time <- Sys.time()



# tworzy pusta liste - konstruktor utworzenia pustej listy
lista_zbiorow = list()


for(numer in 1:ilosc_zbiorow){
  # which zwraca wektor indeksow
  # which zwraca dla podanego wektora indeksow numery tych rekordow, ktore odpowiadaja numerowi
  # (ktorych indeks czyli przypisanie do grupy pasuje do podanego == numer'u)
  # czyli podajemy numer_zbiorow np. "3 2 3 1 3 3 1 3" i which == 1 i to zwroci "4 7"
  # bo na 4 i 7 pozycji sa wartosci == 1.
  wybrane_idx = which(numery_zbiorow == 1)

  # potem jak mamy te indeksy, to wyciagamy odpowiednie wiersze i zapisujemy do listy
  # df [nr_wiersza, ] siegamy z ramki danych po wybrany wiersz, i po wszystkie kolumny
  # bo jak miejsce na kolumny jest puste to wybiera wartosci ze wszystkich kolumn
  lista_zbiorow[[numer]] = df[wybrane_idx, ]
  
  # potem ta liste zapisujemy do pliku
  # paste0 skleja string, normalnie jak w javie + konkatenacja
  # write.csv(df[wybrane_idx, ], paste0("zbior_", numer,".csv"), row.names = F)
  write.csv(df[wybrane_idx, ], paste0("Split-data\\zbior_", numer,".csv"), row.names = F)
}

end.time <- Sys.time()
time.taken <- as.numeric(end.time - start.time)
time.taken <- format(round(time.taken, 2), nsmall = 2) # formatowanie do dwoch miejsc po przecinku
cat("\n\n")
print(paste0("Dzielenie zbioru danych wejsciowych zajelo: ",time.taken, " sekund(y)"))
print(paste0("Start wykonania skryptu: ",start.time))
print(paste0("Koniec wykonania skryptu: ",end.time))

#zamkniecie pliku
sink()