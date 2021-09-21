# args = commandArgs(trailingOnly=TRUE)
# trzeba w wierszu ponizej, w funkcji c dac cudzyslowia miedzy elementami i przecinki miedzy nimi
args = array(c("Split-data\\zbior_2.csv", "output_2.txt", "km_2.jpg", "cph_2.jpg", "output_2", ",", "ramka_2.csv", "time, status", "treatment + age + sh + size + index")) # dla parallel


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

# wrzucenie nazw plikow w do foleru output
sciezka_do_input <- args[1]
output_txt = paste0(".//",nazwa_folderu_output,"//",args[2])
KM_file_path = paste0(".//",nazwa_folderu_output,"//",args[3])
CPH_file_path = paste0(".//",nazwa_folderu_output,"//",args[4])
my_separator = args[6]
df_file <- args[7]
time_status <- args[8]
time_status <- noquote(time_status) # usuwam cudzyslowia ze zmiennej
zmienne_grupowanie <- noquote(args[9]) # usuwam cudzyslowia ze zmiennej



# wczytanie danych
my_data <- read.table(sciezka_do_input, sep = my_separator , header = T)
# my_data <- read.table(args[1], sep = "" , header = T)

start.time <- Sys.time()


# zapis danych do pliku - nie jest potrzebny poki co
# write.table(data, file = output_txt, sep = " ", row.names = TRUE)


library(survival)
library(ggfortify) #plot

# Kaplan Meier plot
# wszystko to co ponizej robimy po to, zeby sparametryzowac wywolanie funkcji, ktora buduje model coxa
# potrzebujemy miec instrukcje, w ktorej podajemy zmienne po ktorej grupujemy jako parametr, ale po prostu podanie zmiennej
# w miejscu zmiennych grupujacych rzuca blad 
# interpreter wtedy nie patrzy co mamy zapisane w zmiennej zmienne_grupowanie, tylko probuje od razu po niej grupowac dane wejsciowe
# tworze jedna instrukcje wsadzajac za parametr zmienne, po ktorych grupujemy (one zostaly podane jako argument odpalenia tego skryptu)
instrukcja <- sprintf("survfit(Surv(%s) ~ %s, data = my_data)", time_status, zmienne_grupowanie)

mykm <- survfit(Surv(exp, event) ~ branch, data = my_data)

# za pomoca eval(parse(...) uruchamiamy instrukcje, ktora jest zapisana w zmiennej
mykm <- eval(parse(text=instrukcja))


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
#cox <- coxph(Surv(time, status) ~ treatment + age + sh + size + index, data = my_data) # przed zmiana
# tworze jedna instrukcje wsadzajac za parametr zmienne, po ktorych grupujemy (one zostaly podane jako argument odpalenia tego skryptu)
instrukcja <- sprintf("coxph(Surv(time, status) ~ %s, data = my_data)", zmienne_grupowanie)
# za pomoca eval(parse(...) uruchamiamy instrukcje, ktora jest zapisana w zmiennej
cox <- eval(parse(text=instrukcja))


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
