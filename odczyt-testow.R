df <- read.table("statystyki.csv", sep = "," , header = T)

df <- df[,c(4,5,6,7,8,9,1,2,3)] #zamieniam kolejnosc kolumn

library(dplyr)

df_wyniki <- df %>%
  group_by(nazwa_inputu, liczba_wierszy, liczba_watkow) %>%
  summarise(czas_seq = round(mean(czas_seq, na.rm=TRUE),4), 
            czas_par = round(mean(czas_par, na.rm=TRUE),4),
            n_risk  = round(mean(n_risk , na.rm=TRUE),4),
            n_survival_bez_na  = round(mean(n_survival_bez_na , na.rm=TRUE),4),
            n_survival_na_to_wiersz_ponizej = round(mean(n_survival_na_to_wiersz_ponizej, na.rm=TRUE),4),
            liczba_testow = n()) %>%
            data.frame()


# otrzymujemy przyspieszenie - ile razy jest szybciej?
par_jest_jaka_czescia_seq <- round((df_wyniki$czas_seq / df_wyniki$czas_par),2)
df_wyniki$par_better_seq <- paste0(as.character(par_jest_jaka_czescia_seq),"x")


write.csv(df_wyniki, ".//pogrupowany-wynik-testow.csv", row.names = F)
