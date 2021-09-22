# funkcja, ktora rysuje wykres modelu coxa z polaczonych danych czastkowych
narysuj_graf <- function(df) {
  x <- seq(-pi,pi,0.1)
  
  # Usuniecie katalogu na output jesli istnieje
  unlink(".//output_polaczone", recursive = TRUE)
  
  # utworzenie katalogu na nowe pliki z danymi wejsciowymi
  dir.create(file.path(".//output_polaczone"), showWarnings = FALSE)
  
  png(filename=".//output_polaczone/cph_merged.png")
  plot(x, sin(x))
  dev.off()
}
