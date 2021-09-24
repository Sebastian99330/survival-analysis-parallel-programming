args = commandArgs(trailingOnly=TRUE)
# args = as.vector(c(3)) # ewentualnie array(c(10))

# Ten skrypt laczy output czesciowych zbiorow danych. Bierze np. 3 czesciowe outputy i laczy je w jeden.
# Dzieki temu otrzymujemy polaczony zbior danych (liczonych sekwencyjnie),
# Algorytm tego skryptu:
# 1. Wczytujemy zbiory (czesciowe oraz sekwencyjny) z plikow wejsciowych csv do data frame 
# 2. Tworzymy pusty data frame na wynikowy (polaczony) zbior
# 3. Ze zbiorow czesciowych robimy join/merge kolumny "time" i wrzucamy je do ramki wynikowej. Reszta kolumn narazie dostaje wartosc NA
# 4. Obliczamy wynikowa kolumne n_risks (liczbe pacjentow), zlozona ze zbiorow czesciowych
#current_path = dirname(rstudioapi::getSourceEditorContext()$path)
#current_path
#setwd(current_path)

liczba_watkow <- as.numeric(args[1])

# ------------------ Wczytanie danych z plikow input ------------------ #

#wektor z nazwami plikow input zeby moc wczytac kilka(nascie) plikow z danymi wejsciowymi w petli
# my_files = paste0("output_", 1:liczba_watkow, ".txt")
my_files = paste0(".//output_", 1:liczba_watkow, "//", "ramka_", 1:liczba_watkow, ".rds")
# zaladowanie kilku ramek danych (data frame) do listy
lista_ramek <- lapply(my_files, readRDS)
# nazywamy tak elementy listy (czyli pojedyncze data frame'y), aby ich nazwy pasowaly do nazw plikow
names(lista_ramek) <- stringr::str_replace(my_files, pattern = ".rds", replacement = "")

# data frame sekwencyjny, tzn. na zbior danych otrzymanych metoda sekwencyjna, bez dzielenia zbioru wejsciowego
df_seq <- readRDS(".//output_seq//ramka_seq.rds")

# 2. Tworzymy pusty data frame na wynikowy (polaczony) zbior
# df_final - data frame finalne, wynikowe
df_final <- data.frame(matrix(ncol = 7, nrow = 0))
x <- c("time", "n_risk", "n_event", "survival_na_rm", "survival_na_next_row", "lower", "upper")
colnames(df_final) <- x

library(dplyr)


# ------------------ Laczenie kolumny time ------------------ #

# narazie do wynikowej ramki wrzucimy kolumne time bo ona juz jest gotowa
# df_final$time <- select(pomocniczy_df, time) # tak nie moge zrobic bo krzyczy ze sa rozne ilosci wierszy
# dlatego trzeba polaczyc
df_final <- merge(df_final, select(Reduce(function(...) merge(..., by = "time", all=T), lista_ramek), time), by = "time", all = TRUE)




# teraz zbiory czastkowe uzupelnimy o brakujace wiersze
# tzn. zrobimy join kazdej czastkowej ramki z wynikowa kolumna time
# po to zeby moc puste wiersze jakos zastapic w dalszych krokach
# i potem polaczyc ze soba odpowiadajace sobie kolumny w ramkach

# iterujemy po liscie z data frame czastkowych zbiorow
for (i in 1:length(lista_ramek)){
  lista_ramek[[i]] <- merge(lista_ramek[[i]], select(df_final, time), by = "time", all = TRUE)
}

# ------------------ Koniec laczenia kolumny time ------------------ #


# ------------------ przygotowanie funkcji pomocniczej ------------------ #


# do polaczenia niektorych kolumn (najpewniej n_risks oraz survival) miedzy zbiorami
# bedzie przydatne zastapienie wartosci NA wartosciami z nastepnych wierszy
# Czyli jak np wartosci w kolumnie (w kolejnych wierszach) sa: NA NA 513 510 itp,
# to na miejsce pierwszych dwoch NA dajemy 513.
# przygotujemy taka funkcje, ktora to zrobi niezaleznie od tego jakie argumenty (ramke i kolumne) jej podamy



# funkcja, ktora zastepuje wartosc NA w dataframe wartoscia w wierszu ponizej
replace_with_next_row <- function(df, row_index, col_name) {

  # dla widocznosci zapisuje do zmiennej, aktualne pole w data frame na ktorym jestesmy w petli poziom wyzej
  element <- df[row_index,col_name]
  liczba_wierszy <- nrow(df)

  # jesli wiesz jest ostatnim w data rame oraz ma wartosc NA to zwracamy 0
  if(row_index == liczba_wierszy && is.na(element) ) {
    return (0)
  }
  # jesli wiersz NIE jest ostatnim w data rame
  # oraz jesli aktualny wiersz jest rowny NA, to siegamy rekurencyjnie po wartosc wiersz nizej
  else if(row_index != liczba_wierszy && is.na(element)) {
    return(replace_with_next_row(df, (row_index+1),col_name))
  }
  # Pozostaly 2 przypadki (schowane w else): wiersz NIE ma wartosci NA
  # 1. oraz jest ostatnim w data frame
  # 2. oraz nie jest ostatnim w data frame
  # w tych przypadkach zwracamy ten element bez zmian
  # co prawda ten przypadek to reduncancja, bo jest juz ukrywy w 'ifelse' przy wywolywaniu tej funkcji, ale niech zostanie
  else {
    return (element)
  }
}

# ------------------ Koniec: przygotowanie funkcji pomocniczej ------------------ #

# ------------------ Laczenie kolumny n_risks ------------------ #

# teraz zastapimy wartosci NA wartosciami z wiersza ponizej

# iterujemy po liscie z data frame czastkowych zbiorow
for (i in 1:length(lista_ramek)){
  # jak juz jestesmy w pierwszej petli na pojedynczym data frame,
  # to teraz iterujemy po wierszach tego data frame
  # podajemy nazwe kolumny oraz nr wiersza z petli
  # zastepujemy wybrany element - tym samym elementem jesli ma jakas wartosc (nie jest NA)
  # a jesli jest NA, to wywolujemy funkcje ktora wpisuje wartosc z tej samej kolumny z nastepnego wiersza
  # a jesli to jest ostatni wiersz to podaje wartosc 0
  for(row in 1:nrow(lista_ramek[[i]])){
    lista_ramek[[i]][row,"n_risk"] <- ifelse(is.na(lista_ramek[[i]][row,"n_risk"]), replace_with_next_row(df = lista_ramek[[i]], row_index = row, col_name = "n_risk"), lista_ramek[[i]][row,"n_risk"])
  }
}


# trzeba teraz posumowac wartosci miedzy wierszami z roznych kolumn
# zeby otrzymac wyniki bliskie sekwencyjnym


# nazwy kolumn ktore sumujemy (narazie jedna)
cols = c("n_risk")
# ramka final i tak nie ma wartosci w jakiekolwiek innej kolumnie niz "time"
# zatem wypelniamy sobie ja 0 i bedziemy po kolei dodawac sume z kolejnych kolumn data frame
df_final[, cols] <- 0

# sumuje wartosci w kazdym wierszu w kolumnie n_risk
# iterujemy po liscie z data frame czastkowych zbiorow
for (i in 1:length(lista_ramek)){
  # sumujemy / kumulujemy kolejne warosci z kolejnych data frame
  df_final[, cols] = df_final[, cols] + lista_ramek[[i]][,cols]
}


# --------- Koniec: Laczenie kolumny n_risks --------------- #


# --------- Porownanie wynikow - liczenie bledu n_risk --------------- #


# patrze, na ile sie rozni zlaczony wynik od sekwencyjnego
# tworze nowa ramke na wyniki
# beda w niej kolumny odpowiadajace kolumnom w zbiorach wejsciowych
# i wiersze beda reprezentowaly blad kazdego wiersza
# miedzy poskladanym wynikiem df_final a sekwencyjnym df_seq
# nazywam "bledy kazdy wiersz" zeby odroznic od ramki, ktora bedzie miala bledy
# ale procentowo juz posumowane dla calej kolumny np. "kolumna n_risk rozni sie 1% od sekwencyjnego
# tutaj mamy roznice w kazdym wierszu kolumny a nie calosciowo dla kolumny
bledy_kazdy_wiersz <- select(df_final,time)
bledy_kazdy_wiersz$n_risk_errors <- c(abs(df_final$n_risk - df_seq$n_risk))

# sumujemy wartosci w obu kolumnach i patrzymy jaki jest stounek miedzy nimi
proporcja_bledu_do_wyniku_seq <- sum(bledy_kazdy_wiersz$n_risk_errors) / sum(df_seq$n_risk)
procent_blad_n_risk <- paste(round((proporcja_bledu_do_wyniku_seq * 100),2),"%") #bierzemy procent


# tworze ramke na wyniki bledu
# bedzie miala nazwe kolumny oraz wartosc o ile % rozni sie zlozona kolumna od sekwencyjnej
bledy <- data.frame(c("n_risk"),c(procent_blad_n_risk))
colnames(bledy) <- c("nazwa_polaczonej_kolumny","procent_bledu_wzgledem_seq")



# --------- Koniec Porownanie wynikow - liczenie bledu n_risk --------------- #



# --------- Laczenie kolumny event -------- #

# najpierw zastapimy NA zerami w kolumnie n_event
# iterujemy po liscie z data frame, gdzie 1 data frame to 1 zbior czastkowy
for (i in 1:length(lista_ramek)){
  lista_ramek[[i]]$n_event[is.na(lista_ramek[[i]]$n_event)] <- 0
}

# sumuje wartosci z poszczegolnych wierszy z kolumn n_event
# nazwy kolumn ktore sumujemy
cols = c("n_event")
df_final[, cols] <- 0

# sumuje wartosci w kazdym wierszu w kolumnie n_risk
# iterujemy po liscie z data frame czastkowych zbiorow
for (i in 1:length(lista_ramek)){
  # sumujemy / kumulujemy kolejne warosci z kolejnych data frame
  df_final[, cols] = df_final[, cols] + lista_ramek[[i]][,cols]
}

# mamy juz polaczone poprawnie ale musimy zmienic typ kolumn zeby nam funkcja zwrocila true
# sprawdzamy typy kolumn - moze sie potem ta instrukcja przydac przy porownywaniu jakby nie pokazywalo ze jest identyczne mimo ze wartosci bylyby takie same
# sapply(df_final, class)
# sapply(df_seq, class)

# chcemy typ interger po 1. bo to sa liczby calkowite
# a po 2. bo kolumna n_event w data frame sekwencyjnym df_seq ma taki typ
df_final$n_event <- as.integer(df_final$n_event)

# badam czy kolumny sa identyczne
# identical(df_final[['n_event']],df_seq[['n_event']]) # zwraca TRUE
# wpis o tym ze polaczona kolumna jest identyczna
bledy[nrow(bledy) + 1,] = c("n_event","identyczna")


# wyswietlenie tych kolumn w stylu left join
# head(merge(x = select(df_final, time, n_event), y = select(df_seq, time, n_event), by = "time", all.x = TRUE))

# --------------- Laczenie kolumny survival # --------------- #

# porownamy dwie metody laczenia kolumny survival
# 1 wyciagajac srednia z wartosci, ktore nie sa NA,
# 2 za pomoca wypelniania NA wierszami ponizej (tak jak n_risk)


# -------------- Laczenie kolumny survival za pomoca srednia z wartosci (pomijajac wartosci NA) ------- #
# robimy kopie ramki na wypadek jakiejs zmiany
lista_ramek_surv_na_rm <- lista_ramek

# bind_rows przyjmuje liste data frame jako argument
# i zwraca jeden data frame, ktory ma zawartosc data frame'ow z listy
# jedne pod drugimi. Czyli nie mamy liste ramek w liscie "obok siebie",
# tylko jeden data frame z wieloma wierszami
lista_df_rbind = bind_rows(lista_ramek_surv_na_rm)

survival_polaczony <- lista_df_rbind %>%
  group_by(time) %>%
  summarise(avg_survival = mean(survival, na.rm=TRUE)) %>%
  data.frame()

survival_polaczony$avg_survival <- round(survival_polaczony$avg_survival,4)
df_final$survival_na_rm <- survival_polaczony$avg_survival

# sprawdzamy roznice
bledy_kazdy_wiersz$survival_na_rm_err <- abs(df_final$survival_na_rm  - df_seq$survival)

# sumujemy wartosci w obu kolumnach i patrzymy jaki jest stounek miedzy nimi
proporcja_bledu_do_wyniku_seq <- sum(bledy_kazdy_wiersz$survival_na_rm_err) / sum(df_seq$survival)
procent_blad_survival <- paste(round((proporcja_bledu_do_wyniku_seq * 100),2),"%")
bledy[nrow(bledy) + 1,] = c("n_survival_srednia_bez_na",procent_blad_survival)

# -------------- Koniec: Laczenie kolumny survival za pomoca srednia z wartosci (pomijajac wartosci NA) ------- #

# -------------- Laczenie kolumny survival za pomoca wypelniania NA wierszami ponizej (tak jak n_risk) ------- #
# robimy kopie ramki i bedziemy pracowac na niej, bo musimy ja edytowac
lista_ramek_surv_na_to_next_wiersz <- lista_ramek
# teraz zastapimy wartosci NA wartosciami z wiersza ponizej

cols = c("survival")

# zastepujemy wartosci NA wartosciami z wiersza ponizej
# iterujemy po liscie z data frame czastkowych zbiorow
for (i in 1:length(lista_ramek_surv_na_to_next_wiersz)){
  # jak juz jestesmy w pierwszej petli na pojedynczym data frame,
  # to teraz iterujemy po wierszach tego data frame
  # podajemy nazwe kolumny oraz nr wiersza z petli
  # zastepujemy wybrany element - tym samym elementem jesli ma jakas wartosc (nie jest NA)
  # a jesli jest NA, to wywolujemy funkcje ktora wpisuje wartosc z tej samej kolumny z nastepnego wiersza
  # a jesli to jest ostatni wiersz to podaje wartosc 0
  for(row in 1:nrow(lista_ramek_surv_na_to_next_wiersz[[i]])){
    lista_ramek_surv_na_to_next_wiersz[[i]][row,cols] <- ifelse(is.na(lista_ramek_surv_na_to_next_wiersz[[i]][row,cols]), replace_with_next_row(df = lista_ramek_surv_na_to_next_wiersz[[i]], row_index = row, col_name = cols), lista_ramek_surv_na_to_next_wiersz[[i]][row,cols])
  }
}

# --------------- NA <- wartoœæ z nastêpnego wiersza dla kolumn lower i upper # --------------- #
cols = c("lower")
# zastepujemy wartosci NA wartosciami z wiersza ponizej
# iterujemy po liscie z data frame czastkowych zbiorow
for (i in 1:length(lista_ramek_surv_na_to_next_wiersz)){
  # jak juz jestesmy w pierwszej petli na pojedynczym data frame,
  # to teraz iterujemy po wierszach tego data frame
  # podajemy nazwe kolumny oraz nr wiersza z petli
  # zastepujemy wybrany element - tym samym elementem jesli ma jakas wartosc (nie jest NA)
  # a jesli jest NA, to wywolujemy funkcje ktora wpisuje wartosc z tej samej kolumny z nastepnego wiersza
  # a jesli to jest ostatni wiersz to podaje wartosc 0
  for(row in 1:nrow(lista_ramek_surv_na_to_next_wiersz[[i]])){
    lista_ramek_surv_na_to_next_wiersz[[i]][row,cols] <- ifelse(is.na(lista_ramek_surv_na_to_next_wiersz[[i]][row,cols]), replace_with_next_row(df = lista_ramek_surv_na_to_next_wiersz[[i]], row_index = row, col_name = cols), lista_ramek_surv_na_to_next_wiersz[[i]][row,cols])
  }
}

cols = c("upper")
# zastepujemy wartosci NA wartosciami z wiersza ponizej
# iterujemy po liscie z data frame czastkowych zbiorow
for (i in 1:length(lista_ramek_surv_na_to_next_wiersz)){
  # jak juz jestesmy w pierwszej petli na pojedynczym data frame,
  # to teraz iterujemy po wierszach tego data frame
  # podajemy nazwe kolumny oraz nr wiersza z petli
  # zastepujemy wybrany element - tym samym elementem jesli ma jakas wartosc (nie jest NA)
  # a jesli jest NA, to wywolujemy funkcje ktora wpisuje wartosc z tej samej kolumny z nastepnego wiersza
  # a jesli to jest ostatni wiersz to podaje wartosc 0
  for(row in 1:nrow(lista_ramek_surv_na_to_next_wiersz[[i]])){
    lista_ramek_surv_na_to_next_wiersz[[i]][row,cols] <- ifelse(is.na(lista_ramek_surv_na_to_next_wiersz[[i]][row,cols]), replace_with_next_row(df = lista_ramek_surv_na_to_next_wiersz[[i]], row_index = row, col_name = cols), lista_ramek_surv_na_to_next_wiersz[[i]][row,cols])
  }
}
# --------------- Koniec: NA <- wartoœæ z nastêpnego wiersza dla kolumn lower i upper# --------------- #

# ukladamy wartosci z ramek pod siebie
# czyli zamiast miec kilka ramek w liscie "obok siebie",
# bedziemy mieli jedna ramke w ktorej zawartosci data frame beda doklejone po prostu pod spodem jako kolejne wiersze
lista_df_rbind <- bind_rows(lista_ramek_surv_na_to_next_wiersz)

# liczymy srednia z wierszy
survival_polaczony <- lista_df_rbind %>%
  group_by(time) %>%
  # robie replace wartosci 0 na NA, zeby moc potem zaaplikowac na.rm = TRUE
  # bo nie chce wartosci 0 czyli braku wartosci (bo funkcja survival zawsze ma jakas wartosc) liczyc do sredniej
  summarise(avg_survival = mean(replace(survival, survival == 0, NA), na.rm=TRUE),
            avg_lower = mean(lower, na.rm=TRUE),
            avg_upper  = mean(upper , na.rm=TRUE)) %>%
  data.frame()

df_final$survival_na_next_row <- survival_polaczony$avg_survival
df_final$lower <- survival_polaczony$avg_lower
df_final$upper <- survival_polaczony$avg_upper


bledy_kazdy_wiersz$survival_na_next_row_err <- abs(df_final$survival_na_next_row - df_seq$survival)
bledy_kazdy_wiersz$lower_err <- abs(df_final$lower - df_seq$lower)
bledy_kazdy_wiersz$upper_err <- abs(df_final$upper - df_seq$upper)


# nie potrzebujemy tego, wiec nie obliczamy poki co. To jest raczej podgladowe, do debugowania
# ramka dla ladnego porownania wszystkich wartosci (zlaczonych, seq i bledow)
# wszystkie_survivale <- left_join(x = df_final, y = df_seq, by = "time", copy = FALSE) %>%
#   left_join(y = bledy_kazdy_wiersz, by = "time", copy = FALSE) %>%
#   select(time, survival_na_rm, survival_na_rm_err, survival_na_next_row, survival_na_next_row_err, survival)

# nazwy_kolumn_surv <- c("time", "survival_na_rm", "survival_na_rm_err", "survival_na_next_row", "survival_na_next_row_err", "survival_seq")
# colnames(wszystkie_survivale) <- nazwy_kolumn_surv

# dorzucamy jeszcze czastkowe survivale
# for (i in 1:length(lista_ramek_surv_na_to_next_wiersz)){
#   wszystkie_survivale <-
#     wszystkie_survivale %>%
#     left_join(y=select(lista_ramek_surv_na_to_next_wiersz[[i]], time, survival), by = "time", copy = FALSE)
#   nazwy_kolumn_surv <- c(nazwy_kolumn_surv, paste0("survival_", i))
#   colnames(wszystkie_survivale) <- nazwy_kolumn_surv
# }




# sumujemy wartosci w obu kolumnach i patrzymy jaki jest stounek miedzy nimi
proporcja_bledu_do_wyniku_seq_dwa <- sum(bledy_kazdy_wiersz$survival_na_next_row_err) / sum(df_seq$survival)
procent_blad_survival_dwa <- paste(round((proporcja_bledu_do_wyniku_seq_dwa * 100),2),"%")
bledy[nrow(bledy) + 1,] <- c("n_survival_na_to_wiersz_ponizej",procent_blad_survival_dwa)

# sumujemy wartosci w obu kolumnach i patrzymy jaki jest stounek miedzy nimi
proporcja_bledu_do_wyniku_seq_dwa <- sum(bledy_kazdy_wiersz$lower_err) / sum(df_seq$lower)
procent_blad_lower <- paste(round((proporcja_bledu_do_wyniku_seq_dwa * 100),2),"%")
bledy[nrow(bledy) + 1,] <- c("n_lower",procent_blad_lower)

# sumujemy wartosci w obu kolumnach i patrzymy jaki jest stounek miedzy nimi
proporcja_bledu_do_wyniku_seq_dwa <- sum(bledy_kazdy_wiersz$upper_err) / sum(df_seq$upper)
procent_blad_upper <- paste(round((proporcja_bledu_do_wyniku_seq_dwa * 100),2),"%")
bledy[nrow(bledy) + 1,] <- c("n_upper",procent_blad_upper)





# -------------- Koniec: Laczenie kolumny survival za pomoca wypelniania NA wierszami ponizej (tak jak n_risk) ------- #
# --------------- Koniec: laczenie kolumny survival# --------------- #



# Usuniecie katalogu na output jesli istnieje
# unlink(".//output_laczenie", recursive = TRUE)

# utworzenie katalogu na nowe pliki z danymi wejsciowymi
# dir.create(file.path(".//output_laczenie"), showWarnings = FALSE)

# wypisanie wszystkich waznych danych - wyniku skryptu do folderu na output
# write.csv(df_final, ".//output_laczenie//output-polaczone.csv", row.names = F)
# write.csv(wszystkie_survivale, ".//output_laczenie//wszystkie_survivale.csv", row.names = F)
# write.csv(bledy_kazdy_wiersz, ".//output_laczenie//bledy-cale-wiersze.csv", row.names = F)
# write.csv(bledy, ".//output_laczenie//bledy_podsumowanie.csv", row.names=F)

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
wpis <- paste0(potrzebne_staty_df[1,1],",",potrzebne_staty_df[1,2],",",potrzebne_staty_df[1,3],",",potrzebne_staty_df[1,4],",",potrzebne_staty_df[1,5],",")
# wpis prawie gotowy ale trzeba jeszcze usunac ' %', zeby zostaly same liczby, a nie np. 0.18 %
library("stringr")
wpis <- str_replace_all(wpis, " %", "")

# write(string, file = ".//statystyki.csv", append = TRUE) # inna opcja, dokleja new line na koniec linii
# bedziemy pisali do pliku statystyki.csv, ale jak go nie ma to tworzymy jego i pierwsza linijke z header'ami
if(!file.exists(".//statystyki.csv")){
  headers <- "n_risk,n_survival_bez_na,n_survival_na_to_wiersz_ponizej, lower, upper, liczba_wierszy, liczba_watkow, czas_seq, czas_par, par_lepsze_niz_seq, nazwa_inputu\n"
  cat(headers, file = ".//statystyki.csv", append = T)
}
cat(wpis, file = ".//statystyki.csv", append = T)

# wygenerowanie wykresu z polaczonej ramki danych i zapisanie jej do pliku
# source(file.path("./narysuj_graf.R"))
# narysuj_graf(df_final$time, df_final$survival_na_next_row)

# wypisanie wyniku skryptu do folderu na output 
# w formie rds - bo sekwencyjne dane sa wypisane tak samo, wiec zeby nie bylo roznicy w czasie przez to
# write.csv(df_final, ".//output_polaczone//survival.csv", row.names = F)
saveRDS(df_final, ".//output_polaczone//survival.csv")


library(ggplot2)
library(utile.visuals)

# otwarcie pliku do ktoego rysujemy wykres z regresji coxa
jpeg(".//output_polaczone/cph_merged.jpg", width = 1698, height = 754)

ggplot2::ggplot(df_final, aes(time,survival_na_next_row)) +
  ggplot2::geom_step() +
  utile.visuals::geom_stepconfint(aes(ymin = lower, ymax = upper), alpha = 0.3)


dev.off()
# koniec rysowania wykresu polaczonej ramki
