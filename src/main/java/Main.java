import com.google.common.base.Stopwatch;;
import java.util.concurrent.TimeUnit;

public class Main {
    public static void main(String[] args) {
        String[] newArgs = new String[5];
        if(args.length != 5){
            newArgs[0] = "turnover.csv"; // input file name
            newArgs[1] = "\"exp, event\""; // variables: time, status // exp, event / time, status
            newArgs[2] = "branch";     // treatment / branch
            newArgs[3] = "\"branch + pipeline\""; // treatment + age + sh + size + index / branch + pipeline
            newArgs[4] = "3";  // number of threads
        }
        else {
            newArgs[0] = args[0];
            newArgs[1] = args[1];
            newArgs[2] = args[2];
            newArgs[3] = args[3];
            newArgs[4] = args[4];
        }

        String inputFileName = newArgs[0];
        String timeStatus = newArgs[1];
        String groupingKM = newArgs[2];
        String groupingCPH = newArgs[3];

        final Integer numberOfThreads = Integer.parseInt(newArgs[4]);
        final int numberOfFirstThread = 1;
        String argsSeq [] = {inputFileName,"output-seq.txt","km_seq.jpg","cph_seq.jpg","output_seq",
                ",","ramka_seq.rds",timeStatus,groupingKM,groupingCPH};

        String argsPar [] = {inputFileName,"Split-data\\\\zbior_",".rds","output_",".txt","km_","cph_",".jpg",
                "output_", ",","ramka_",".rds", timeStatus,groupingKM,groupingCPH};

        TalkToR.clearWorkspace(numberOfThreads); // tworzy puste foldery na output (i ewentualnie usuwa istniejace)

        // sekwencyjnie
        Stopwatch timeSeq = Stopwatch.createStarted(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda sekwencyjna
        SequentialAlgorithm sequentialAlgorithm = new SequentialAlgorithm(argsSeq);
        sequentialAlgorithm.callRScript();
        timeSeq.stop();

        //rownolegle
        Stopwatch timeParallel = Stopwatch.createStarted(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda rownolegla
        System.out.println("1 Przed ParallelAlgorithm parallelAlgorithm");
        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(numberOfFirstThread, numberOfThreads, null, argsPar);
        System.out.println("2 Po ParallelAlgorithm parallelAlgorithm");


        parallelAlgorithm.splitInputData();
        System.out.println("3 Po parallelAlgorithm.splitInputData();");

        parallelAlgorithm.runScriptParallel();
        System.out.println("4 Po parallelAlgorithm.runScriptParallel();");


        parallelAlgorithm.mergePartialOutputs();
        System.out.println("5 Po parallelAlgorithm.mergePartialOutputs();");

        timeParallel.stop();

        // zapisanie do obiektu czasu wykonania obliczen metoda sekwencyjna i rownolegla
        String seqTimeFormatted = WriteToFile.getMillisAsFormattedSeconds(timeSeq.elapsed(TimeUnit.MILLISECONDS));
        String parallelTimeFormatted = WriteToFile.getMillisAsFormattedSeconds(timeParallel.elapsed(TimeUnit.MILLISECONDS));
        System.out.println("seqTimeFormatted: " + seqTimeFormatted);
        System.out.println("parallelTimeFormatted: " + parallelTimeFormatted);
        // wypisanie czasu wykonania programu do pliku -
        // do folderu, do ktorego wpada output z laczenia modeli po zrownolegleniu
        // WriteToFile.saveTimeToMergedFolder(seqTimeFormatted, parallelTimeFormatted);
        // jednak statystyki zapisujemy do innych plikow, w inny sposob wiec zakomentowuje
        // WriteToFile.appendStatsToFile(seqTimeFormatted, parallelTimeFormatted);
        // wypisanie do zbiorczego programu ze statystykami wykonania programu (dopisanie na jego koniec z kazdym wykonaniem programu, nie tworzenie od nowa)

        WriteToFile.writeRowsNumber(numberOfThreads, seqTimeFormatted, parallelTimeFormatted, argsSeq[0]);

        parallelAlgorithm.writeGroupedOutputToFile();


//        System.out.println("\n" + "Liczba aktywnych watkow Thread.activeCount(): " + Thread.activeCount());
//        System.out.println("Liczba dostepnych watkow Runtime.getRuntime().availableProcessors(): " + Runtime.getRuntime().availableProcessors());
    }


}
