library(survival)
kidney
what <- data(cancer, package="survival")
cancer
nrow(cancer)
df <- lung
data(cancer, package="survival")

df <- read.csv("statystyki.csv", header = T)
head(df)
df$data <- '"27/09/2021 19:07:54"'
write.table(df, "statystyki2.csv", sep=',',quote=FALSE, row.names = F)
