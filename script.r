args = commandArgs(trailingOnly=TRUE)

# ten skrypt przyjmuje dwa argumenty:
# 1 sciezka do pliku z danymi wejsciowymi oraz
# 2 sciezka do pliku na dane wyjsciowe
# Jak przy wywolaniu skryptu nie podano pierwszego argumentu to rzucamy blad
if (length(args)==0) {
  stop("Sciezka do pliku wejsciowego jest wymagana.", call.=FALSE)
} else if (length(args)==1) {
  # drugi skrypt moze byc default
  args[2] = ".//output//output.txt"
}

# wczytanie danych
my_data <- read.table(args[1], sep = "" , header = T)

start.time <- Sys.time()

# Usuniecie katalogu na output jesli istnieje
unlink("output", recursive = TRUE)

# utworzenie katalogu na nowe pliki z danymi wejsciowymi
dir.create(file.path("output"), showWarnings = FALSE)


# zapis danych do pliku - nie jest potrzebny poki co
# write.table(data, file = args[2], sep = " ", row.names = TRUE)


library(survival)
library(ggfortify) #plot

# Kaplan Meier plot
# grupuje po treatment
mykm <- survfit(Surv(time, status) ~ treatment, data = my_data)

# otwarcie pliku do ktorego rysujemy wykres KM
jpeg(".//output//KM_plot.jpg", width = 1698, height = 754)

# Wykres zawiera dwie linie, po jednej dla kazdej wartosci zmiennej "treatment" czyli 1 i 2
# Sa takze zaznaczone przedzialy ufnosci wokol kazdej linii
autoplot(mykm)

# zamkniecie pliku do ktoego rysujemy wykres
dev.off()


# zapisze do pliku dane tekstowe - statystyki z log-rank oraz z regresji coxa
# ustawiam plik do ktoego bedziemy pisac
sink(args[2])


# Log-rank test
survdiff(Surv(my_data$time, my_data$status) ~ my_data$treatment)

# Cox Proportional Hazards Model
cox <- coxph(Surv(time, status) ~ treatment + age + sh+ size + index, data = my_data)

# wypisanie statystyk
summary(cox)


# otwarcie pliku do ktoego rysujemy wykres z regresji coxa
jpeg(".//output//cph_plot.jpg", width = 1698, height = 754)

# funkcja autoplot() nie przyjmuje bezposrednio obiektu cox
# czyli obiektu, ktory zwraca funkcja coxph,
# wiec trzeba go wpakowac po drodze w funkcje survfit()
autoplot(survfit(cox))



end.time <- Sys.time()
time.taken <- as.numeric(end.time - start.time)
time.taken <- format(round(time.taken, 2), nsmall = 2) # formatowanie do dwoch miejsc po przecinku
cat("\n\n")
print(paste0("Dzielenie zbioru danych wejsciowych zajelo: ",time.taken, " sekund(y)"))
print(paste0("Start wykonania skryptu: ",start.time))
print(paste0("Koniec wykonania skryptu: ",end.time))

#zamkniecie pliku output
sink()