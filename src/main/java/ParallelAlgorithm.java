import java.util.ArrayList;
import java.util.List;

public class ParallelAlgorithm implements Runnable {
    // argumenty dla algorytmu rownoleglego
    // nazwy plikow sa rozbite na czesci, ktore sklada metoda runScriptParallel().
    // trzeba podstaw nazwy np zbior_, numer iteracji np 2 oraz suffix czyli rozszerzenie np. .txt
    // co zlaczone poda pelna nazwe zbior_2.txt
    String input = "turnover.csv";
//    String input = "prostate_cancer.csv";
//    String input = "prost_cancer_mln.csv";
    String splitInput = "Split-data\\\\zbior_";
//    String splitInputFileSuffix = ".csv";
    String splitInputFileSuffix = ".rds";
    String outputTxtFile = "output_";
    String txtSuffix = ".txt";
    String kphPlotOutputPath = "km_";
    String cphPlotOutputPath = "cph_";
    String imgSuffix = ".jpg";
    String outputFolderName = "output_";
    String rSeparator = ","; // separator dla wszystkich plikow z podzielonymi danymi wejsciowymi to przecinek ","
    String dfTxtFile = "ramka_";
    String csvSuffix = ".csv";
    String rdsSuffix = ".rds";
//    String timeStatus = "time, status"; // dla input prostate cancer
//    String groupingVariablesKm = "treatment"; // dla input prostate cancer
//    String groupingVariablesCox = "treatment + age + sh + size + index"; // dla input prostate cancer
    String timeStatus = "exp, event"; // dla input work
    String groupingVariablesKm = "branch"; // dla input work
    String groupingVariablesCox = "branch + pipeline"; // dla input work


    int currentThreadNumber;
    int numberOfThreads;
    String threadCommand;


    public ParallelAlgorithm(int currentThreadNumber, int numberOfThreads, String threadCommand) {
        this.currentThreadNumber = currentThreadNumber;
        this.numberOfThreads = numberOfThreads;
        this.threadCommand = threadCommand;
    }


    // metoda odpala skrypt ktory dzieli plik z danymi wejsciowymi na odpowiednia ilosc czesci
    // (tworzy kilka plikow z czesciami danych) zeby moc je potem rownolegle obliczyc
    public void splitInputData() {
        String command = "rscript --vanilla dzielenie-zbioru-seq.R " + input + " " + numberOfThreads + " " + splitInput;
        TalkToR.runScript(command, true);
    }

    // metoda wywoluje odpalenie algorytmu analizy przezycia dla kazdego pliku z podzielonymi danymi wejsciowymi
    public void runScriptParallel() {
        /* Jak mamy np. 4 watki, to podzielilismy dane wejsciowe na 4 czesci i kazda czesc zapisalismy do pliku
         * teraz lecimy w petli i odpalamy algorytm analizy przezycia dla kazdej czesci
         * petla jest numerowana od 1, bo R tak numeruje swoje iteracje (1 jest pierwsze a nie 0)
         * i pliki z czesciami danych zaczynaja sie od 1
         */
        List<Thread> threads = new ArrayList<>();

        for (int i = 1; i <= numberOfThreads; i++) {
            String inputFullName = splitInput + i + splitInputFileSuffix;
            String outputFullName = outputTxtFile + i + txtSuffix;
            String KaplanMeierOutputPlotPath = kphPlotOutputPath + i + imgSuffix;
            String CoxPHOutputPlotPath = cphPlotOutputPath + i + imgSuffix;
            String outputFolderFullName = outputFolderName + i;
            String dfFullName = dfTxtFile + i + rdsSuffix;

            String command = "rscript --vanilla script.r " + inputFullName + " " +
                    outputFullName + " " + KaplanMeierOutputPlotPath + " " + CoxPHOutputPlotPath + " " + outputFolderFullName + " " + rSeparator + " " +
                    dfFullName + " " + timeStatus + " " + groupingVariablesKm + " " + groupingVariablesCox;


            Thread t = new Thread(new ParallelAlgorithm(i, numberOfThreads, command));
            t.start();
            threads.add(t);
        }

        for (Thread tt : threads) {
            try {
                tt.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

    }

    /**
     * Metoda odpala skrypt R, ktory laczy wyniki skryptu R
     * Wczesniej podzielilismy zbior danych wejsciowych, wykonalismy obliczenia analizy przezycia i zbudowalismy modele
     * dla oddzielnych zbiorow i w tej metodzie je z powrotem laczymy do jednego wynikowego modelu
     */
    public void mergePartialOutputs(){
        // komenda R, ktora odpala skrypt laczenie.R, ktory laczy wyniki skryptu script.R
         String command = "rscript --vanilla laczenie.R " + numberOfThreads;
//        String command = "rscript --vanilla sciezka.R";
        TalkToR.runScript(command, true);
    }

    /**
     * Metoda bierze statystyki ktore wyliczyl program, liczy srednia i wypisuje do pliku.
     */
    public static void writeGroupedOutputToFile(){
        String command = "rscript --vanilla odczyt-testow.R";
        TalkToR.runScript(command, false);
    }

    @Override
    public void run() {
        System.out.println("Thread name (ParallelAlgorithm.run): " + Thread.currentThread().getName());
        System.out.println("Thread " + currentThreadNumber + " out of " + numberOfThreads);
        TalkToR.runScript(threadCommand, false);

    }
}
