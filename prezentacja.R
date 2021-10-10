args <- commandArgs(trailingOnly=TRUE)
# args <- c("output_polaczone/survival.rds", "output_polaczone/cox_polaczony.jpg", "output_polaczone/ramka-polaczona.csv",
          # "survival" )

# ten skrypt wczytuje ramke z polaczenia czastkowych modeli, rysuje wykres funkcji przezycia i zapisuje go do pliku,


input <- args[1]
output_jpg_path <- args[2]
output_csv <- args[3]
kolumna_survival <- args[4]

library(dplyr)
library(ggplot2)
library(utile.visuals)

df <- readRDS(input)

# narysujemy wykres funkcji survival uzywajac wartosci z tabeli

# teraz bede rysowal wykres, ale musze podac kolumne survival (os Y na wykresie), a ona moze miec rozne nazwy w ramkach
# dlatego jest podana jako parametr w tym skrypcie i ponizej tworze instrukcje, w ktorej podam ta kolumne
# nie moge bezposrednio wpisac "nazwa_kolumny" w miejscu instrukcji bo R by powiedzialo ze nie ma takiej kolumny jak "nazwa_kolumny"
# czyli spojrzalo by tylko na nazwe zmiennej, a nie na jej wartosc (prawdziwa nazwe kolumny podana w argumencie)
instrukcja <- sprintf("ggplot2::ggplot(df, aes(time,%s)) + \n", kolumna_survival)
instrukcja <- paste0(instrukcja, "ggplot2::geom_step() + \n",
                     "utile.visuals::geom_stepconfint(aes(ymin = lower, ymax = upper), alpha = 0.3) + \n",
                     "labs(title = \"Survival function\", x = \"time\", y = \"survival\")")
# za pomoca eval(parse(...) uruchamiamy instrukcje, ktora jest zapisana w zmiennej
p <- eval(parse(text=instrukcja))

ggsave(filename = output_jpg_path, plot=p)

write.csv(df, file = output_csv)


