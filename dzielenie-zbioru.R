df = iris

licza_wierszy = nrow(df)
ilosc_zbiorow = 4


# numery zbiorow maja tyle wierszy, ile jest obserwacji w pliku
numery_zbiorow = sample(1:ilosc_zbiorow, size = licza_wierszy,
                        replace = TRUE)
# zwraca proporcje - najlepiej po 25%, wtedy jest dobrze
# trzeba zbadac czy dobrze dzieli, bo musi byc rowne obciazenie watku
prop.table(table(numery_zbiorow))

# tworzy pusta liste - konstruktor utworzenia pustej listy
lista_zbiorow = list()

# trzeba dzielic zbior na mozliwie rowne czesci - ale nie od gory do dolu dzielac na 4
# tylko tak bardziej losowo,
for(numer in 1:ilosc_zbiorow){
  # which zwraca indeksy, otrzymuje wektor
  # which zwraca dla podanego zbioru wierszy, te rekordy, ktore odpowiadaja numerowi
  # numery zbiorow maja przypisanie do odpowiedniego zbioru (od 1 do 4) dla kazdego rekordu,
  #i potem za pomoca to which zwraca te indeksy, ktoresa do np. 4 zbioru
  wybrane_idx = which(numery_zbiorow == numer)
  # potem jak mamy te indeksy, to wyciagamy odpowiednie wiersze i zapisujemy do listy 
  lista_zbiorow[[numer]] = df[wybrane_idx, ]
  
  # potem ta liste zapisujemy do pliku
  #paste0 skleja string, normalnie jak w javie
  write.csv(df[wybrane_idx, ], paste0("zbior_", numer,".csv"), row.names = F)
}
