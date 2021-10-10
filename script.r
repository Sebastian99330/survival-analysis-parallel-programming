args = commandArgs(trailingOnly=TRUE)
# args = array(c("split-data\\zbior_2.csv", "output_2.txt", "km_2.jpg", "cph_2.jpg", "output_2", ",", "ramka_2.csv", "time, status", "treatment + age + sh + size + index", "T")) # dla parallel
# args = array(c("split-data\\zbior_2.rds", "output_2.txt", "km_2.jpg", "cph_2.jpg", "output_2", ",", "ramka_2.rds", "exp, event", "branch + pipeline", "T")) # dla parallel
# args = array(c("turnover.csv", "output_seq.txt", "km_seq.jpg", "cph_seq.jpg", "output_seq", ",", "ramka_seq.rds", "exp, event", "branch + pipeline", "T")) # dla parallel
# args = array(c("input//gbsg-mln.csv", "output_seq.txt", "km_seq.jpg", "cph_seq.jpg", "output_seq", ",", "ramka_seq.rds", "rfstime, status", "age + meno + size + grade + nodes + pgr + er + hormon", "T"))
#args <- c("output//split-data//zbior_1.rds", "output//output_1.txt", "km_1.jpg", "cph_1.jpg", "output_1", ",", "ramka_1.rds", "\"exp, event\"", "\"branch + pipeline\"", "F")

if (length(args)==0) {
  stop("Sciezka do pliku wejsciowego jest wymagana.", call.=FALSE)
} else if (length(args)==1) {
  # drugi skrypt moze byc default
  args[2] = ".//output//output.txt"
  args[3] = ".//output//KM_plot.jpg"
  args[4] = ".//output//cph_plot.jpg"
  args[6] = ","
}

nazwa_folderu_output = args[5] # to jest nazwa outputu na konkretny model, np. output_seq dla wypisania modelu sekwencyjnego, albo output_1 dla czastkowego 1 zbioru

# wrzucenie nazw plikow w do foleru output
sciezka_do_input <- args[1]
output_txt = paste0(nazwa_folderu_output,"//",args[2])
KM_file_path = paste0(nazwa_folderu_output,"//",args[3])
CPH_file_path = paste0(nazwa_folderu_output,"//",args[4])
my_separator = args[6]
df_file <- args[7]
time_status <- args[8]
time_status <- noquote(time_status) # usuwam cudzyslowia ze zmiennej
# zmienne_grupowanie_km <- noquote(args[9]) # usuwam cudzyslowia ze zmiennej
zmienne_grupowanie_cox <- noquote(args[9]) 
czy_rysowac_wykres <- as.logical(args[10])


# wczytanie danych
# jak czytamy plik sekwencyjny, to inputem jest plik csv, a jak czastkowy, to rds
# dlatego tu sprawdzimy czy 3 ostatnie znaki inputu to csv i czy rds i wczytamy w odpowiedni sposob
suffix_inputu <- substr(sciezka_do_input, nchar(sciezka_do_input)-2, nchar(sciezka_do_input))
if(tolower(suffix_inputu) == "csv"){
  my_data <- read.table(sciezka_do_input, sep = my_separator , header = T)
} else if (tolower(suffix_inputu) == "rds"){
  my_data <- readRDS(sciezka_do_input)
}

library(survival)
# library(ggfortify) #funkcja autoplot

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

lokalizacja_output_ramki = paste0(".//",nazwa_folderu_output,"//",df_file)

saveRDS(tabelka_cox, lokalizacja_output_ramki)
