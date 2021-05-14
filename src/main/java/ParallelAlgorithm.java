import java.time.Duration;
import java.time.Instant;

public class ParallelAlgorithm implements Runnable {
    String input;
    String splitOutputFilePath = "output";
    String splitOutputFilePathSuffix = ".txt";
    //    String splitInputFilePath = "Split-data\\zbior_";
    String splitInputFilePath = "zbior_";
    String splitInputFilePathSuffix = ".csv";
    String cphPlotOutputPath = "cph";
    String kphPlotOutputPath = "km";
    String plotSuffix = ".jpg";

    int numerOfThreads = 4;

    public ParallelAlgorithm(String input) {
        this.input = input;
    }

    // metoda odpala skrypt ktory dzieli plik z danymi wejsciowymi na odpowiednia ilosc czesci
    // zeby moc je potem rownolegle obliczyc
    public void splitInputData(String inputFilePath) {
        String command = "rscript --vanilla dzielenie-zbioru.R " + inputFilePath;
        TalkToR.runScript(command, true);
    }

    // metoda wywoluje odpalenie algorytmu analizy przezycia dla kazdego pliku z podzielonymi danymi wejsciowymi
    public void runParallelAlgorithm(String inputFileName, String outputFileName) {
        // separator dla wszystkich plikow z podzielonymi danymi wejsciowymi to przecinek ","
        String rSeparator = "\",\"";

        /* Jak mamy np. 4 watki, to podzielilismy dane wejsciowe na 4 czesci i kazda czesc zapisalismy do pliku
         * teraz lecimy w petli i odpalamy algorytm analizy przezycia dla kazdej czesci
         * w tym momencie odpalamy algorytm "sekwencyjnie", tzn. zrownoleglimy to ale pojedyncze uruchomienie algorytmu
         * jest odpalane jakby "sekwencyjnie".
         * petla jest numerowana od 1, bo R tak numeruje swoje iteracje (1 jest pierwsze a nie 0)
         * i pliki z czesciami danych zaczynaja sie od 1
         */
        for (int i = 1; i <= numerOfThreads; i++) {
            String input = "Split-data\\\\" + splitInputFilePath + i + splitInputFilePathSuffix;
            String outputPath = splitOutputFilePath + i + splitOutputFilePathSuffix;
            String KaplanMeierOutputPlotPath = kphPlotOutputPath + i + plotSuffix;
            String CoxPHOutputPlotPath = cphPlotOutputPath + i + plotSuffix;
            String outputFolderName = "output_" + i;

            SequentialAlgorithm.runSequentialAlgorithm(input, outputPath, KaplanMeierOutputPlotPath,
                    CoxPHOutputPlotPath, outputFolderName, rSeparator);
        }

    }

    @Override
    public void run() {
        System.out.println("Thread name (ParallelAlgorithm.run): " + Thread.currentThread().getName());
    }
}
