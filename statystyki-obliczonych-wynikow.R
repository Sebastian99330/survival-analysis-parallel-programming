####
# Ten skrypt nie wchodzi w zakres dzia³ania programu wykonuj¹cego obliczenia, 
# jest jedynie skryptem pomocniczym, który s³u¿y do analizy wyników testów 
# np. liczenia œredniej, odchylenia standardowego itd.
####

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

# Usuniecie katalogu na output
unlink( "output//statystyki", recursive = TRUE)
# utworzenie katalogu na output
dir.create( "output//statystyki", showWarnings = FALSE)


# zapis do pliku podstawowej wersji ramki
write.csv(df_wyniki, "output//statystyki//pogrupowany-wynik-testow.csv", row.names = F, quote = F)



# dalej przerabiam dane zeby wrzucic je do tabeli latex
# nrow(df_wyniki)
# group_by(df_wyniki, input) %>% summarise(n = n())
# tail(df_wyniki,50)
# wyrzucam niepotrzebne fragmenty inputu, zeby nie zajmowac miejsca w tabelce w latex
df_wyniki$input <- gsub('-mln.csv','',df_wyniki$input) # zamiana w kazdym zbiorze np flchain-mln.csv na flchain
df_wyniki$input <- gsub('_mln.csv','',df_wyniki$input) # zamiana w kazdym zbiorze np flchain-mln.csv na flchain
df_wyniki$input <- gsub('turnover-mln-0-8.csv','turn1',df_wyniki$input) # zamiana turnover-mln-0-8.csv na turnover-1
df_wyniki$input <- gsub('turnover-mln-7.csv','turn2',df_wyniki$input) # zamiana turnover-mln-0-8.csv na turnover-2
df_wyniki$input <- gsub('turnover-edward','turn-edw',df_wyniki$input) # zamiana turnover-mln-7.csv na turnover-2
df_wyniki$input <- gsub('colorectal-cancer','colorec',df_wyniki$input) # zamiana colorectal-canver na colorec
df_wyniki$input <- gsub('prost_cancer_gen','pro_gen',df_wyniki$input) # zamiana prost_cancer_gen_mln na prost_cancer_gen
df_wyniki$input <- gsub('prostate_cancer','pro',df_wyniki$input) # zamiana prostate_cancer na pro
df_wyniki$input <- gsub('retinopatia','ret',df_wyniki$input) # zamiana prostate_cancer na pro
df_wyniki$input <- gsub('.csv','',df_wyniki$input) # zamiana dla zbiorow gdzie nie bylo -mln i _mln





#zamieniam kolejnosc kolumn
df_wyniki <- df_wyniki[c("input","wiersze","watki","testy","seq","par","par_better","risk","surv","lower","upper")]

# licze statystyki do pracy
min(df_wyniki$lower)
max(df_wyniki$lower)
mean(df_wyniki$lower)
sd(df_wyniki$lower)

min(df_wyniki$upper)
max(df_wyniki$upper)
mean(df_wyniki$upper)
sd(df_wyniki$upper)
df_testowa <- df_wyniki[df_wyniki$input != "flchain", ]
min(df_testowa$lower)
max(df_testowa$lower)
mean(df_testowa$lower)
sd(df_testowa$lower)

min(df_testowa$upper)
max(df_testowa$upper)
mean(df_testowa$upper)
sd(df_testowa$upper)

# teraz chce policzyæ przyspieszenie dla ka¿dej grupy
par_better_pogrupowane <- df_wyniki
par_better_pogrupowane$par_better <- gsub('x', '', par_better_pogrupowane$par_better)
par_better_pogrupowane$par_better <- as.numeric(par_better_pogrupowane$par_better)

nrow(par_better_pogrupowane)
head(par_better_pogrupowane)
par_better_pogrupowane <- par_better_pogrupowane[par_better_pogrupowane[,"watki"]>=7,]



par_better_pogrupowane <- par_better_pogrupowane %>% group_by(input) %>%
                            summarise(par_better = round(mean(par_better, na.rm=TRUE),2)
                                      ) %>%
                            data.frame()
  
print(xtable(par_better_pogrupowane, type = "latex", tabular.environment="longtable"), file = "output//statystyki//wyniki-kazdego-zbioru.tex", hline.after=1:nrow(par_better_pogrupowane), include.rownames=T)

range(par_better_pogrupowane$par_better)
mean(par_better_pogrupowane$par_better)
sd(par_better_pogrupowane$par_better)


# dziele dataframe na 4 czesci
df_wyniki1 <- df_wyniki[c(1:38),]
df_wyniki2 <- df_wyniki[c(39:75),]
df_wyniki3 <- df_wyniki[c(76:98),]
df_wyniki4 <- df_wyniki[c(99:114),]

library(xtable)
print(xtable(df_wyniki1, type = "latex", tabular.environment="longtable"), file = "output//statystyki//testy-latex-1.tex", hline.after=1:nrow(df_wyniki1), include.rownames=FALSE)
print(xtable(df_wyniki2, type = "latex", tabular.environment="longtable"), file = "output//statystyki//testy-latex-2.tex", hline.after=1:nrow(df_wyniki2), include.rownames=FALSE)
print(xtable(df_wyniki3, type = "latex", tabular.environment="longtable"), file = "output//statystyki//testy-latex-3.tex", hline.after=1:nrow(df_wyniki3), include.rownames=FALSE)
print(xtable(df_wyniki4, type = "latex", tabular.environment="longtable"), file = "output//statystyki//testy-latex-4.tex", hline.after=1:nrow(df_wyniki4), include.rownames=FALSE)

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
write.csv(df_calkowita_srednia, "output//statystyki//srednia-ze-wszystkich-testow.csv", row.names = F, quote = F)

