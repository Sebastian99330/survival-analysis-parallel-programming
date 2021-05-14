public class SequentialAlgorithm {

    // metoda "czysci" i przygotowuje przestrzen dla algorytmow
    // czyli usuwa foldery z wynikami poprzednich wykonan programu (jesli istnieja)
    // i tworzy nowe, puste foldery
    public static void clearWorkspace() {
        int numberOfThreads = 4;

        // tworzymy fodlery na output dla algorytmu sekwencyjnego
        String command = "Rscript --vanilla utworz-output.r output_seq";
        TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu

        // tworzymy foldery na output dla algorytmu odpalanego rownolegle
        for (int i = 1; i <= numberOfThreads; i++) {
            command = "Rscript --vanilla utworz-output.r output_" + i;
            TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu
        }

    }

    public static void runSequentialAlgorithm(String inputFileName, String outputTxtFile, String kmPath, String cphPath, String outputFolderName, String rSeparator) {
        // polecenie ktore odpalimy
        String command = "rscript --vanilla script.r " + inputFileName + " " +
                outputTxtFile + " " + kmPath + " " + cphPath + " " + outputFolderName + " " + rSeparator;
        TalkToR.runScript(command, true);
    }

}
