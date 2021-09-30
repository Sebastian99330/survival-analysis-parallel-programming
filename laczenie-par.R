

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






polacz_ramki <- function (lista_ramek, liczba_watkow){
  
  # ------------------ Laczenie kolumny time ------------------ #
  
  # 2. Tworzymy pusty data frame na polaczona kolumne time
  df_time <- data.frame(matrix(ncol = 1, nrow = 0))
  colnames(df_time) <- c("time")
  
  library(dplyr)
  
  df_time <- merge(df_time, select(Reduce(function(...) merge(..., by = "time", all=T), lista_ramek), time), by = "time", all = TRUE)
  
  
  # iterujemy po liscie z data frame czastkowych zbiorow
  # laczymy czastkowe data frame miedzy soba po to, zeby byly NA w czastkowych zbiorach tam, gdzie nie ma warosci
  #lista_ramek <- foreach(i=1:length(lista_ramek)) %dopar% {
  for (i in 1:length(lista_ramek)){
  # lista_ramek <- foreach(i=1:length(lista_ramek) %dopar% {
    lista_ramek[[i]] <- merge(lista_ramek[[i]], select(df_time, time), by = "time", all = TRUE)
  }
  
  # head(lista_ramek[[1]])
  # ------------------ koniec: Laczenie kolumny time ------------------ #
  
  # ------------------ Wypelniamy NA wartosciami z nast. wierszy ------------------ #
  
  # iterujemy po liscie z data frame czastkowych zbiorow
  # lista_ramek <- foreach(i=1:length(lista_ramek)) %dopar% {
  for (i in 1:length(lista_ramek)){
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
  
  # ------------------ Koniec: Wypelniamy NA wartosciami z nast. wierszy ------------------ #
  
  # ------------------ Laczymy kolumny ------------------ #
  # ukladamy wartosci z ramek pod siebie
  # czyli zamiast miec kilka ramek w liscie "obok siebie",
  # bedziemy mieli jedna ramke w ktorej zawartosci data frame beda doklejone po prostu pod spodem jako kolejne wiersze
  lista_df_rbind <- bind_rows(lista_ramek)
  
  # liczymy srednia z wierszy
  df_final <- lista_df_rbind %>%
    group_by(time) %>%
    # robie replace wartosci 0 na NA, zeby moc potem zaaplikowac na.rm = TRUE
    # bo nie chce wartosci 0 czyli braku wartosci (bo funkcja survival zawsze ma jakas wartosc) liczyc do sredniej
    summarise(time = mean(time, na.rm=TRUE),
              n_risk = sum(n_risk, na.rm=TRUE),
              n_event = sum(n_event, na.rm=TRUE),
              survival_na_next_row = mean(replace(survival, survival == 0, NA), na.rm=TRUE),
              lower = mean(lower, na.rm=TRUE),
              upper  = mean(upper , na.rm=TRUE)) %>%
    data.frame()
  
  # ------------------ Koniec: Laczymy kolumny ------------------ #
  
  saveRDS(df_final, "output//output_polaczone//survival.rds")
}
  

