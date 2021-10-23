df <- read.table("statystyki.csv", sep = "," , header = T)
df <- df[,c("liczba_wierszy","liczba_watkow","czas_seq","czas_par","par_lepsze_niz_seq","nazwa_inputu","n_risk","survival","lower","upper")] #zamieniam kolejnosc kolumn

library(dplyr)
df_wyniki <- df %>%
  group_by(nazwa_inputu, liczba_wierszy, liczba_watkow) %>%
  summarise(czas_seq = round(mean(czas_seq, na.rm=TRUE),4), 
            czas_par = round(mean(czas_par, na.rm=TRUE),4),
            n_risk  = round(mean(n_risk , na.rm=TRUE),4),
            #n_survival_bez_na  = round(mean(n_survival_bez_na , na.rm=TRUE),4),
            survival = round(mean(survival, na.rm=TRUE),4),
            lower = round(mean(lower, na.rm=TRUE),4),
            upper = round(mean(upper, na.rm=TRUE),4),
            liczba_testow = n()) %>%
  data.frame()

# otrzymujemy przyspieszenie - ile razy jest szybciej?
seq_par_stosunek <- round((df_wyniki$czas_seq / df_wyniki$czas_par),2)
df_wyniki$par_better_seq <- paste0(as.character(seq_par_stosunek),"x")

#zamieniam kolejnosc kolumn
#df_wyniki <- df_wyniki[,c("nazwa_inputu","liczba_wierszy","liczba_watkow","liczba_testow","czas_seq","czas_par","par_better_seq","n_risk","n_survival_bez_na","n_survival_na_to_wiersz_ponizej","lower","upper")]
df_wyniki <- df_wyniki[,c("nazwa_inputu","liczba_wierszy","liczba_watkow","liczba_testow","czas_seq","czas_par","par_better_seq","n_risk","survival","lower","upper")]

write.csv(df_wyniki, ".//pogrupowany-wynik-testow.csv", row.names = F)

# obliczenie sredniej bez grupowania - srednia ze wszystkich testow
df_calkowita_srednia <- df %>%
  summarise(czas_seq = round(mean(czas_seq, na.rm=TRUE),4), 
            czas_par = round(mean(czas_par, na.rm=TRUE),4)
  ) %>%
  data.frame()

# otrzymujemy przyspieszenie - ile razy jest szybciej?
seq_par_stosunek_calk <- round((df_calkowita_srednia$czas_seq / df_calkowita_srednia$czas_par),2)
df_calkowita_srednia$par_better_seq <- paste0(as.character(seq_par_stosunek_calk),"x")
write.csv(df_calkowita_srednia, ".//srednia-ze-wszystkich-testow.csv", row.names = F)
