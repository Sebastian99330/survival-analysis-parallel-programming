library(survival)
kidney
what <- data(cancer, package="survival")
cancer
nrow(cancer)
df <- lung
data(cancer, package="survival")

df <- read.csv("statystyki.csv", header = T)
head(df)
df$n_risk <- as.numeric(df$n_risk)
df <- df[,c("n_risk","n_survival_na_to_wiersz_ponizej","lower","upper","liczba_wierszy","liczba_watkow","czas_seq","czas_par","par_lepsze_niz_seq","nazwa_inputu","data")]

write.table(df, "statystyki2.csv", sep=',', row.names = F)

