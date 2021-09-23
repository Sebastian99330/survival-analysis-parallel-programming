args = commandArgs(trailingOnly=TRUE)
# args = array(c("Split-data\\zbior_2.csv", "output_2.txt", "km_2.jpg", "cph_2.jpg", "output_2", ",", "ramka_2.csv", "time, status", "treatment", "treatment + age + sh + size + index")) # dla parallel
# args = array(c("Split-data\\zbior_2.rds", "output_2.txt", "km_2.jpg", "cph_2.jpg", "output_2", ",", "ramka_2.rds", "exp, event", "branch", "branch + pipeline")) # dla parallel
# args = array(c("turnover.csv", "output_seq.txt", "km_seq.jpg", "cph_seq.jpg", "output_seq", ",", "ramka_seq.rds", "exp, event", "branch", "branch + pipeline")) # dla parallel


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
zmienne_grupowanie_km <- noquote(args[9]) # usuwam cudzyslowia ze zmiennej
zmienne_grupowanie_cox <- noquote(args[10]) 


# wczytanie danych
# jak czytamy plik sekwencyjny, to inputem jest plik csv, a jak czastkowy, to rds
# dlatego tu sprawdzimy czy 3 ostatnie znaki inputu to csv i czy rds i wczytamy w odpowiedni sposob
suffix_inputu <- substr(sciezka_do_input, nchar(sciezka_do_input)-2, nchar(sciezka_do_input))
if(tolower(suffix_inputu) == "csv"){
  my_data <- read.table(sciezka_do_input, sep = my_separator , header = T)
} else if (tolower(suffix_inputu) == "rds"){
  my_data <- readRDS(sciezka_do_input)
}

# zakomentowuje, bo czas mierzymy w javie
# start.time <- Sys.time()


# zapis danych do pliku - nie jest potrzebny poki co
# write.table(data, file = output_txt, sep = " ", row.names = TRUE)


library(survival)
# library(ggfortify) #plot KM

# poki co zakomentowujemy KM bo nie budujemy tego modelu bo model Coxa jest lepszy
# Kaplan Meier plot
# wszystko to co ponizej robimy po to, zeby sparametryzowac wywolanie funkcji, ktora buduje model coxa
# potrzebujemy miec instrukcje, w ktorej podajemy zmienne po ktorej grupujemy jako parametr, ale po prostu podanie zmiennej
# w miejscu zmiennych grupujacych rzuca blad 
# interpreter wtedy nie patrzy co mamy zapisane w zmiennej zmienne_grupowanie, tylko probuje od razu po niej grupowac dane wejsciowe
# tworze jedna instrukcje wsadzajac za parametr zmienne, po ktorych grupujemy (one zostaly podane jako argument odpalenia tego skryptu)
# instrukcja <- sprintf("survfit(Surv(%s) ~ %s, data = my_data)", time_status, zmienne_grupowanie_km)
# za pomoca eval(parse(...) uruchamiamy instrukcje, ktora jest zapisana w zmiennej
# mykm <- eval(parse(text=instrukcja))


# otwarcie pliku do ktorego rysujemy wykres KM
# jpeg(KM_file_path, width = 1698, height = 754)

# Wykres zawiera dwie linie, po jednej dla kazdej wartosci zmiennej "treatment" czyli 1 i 2
# Sa takze zaznaczone przedzialy ufnosci wokol kazdej linii
# autoplot(mykm)

# zamkniecie pliku do ktoego rysujemy wykres
# dev.off()




# Log-rank test
#survdiff(Surv(my_data$time, my_data$status) ~ my_data$treatment)

# Cox Proportional Hazards Model
#cox <- coxph(Surv(time, status) ~ treatment + age + sh + size + index, data = my_data) # przed zmiana
# tworze jedna instrukcje wsadzajac za parametr zmienne, po ktorych grupujemy (one zostaly podane jako argument odpalenia tego skryptu)
instrukcja <- sprintf("coxph(Surv(%s) ~ %s, data = my_data)", time_status, zmienne_grupowanie_cox)
# za pomoca eval(parse(...) uruchamiamy instrukcje, ktora jest zapisana w zmiennej
cox <- eval(parse(text=instrukcja))

podsumowanie_cox <- summary(survfit(cox)) 
# obiekt 'podsumowanie_cox' ma teraz duzo niepotrzebnych wartosci, dlatego wyciagniemy tylko to co potrzebujemy
# czyli kolumny tworzace tabelke ktora laczymy
tabelka_cox <- as.data.frame(podsumowanie_cox[c("time", "n.risk", "n.event", "surv","lower","upper")])
# zamieniamy . na _ zeby sie nie mylilo z separatorem liczb potem
colnames(tabelka_cox) <- c("time", "n_risk", "n_event", "survival","lower","upper")



# wypisanie statystyk - nie potrzebujemy tego, bo to wypisuje wspolczynniki,
# a nas interesuja dokladne momenty w czasie (po nich bedziemy laczyc)
# print("Summary(cox)")
# summary(cox)

# wypisanie tabelki z obliczonymi wartosciami dla konkretnych momentow w czasie
# summary(survfit(cox))
# tabelka <- data.frame(summary(survfit(cox)))
# write.csv(tabelka, "ramka.csv", row.names = F)


library(ggplot2)
library(utile.visuals)

# otwarcie pliku do ktoego rysujemy wykres z regresji coxa
jpeg(CPH_file_path, width = 1698, height = 754)


ggplot2::ggplot(tabelka_cox, aes(time,survival)) +
  ggplot2::geom_step() +
  utile.visuals::geom_stepconfint(aes(ymin = lower, ymax = upper), alpha = 0.3)
  

dev.off()


# funkcja autoplot() nie przyjmuje bezposrednio obiektu cox
# czyli obiektu, ktory zwraca funkcja coxph,
# wiec trzeba go wpakowac po drodze w funkcje survfit()
#autoplot(survfit(cox)) # nie rysujemy automatycznie tylko sami, zeby rysowac w taki sam sposob jak po polaczeniu ramek potem


# end.time <- Sys.time()
# time.taken <- as.numeric(end.time - start.time)
# time.taken <- format(round(time.taken, 2), nsmall = 2) # formatowanie do dwoch miejsc po przecinku

# zapisze do pliku dane tekstowe - statystyki z log-rank oraz z regresji coxa
# ustawiam plik do ktoego bedziemy pisac
# sink(output_txt)
# print(paste0("Wykonywanie skryptu generujacego wykres KM, obliczajacego test log-rank oraz przetwarzajacy model regresji coxa: ",time.taken, " sekund(y)"))
# print(paste0("Start wykonania skryptu: ",start.time))
# print(paste0("Koniec wykonania skryptu: ",end.time))
# 
# #zamkniecie pliku output
# sink()
# 
# 


lokalizacja_output_ramki = paste0(".//",nazwa_folderu_output,"//",df_file)

# zapis outputu do pliku
# jak obliczalismy plik sekwencyjny, to output jest juz 'ostateczny' i ma byc zapisany do pliku csv
# jak obliczalismy rownolegle, to output z tego jest jedynie przejsciowy i zapisujemy to rds
# dlatego tu sprawdzimy czy 3 ostatnie znaki inputu to csv i czy rds i zapiszemy w odpowiedni sposob
# if(tolower(suffix_inputu) == "csv"){
#   write.csv(tabelka_cox, lokalizacja_output_ramki, row.names = F)
# } else if (tolower(suffix_inputu) == "rds"){
#   saveRDS(tabelka_cox, lokalizacja_output_ramki)
# }
saveRDS(tabelka_cox, lokalizacja_output_ramki)
