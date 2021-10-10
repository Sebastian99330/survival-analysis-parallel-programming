import java.util.ArrayList;
import java.util.List;

public class ParallelAlgorithm implements Runnable {
    // argumenty dla algorytmu rownoleglego
    // nazwy plikow sa rozbite na czesci, ktore sklada metoda runScriptParallel().
    // trzeba podstaw nazwy np zbior_, numer iteracji np 2 oraz suffix czyli rozszerzenie np. .txt
    // co zlaczone poda pelna nazwe zbior_2.txt
    String input;
    String splitInput;
    String splitInputFileSuffix;
    String outputTxtFile;
    String txtSuffix;
    String kphPlotOutputPath;
    String cphPlotOutputPath;
    String imgSuffix;
    String outputFolderName;
    String rSeparator;
    String dfTxtFile;
    String splitFileSuffix;
    String timeStatus;
    String groupingVariablesCox;
    String savePlot;
    String [] parArgs; // trzeba zapisac array w tej klasie, bo musimy go podac jako argument w metodzie runScriptParallel

    int currentThreadNumber;
    int numberOfThreads;
    String threadCommand;

    public ParallelAlgorithm(int currentThreadNumber, int numberOfThreads, String threadCommand, String[] args) {
        this.currentThreadNumber = currentThreadNumber;
        this.numberOfThreads = numberOfThreads;
        this.threadCommand = threadCommand;
        this.parArgs = args;
        this.input = args[0];
        this.splitInput = args[1];
        this.splitInputFileSuffix = args[2];
        this.outputTxtFile = args[3];
        this.txtSuffix = args[4];
        this.kphPlotOutputPath = args[5];
        this.cphPlotOutputPath = args[6];
        this.imgSuffix = args[7];
        this.outputFolderName = args[8];
        this.rSeparator = args[9];
        this.dfTxtFile = args[10];
        this.splitFileSuffix = args[11];
        this.timeStatus = args[12];
        this.groupingVariablesCox = args[13];
        this.savePlot = args[14];
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
            String dfFullName = dfTxtFile + i + splitFileSuffix;

            String command = "rscript --vanilla script.R " + inputFullName + " " +
                    outputFullName + " " + KaplanMeierOutputPlotPath + " " + CoxPHOutputPlotPath + " " + outputFolderFullName + " " + rSeparator + " " +
                    dfFullName + " \"" + timeStatus + "\" \"" + groupingVariablesCox + "\" " + savePlot;


            Thread t = new Thread(new ParallelAlgorithm(i, numberOfThreads, command, parArgs));
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

    public void runOneParallelScript(){
        String command = "rscript --vanilla parallel.R " + input + " " + numberOfThreads + " \"" + timeStatus + "\" \"" + groupingVariablesCox + "\" ";
        TalkToR.runScript(command, true);
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
    public void writeGroupedOutputToFile(){
        String command = "rscript --vanilla odczyt-testow.R";
        TalkToR.runScript(command, true);
    }

    @Override
    public void run() {
        //System.out.println("Thread name (ParallelAlgorithm.run): " + Thread.currentThread().getName());
        //System.out.println("Thread " + currentThreadNumber + " out of " + numberOfThreads);
        TalkToR.runScript(threadCommand, true);
    }
}
