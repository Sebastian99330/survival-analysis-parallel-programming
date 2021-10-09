args <- commandArgs(trailingOnly=TRUE)
# wczytuje ramke z bledami i zapisuje je do pliku 'statystyki" ktory zbiera wartosci z wykonania programu
# args <- c("output//output_polaczone//bledy.rds", "output//output_polaczone//bledy_csv.csv")

input_bledy <- args[1]
output_bledy <- args[2]

bledy <- readRDS(input_bledy)

# wypisanie statystyk jako nowe linijki do istniejacego pliku z wynikami
# write(paste0("\n\nLiczba watkow: ",liczba_watkow), file = ".//wyniki-testow-wszystkie.csv", append = TRUE)
# write.table(bledy, ".//wyniki-testow-wszystkie.csv", row.names=F, append = T)

# transponuje ramke na bledy
potrzebne_staty_df <- as.data.frame(t(bledy))
colnames(potrzebne_staty_df) <- c(potrzebne_staty_df[1,]) # pierwszy wiersz po transpozycji ma nazwy kolumn
potrzebne_staty_df <- potrzebne_staty_df[-1,] # usuwam 1 kolumne czyli stara nazwe kolumny - sprzed transpozycji
rownames(potrzebne_staty_df) <- NULL #niepotrzebnie 1 wiersz ma niby nazwe wiersza
potrzebne_staty_df <- potrzebne_staty_df[,-2] # usuwam kolumne "n_event" bo ona i tak zawsze jest identyczna


# lacze pierwszy wiersz we wpis string
wpis <- paste0(potrzebne_staty_df[1,1],",",potrzebne_staty_df[1,2],",",potrzebne_staty_df[1,3],",",potrzebne_staty_df[1,4],",")
# wpis prawie gotowy ale trzeba jeszcze usunac ' %', zeby zostaly same liczby, a nie np. 0.18 %
library("stringr")
wpis <- str_replace_all(wpis, " %", "")

# write(string, file = ".//statystyki.csv", append = TRUE) # inna opcja, dokleja new line na koniec linii
# bedziemy pisali do pliku statystyki.csv, ale jak go nie ma to tworzymy jego i pierwsza linijke z header'ami
if(!file.exists(".//statystyki.csv")){
  #headers <- "n_risk,n_survival_bez_na,n_survival_na_to_wiersz_ponizej, lower, upper, liczba_wierszy, liczba_watkow, czas_seq, czas_par, par_lepsze_niz_seq, nazwa_inputu, data\n" # bez survival na rm
  headers <- "n_risk,survival, lower, upper, liczba_wierszy, liczba_watkow, czas_seq, czas_par, par_lepsze_niz_seq, nazwa_inputu, data\n"
  cat(headers, file = ".//statystyki.csv", append = T)
}
cat(wpis, file = ".//statystyki.csv", append = T)

write.csv(df,output_bledy, row.names = F)

