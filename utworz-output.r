args = commandArgs(trailingOnly = TRUE)

if (length(args)==0) {
  stop("Nazwa katalogu jest wymagana.", call.=FALSE)
} 

sciezka_output = args[1]

# Usuniecie katalogu na output jesli istnieje
unlink(sciezka_output, recursive = TRUE)

# utworzenie katalogu na nowe pliki z danymi wejsciowymi
dir.create(file.path(sciezka_output), showWarnings = FALSE)
