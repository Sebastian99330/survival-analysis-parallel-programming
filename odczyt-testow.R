df <- read.table("statystyki.csv", sep = "," , header = T)
df <- df[,c(4,5,6,7,1,2,3)] #zamieniam kolejnosc kolumn

library(dplyr)

df_wyniki <- df %>%
  group_by(liczba_wierszy, liczba_watkow) %>%
  summarise(czas_seq = round(mean(czas_seq, na.rm=TRUE),4), 
            czas_par = round(mean(czas_par, na.rm=TRUE),4),
            n_risk  = round(mean(n_risk , na.rm=TRUE),4),
            n_survival_bez_na  = round(mean(n_survival_bez_na , na.rm=TRUE),4),
            n_survival_na_to_wiersz_ponizej = round(mean(n_survival_na_to_wiersz_ponizej, na.rm=TRUE),4),
            liczba_testow = n()) %>%
            data.frame()

write.csv(df_wyniki, ".//pogrupowany-wynik-testow.csv", row.names = F)
