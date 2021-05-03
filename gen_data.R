iterations = 1000000
variables = 8

output <- matrix(ncol=variables, nrow=iterations)

old <- Sys.time() # get start time
print(old)


for(i in 1:iterations){

  # ID podmiotu
  output[i,1] <- id <- c(i)
  
  # grupa - 1 albo 2
  output[i,2] <- group <- sample(c(1,2), size = 1)
  
  # czas, np. w miesiacach
  output[i,3] <- time <- floor(runif(1, min=0, max=101))
  
  # status - bylo zdarzenie czy nie
  output[i,4] <- status <- sample(c(0,1), size = 1)
  
  # losowanie wieku miedzy 10 a 99 rokiem zycia
  output[i,5] <- age <- floor(runif(1, 10, 100))
  
  
  # sh - hormon powiazany z chorowaniem na raka
  # zawiera wartosci dziesietne np. 12.5, 13.2, 16.1 itp.
  sh <- runif(1, 10.1, 20.9)
  # doprowadzenie wieku do postaci jednego miejsca po przecinku np. 29.5
  output[i,6] <- sh <- (floor(sh*10))/10
  
  
  # rozmiar guza raka w calach
  output[i,7] <- size <- floor(runif(1, 2, 40))
  
  # indeks w Skali Gleasona 
  output[i,8] <- index <- floor(runif(1, 2, 10))
}


output <- data.frame(output)
class(output)
colnames(output) <- c("patient", "treatment", "time", "status", "age", "sh", "size", "index")
head(output)

new <- Sys.time() # get start time
print(new)

differ <- (new - old)
print(differ)

# row names ma byc false, bo inaczej dokleja kolumne na poczatku
write.table(output, file = "prost_cancer_mln.csv", sep = " ", row.names = FALSE)
