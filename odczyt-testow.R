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

# licze jeszcze o ile % jest lepszy wynik parallel od seq (tzn. jakim procentem sekwencyjnego czasu jest czas równoleg³y)
par_jest_jaka_czescia_seq <- round((df_wyniki$czas_par / df_wyniki$czas_seq)*100,2)
par_o_ile_lepszy_niz_seq <- abs(100 - par_jest_jaka_czescia_seq)
df_wyniki$par_better_seq <- paste0(as.character(par_o_ile_lepszy_niz_seq),"%")


write.csv(df_wyniki, ".//pogrupowany-wynik-testow.csv", row.names = F)
