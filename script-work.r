args = commandArgs(trailingOnly=TRUE)
# args <- array(c("Split-data\\zbior_2.csv","output_2.txt","km_2.jpg","cph_2.jpg","output_2",",")) # jak bym sam uruchamial w rstudio

if (length(args)==0) {
  stop("Sciezka do pliku wejsciowego jest wymagana.", call.=FALSE)
} else if (length(args)==1) { # DOMYSLNE WARTOSCI
  # drugi skrypt moze byc default
  args[2] = ".//output//output.txt"
  args[3] = ".//output//KM_plot.jpg"
  args[4] = ".//output//cph_plot.jpg"
  args[6] = ","
}

nazwa_folderu_output = args[5]

# wrzucenie nazw plikow do foleru output
output_txt = paste0(".//",nazwa_folderu_output,"//",args[2])
KM_file_path = paste0(".//",nazwa_folderu_output,"//",args[3])
CPH_file_path = paste0(".//",nazwa_folderu_output,"//",args[4])
my_separator = args[6]

# wczytanie danych
my_data <- read.table(args[1], sep = my_separator , header = T)
start.time <- Sys.time()


# zapis danych do pliku - nie jest potrzebny poki co
# write.table(data, file = output_txt, sep = " ", row.names = TRUE)


library(survival)
library(ggfortify) #plot

# Kaplan Meier plot
# grupuje po treatment
# mykm <- survfit(Surv(exp, event) ~ branch + pipeline, data = my_data)
mykm <- survfit(Surv(exp, event) ~ branch, data = my_data)

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
# cox <- coxph(Surv(exp, event) ~ branch + pipeline, data = my_data)
# cox <- coxph(Surv(exp, event) ~ 1, data = my_data)
cox <- coxph(Surv(exp, event) ~ branch + pipeline, data = my_data)

# wypisanie statystyk - nie potrzebujemy tego, bo to wypisuje wspolczynniki,
# a nas interesuja dokladne momenty w czasie (po nich bedziemy laczyc)
# summary(cox)


# otworzenie pliku do ktorego rysujemy wykres z regresji coxa
jpeg(CPH_file_path, width = 1698, height = 754)

# funkcja autoplot() nie przyjmuje bezposrednio obiektu cox
# czyli obiektu, ktory zwraca funkcja coxph,
# wiec trzeba go wpakowac po drodze w funkcje survfit()
autoplot(survfit(cox))


end.time <- Sys.time()
time.taken <- as.numeric(end.time - start.time)
time.taken <- format(round(time.taken, 2), nsmall = 2) # formatowanie do dwoch miejsc po przecinku

# zapisze do pliku dane tekstowe
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
# zeby nie robic kolejnego parametru, wyciagamy na nr zbioru z nazwy folderu na outputu
library(stringr)
nr_zbioru <- str_sub(nazwa_folderu_output,nchar(nazwa_folderu_output),nchar(nazwa_folderu_output))
lokalizacja_output_ramki = paste0(".//",nazwa_folderu_output,"//ramka_",nr_zbioru,".csv")
write.csv(tabelka_cox, lokalizacja_output_ramki, row.names = F)
