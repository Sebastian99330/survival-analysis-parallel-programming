args = commandArgs(trailingOnly=TRUE)
# args = as.vector(c(3)) # ewentualnie array(c(10))

#current_path = dirname(rstudioapi::getSourceEditorContext()$path)
#current_path
#setwd(current_path)

liczba_watkow <- as.numeric(args[1])

# ------------------ Wczytanie danych z plikow input ------------------ #

#wektor z nazwami plikow input zeby moc wczytac kilka(nascie) plikow z danymi wejsciowymi w petli
my_files = paste0("output//output_", 1:liczba_watkow, "//", "ramka_", 1:liczba_watkow, ".rds")
# zaladowanie kilku ramek danych (data frame) do listy
lista_ramek <- lapply(my_files, readRDS)
# nazywamy tak elementy listy (czyli pojedyncze data frame'y), aby ich nazwy pasowaly do nazw plikow
names(lista_ramek) <- stringr::str_replace(my_files, pattern = ".rds", replacement = "")


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


# iterujemy po liscie z data frame czastkowych zbiorow
for (i in 1:length(lista_ramek)){
  lista_ramek[[i]] <- merge(lista_ramek[[i]], select(df_final, time), by = "time", all = TRUE)
}

# ------------------ Koniec laczenia kolumny time ------------------ #


# ------------------ przygotowanie funkcji pomocniczej ------------------ #

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

# -------------- Laczenie kolumny survival za pomoca srednia z wartosci (pomijajac wartosci NA) ------- #
# UWAGA: ta sekcja musi byc przed kolejna sekcja "Zastepuje wartosci NA wartosciami z nast. wiersza dla wielu kolumn"

# # robimy kopie ramki na wypadek jakiejs zmiany
# lista_ramek_surv_na_rm <- lista_ramek
# 
# # bind_rows przyjmuje liste data frame jako argument
# # i zwraca jeden data frame, ktory ma zawartosc data frame'ow z listy
# # jedne pod drugimi. Czyli nie mamy liste ramek w liscie "obok siebie",
# # tylko jeden data frame z wieloma wierszami
# lista_df_rbind = bind_rows(lista_ramek_surv_na_rm)
# 
# survival_polaczony <- lista_df_rbind %>%
#   group_by(time) %>%
#   summarise(avg_survival = mean(survival, na.rm=TRUE)) %>%
#   data.frame()
# 
# df_final$survival_na_rm <- survival_polaczony$avg_survival


# -------------- Koniec: Laczenie kolumny survival za pomoca srednia z wartosci (pomijajac wartosci NA) ------- #


# ------------------ Zastepuje wartosci NA wartosciami z nast. wiersza dla wielu kolumn ------------------ #

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
    lista_ramek[[i]][row,"survival"] <- ifelse(is.na(lista_ramek[[i]][row,"survival"]), replace_with_next_row(df = lista_ramek[[i]], row_index = row, col_name = "survival"), lista_ramek[[i]][row,"survival"])
    lista_ramek[[i]][row,"lower"] <- ifelse(is.na(lista_ramek[[i]][row,"lower"]), replace_with_next_row(df = lista_ramek[[i]], row_index = row, col_name = "lower"), lista_ramek[[i]][row,"lower"])
    lista_ramek[[i]][row,"upper"] <- ifelse(is.na(lista_ramek[[i]][row,"upper"]), replace_with_next_row(df = lista_ramek[[i]], row_index = row, col_name = "upper"), lista_ramek[[i]][row,"upper"])
  }
}

# ------------------ Koniec: Zastepuje wartosci NA wartosciami z nast. wiersza dla wielu kolumn ------------------ #



# ------------------ Laczenie kolumny n_risks ------------------ #



# trzeba teraz posumowac wartosci miedzy wierszami z odpowiadajacych sobie kolumn miedzy czastkowymi ramkami

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

# df_final <- lapply(lista_ramek,function(x) rowSums(x[,cols])) # to szybciej posumuje ale nie dziala


# --------- Koniec: Laczenie kolumny n_risks --------------- #



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
  # chcemy typ interger po 1. bo to sa liczby calkowite
  # a po 2. bo kolumna n_event w data frame sekwencyjnym df_seq ma taki typ
  df_final[, cols] = df_final[, cols] + lista_ramek[[i]][,cols]
}



# -------------- Laczenie kolumny survival, upper i lower za pomoca wypelniania NA wierszami ponizej (tak jak n_risk) ------- #


# ukladamy wartosci z ramek pod siebie
# czyli zamiast miec kilka ramek w liscie "obok siebie",
# bedziemy mieli jedna ramke w ktorej zawartosci data frame beda doklejone po prostu pod spodem jako kolejne wiersze
lista_df_rbind <- bind_rows(lista_ramek)

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


# -------------- Koniec: Laczenie kolumny survival za pomoca wypelniania NA wierszami ponizej (tak jak n_risk) ------- #
# --------------- Koniec: laczenie kolumny survival# --------------- #


saveRDS(df_final, "output//output_polaczone//survival.rds")

