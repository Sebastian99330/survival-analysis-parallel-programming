df <- read.table("statystyki.csv", sep = "," , header = T)
df <- df[,c("liczba_wierszy","liczba_watkow","czas_seq","czas_par","par_lepsze_niz_seq","nazwa_inputu","n_risk","survival","lower","upper")] #zamieniam kolejnosc kolumn

library(dplyr)
df_wyniki <- df %>%
  group_by(nazwa_inputu, liczba_wierszy, liczba_watkow) %>%
  summarise(seq = round(mean(czas_seq, na.rm=TRUE),4), 
            par = round(mean(czas_par, na.rm=TRUE),4),
            n_risk  = round(mean(n_risk , na.rm=TRUE),4),
            #n_survival_bez_na  = round(mean(n_survival_bez_na , na.rm=TRUE),4),
            survival = round(mean(survival, na.rm=TRUE),4),
            lower = round(mean(lower, na.rm=TRUE),4),
            upper = round(mean(upper, na.rm=TRUE),4),
            liczba_testow = n()) %>%
            data.frame()
# head(df_wyniki)
# otrzymujemy przyspieszenie - ile razy jest szybciej?
seq_par_stosunek <- round((df_wyniki$seq / df_wyniki$par),2)
df_wyniki$par_better_seq <- paste0(as.character(seq_par_stosunek),"x")

# zmiana nazw kolumn na dobre dla docelowego pliku
colnames(df_wyniki) <- c("input","wiersze","watki","seq","par","risk", "surv", "lower","upper","testy", "par_better")

# zapis do pliku podstawowej wersji ramki
write.csv(df_wyniki, ".//pogrupowany-wynik-testow.csv", row.names = F, quote = F)

# dalej przerabiam dane zeby wrzucic je do tabeli latex
nrow(df_wyniki)
# wyrzucam niepotrzebne fragmenty inputu, zeby nie zajmowac miejsca w tabelce w latex
df_wyniki$input <- gsub('-mln.csv','',df_wyniki$input)
df_wyniki$input <- gsub('-cancer','',df_wyniki$input)
df_wyniki$input <- gsub('\\_mln.csv','',df_wyniki$input)
head(df_wyniki)

#zamieniam kolejnosc kolumn
df_wyniki <- df_wyniki[c("input","wiersze","watki","testy","seq","par","par_better","risk","surv","lower","upper")]
df_czas <- df_wyniki[c("input","wiersze","watki","testy","seq","par","par_better")]
# head(df_czas)
df_bledy <- df_wyniki[c("input","wiersze","watki","testy","risk","surv","lower","upper")]

library(xtable)
# print(xtable(df_czas, type = "latex"), file = "testy-czas-latex.tex")
print(xtable(df_czas, type = "latex", tabular.environment="longtable"), file = "testy-czas-latex.tex")

write.csv(df_bledy, ".//pogrupowany-wynik-bledy.csv", row.names = F, quote = F)
write.csv(df_czas, ".//pogrupowany-wynik-czas.csv", row.names = F, quote = F)

# head(df)
# obliczenie sredniej bez grupowania - srednia ze wszystkich testow
df_calkowita_srednia <- df %>%
  summarise(seq = round(mean(czas_seq, na.rm=TRUE),4), 
            par = round(mean(czas_par, na.rm=TRUE),4)
  ) %>%
  data.frame()

# otrzymujemy przyspieszenie - ile razy jest szybciej?
seq_par_stosunek_calk <- round((df_calkowita_srednia$seq / df_calkowita_srednia$par),2)
df_calkowita_srednia$par_better <- paste0(as.character(seq_par_stosunek_calk),"x")
write.csv(df_calkowita_srednia, ".//srednia-ze-wszystkich-testow.csv", row.names = F, quote = F)

