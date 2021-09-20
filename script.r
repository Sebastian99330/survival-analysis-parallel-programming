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
  args[3] = ".//output//KM_plot.jpg"
  args[4] = ".//output//cph_plot.jpg"
  args[6] = ","
}

nazwa_folderu_output = args[5]

# wrzucenie nazw plik�w do foleru output
output_txt = paste0(".//",nazwa_folderu_output,"//",args[2])
KM_file_path = paste0(".//",nazwa_folderu_output,"//",args[3])
CPH_file_path = paste0(".//",nazwa_folderu_output,"//",args[4])
my_separator = args[6]
df_file <- args[7]

# wczytanie danych
my_data <- read.table(args[1], sep = my_separator , header = T)
# my_data <- read.table(args[1], sep = "" , header = T)

start.time <- Sys.time()


# zapis danych do pliku - nie jest potrzebny poki co
# write.table(data, file = output_txt, sep = " ", row.names = TRUE)


library(survival)
library(ggfortify) #plot

# Kaplan Meier plot
# grupuje po treatment
mykm <- survfit(Surv(time, status) ~ treatment, data = my_data)

# otwarcie pliku do ktorego rysujemy wykres KM
jpeg(KM_file_path, width = 1698, height = 754)

# Wykres zawiera dwie linie, po jednej dla kazdej wartosci zmiennej "treatment" czyli 1 i 2
# Sa takze zaznaczone przedzialy ufnosci wokol kazdej linii
autoplot(mykm)

# zamkniecie pliku do ktoego rysujemy wykres
dev.off()




# Log-rank test
#survdiff(Surv(my_data$time, my_data$status) ~ my_data$treatment)

# Cox Proportional Hazards Model
cox <- coxph(Surv(time, status) ~ treatment + age + sh+ size + index, data = my_data)


# wypisanie statystyk - nie potrzebujemy tego, bo to wypisuje wspolczynniki,
# a nas interesuja dokladne momenty w czasie (po nich bedziemy laczyc)
# print("Summary(cox)")
# summary(cox)

# wypisanie tabelki z obliczonymi wartosciami dla konkretnych momentow w czasie
# summary(survfit(cox))
# tabelka <- data.frame(summary(survfit(cox)))
# write.csv(tabelka, "ramka.csv", row.names = F)



# otwarcie pliku do ktoego rysujemy wykres z regresji coxa
jpeg(CPH_file_path, width = 1698, height = 754)

# funkcja autoplot() nie przyjmuje bezposrednio obiektu cox
# czyli obiektu, ktory zwraca funkcja coxph,
# wiec trzeba go wpakowac po drodze w funkcje survfit()
autoplot(survfit(cox))



end.time <- Sys.time()
time.taken <- as.numeric(end.time - start.time)
time.taken <- format(round(time.taken, 2), nsmall = 2) # formatowanie do dwoch miejsc po przecinku

# zapisze do pliku dane tekstowe - statystyki z log-rank oraz z regresji coxa
# ustawiam plik do ktoego bedziemy pisac
sink(output_txt)
print(paste0("Wykonywanie skryptu generujacego wykres KM, obliczajacego test log-rank oraz przetwarzajacy model regresji coxa: ",time.taken, " sekund(y)"))
print(paste0("Start wykonania skryptu: ",start.time))
print(paste0("Koniec wykonania skryptu: ",end.time))

#zamkniecie pliku output
sink()





# zapisanie samej ramki i nadanie innych nazw kolumn

# wypisanie tabelki z obliczonymi wartosciami dla konkretnych momentow w czasie
# tabelka <- 

podsumowanie_cox <- summary(survfit(cox)) 
# obiekt 'wyniki' ma teraz duzo niepotrzebnych wartosci, dlatego wyciagniemy tylko to co potrzebujemy
# czyli kolumny tworzace tabelke ktora laczymy
tabelka_cox <- as.data.frame(podsumowanie_cox[c("time", "n.risk", "n.event", "surv")])
colnames(tabelka_cox) <- c("time", "n_risk", "n_event", "survival")

lokalizacja_output_ramki = paste0(".//",nazwa_folderu_output,"//",df_file)
write.csv(tabelka_cox, lokalizacja_output_ramki, row.names = F)
