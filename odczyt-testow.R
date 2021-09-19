df <- read.table("statystyki.csv", sep = "," , header = T)
df <- df[,c(4,5,6,7,1,2,3)] #zamieniam kolejnosc kolumn
df
