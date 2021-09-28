df_polaczone <- readRDS("output//output_polaczone//survival.rds")

df_seq <- readRDS("output//output_seq//ramka_seq.rds")


library(dplyr)

# --------- liczenie bledu n_risk --------------- #

# patrze, na ile sie rozni zlaczony wynik od sekwencyjnego.
# Tworze nowa ramke na wyniki -
# beda w niej kolumny odpowiadajace kolumnom w zbiorach wejsciowych
# i wiersze beda reprezentowaly blad kazdego wiersza
# miedzy poskladanym wynikiem df_polaczone, a sekwencyjnym df_seq.
# Nazwa "bledy kazdy wiersz" zeby odroznic od ramki, ktora bedzie miala bledy,
# ale procentowo juz posumowane dla calej kolumny np. "kolumna n_risk rozni sie 1% od sekwencyjnego
# tutaj mamy roznice w kazdym wierszu kolumny a nie calosciowo dla kolumny
bledy_kazdy_wiersz <- select(df_polaczone,time)
bledy_kazdy_wiersz$n_risk_errors <- c(abs(df_polaczone$n_risk - df_seq$n_risk))

# sumujemy wartosci w obu kolumnach i patrzymy jaki jest stounek miedzy nimi
proporcja_bledu_do_wyniku_seq <- sum(bledy_kazdy_wiersz$n_risk_errors) / sum(df_seq$n_risk)
procent_blad_n_risk <- paste(round((proporcja_bledu_do_wyniku_seq * 100),2),"%") #bierzemy procent


# tworze ramke na wyniki bledu
# bedzie miala nazwe kolumny oraz wartosc o ile % rozni sie zlozona kolumna od sekwencyjnej
bledy <- data.frame(c("n_risk"),c(procent_blad_n_risk))
colnames(bledy) <- c("nazwa_polaczonej_kolumny","procent_bledu_wzgledem_seq")



# --------- Koniec liczenie bledu n_risk --------------- #

# --------- liczenie bledu n_event --------------- #

# badam czy kolumny sa identyczne
czy_event_identycznie <- identical(df_polaczone[['n_event']],df_seq[['n_event']]) # zwraca TRUE
if(as.logical(czy_event_identycznie) == T) {
# wpis o tym ze polaczona kolumna jest identyczna
  bledy[nrow(bledy) + 1,] = c("n_event","identyczna")
} else {
  bledy[nrow(bledy) + 1,] = c("n_event","wystapil blad")
}


# --------- koniec liczenie bledu n_event --------------- #

# --------- blad survival na rm --------------- #

# sprawdzamy roznice
bledy_kazdy_wiersz$survival_na_rm_err <- abs(df_polaczone$survival_na_rm  - df_seq$survival)

# sumujemy wartosci w obu kolumnach i patrzymy jaki jest stounek miedzy nimi
proporcja_bledu_do_wyniku_seq <- sum(bledy_kazdy_wiersz$survival_na_rm_err) / sum(df_seq$survival)
procent_blad_survival <- paste(round((proporcja_bledu_do_wyniku_seq * 100),2),"%")
bledy[nrow(bledy) + 1,] = c("n_survival_srednia_bez_na",procent_blad_survival)

# --------- koniec blad survival na rm --------------- #

# --------- blad survival na to next wiersz, lower, upper --------------- #


bledy_kazdy_wiersz$survival_na_next_row_err <- abs(df_polaczone$survival_na_next_row - df_seq$survival)
bledy_kazdy_wiersz$lower_err <- abs(df_polaczone$lower - df_seq$lower)
bledy_kazdy_wiersz$upper_err <- abs(df_polaczone$upper - df_seq$upper)



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

saveRDS(bledy, "output//output_polaczone//bledy.rds")


# --------- koniec blad survival na to next wiersz, lower, upper --------------- #
