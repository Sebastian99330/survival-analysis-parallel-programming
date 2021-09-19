import com.google.common.base.Stopwatch;

import java.util.concurrent.TimeUnit;

public class Main {
    public static void main(String[] args) {
        final Integer numberOfThreads = 2;
        final int numberOfFirstThread = 1;

        TalkToR.clearWorkspace(numberOfThreads); // tworzy puste foldery na output (i ewentualnie usuwa istniejace)

        // sekwencyjnie
        Stopwatch timeSeq = Stopwatch.createStarted(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda sekwencyjna
        SequentialAlgorithm.callRScript();
        timeSeq.stop();

        //rownolegle
        Stopwatch timeParallel = Stopwatch.createStarted(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda rownolegla
        System.out.println("1 Przed ParallelAlgorithm parallelAlgorithm");
        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(numberOfFirstThread, numberOfThreads, null);
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
        WriteToFile.saveTimeToMergedFolder(seqTimeFormatted, parallelTimeFormatted);
        WriteToFile.appendStatsToFile(seqTimeFormatted, parallelTimeFormatted);
        // wypisanie do zbiorczego programu ze statystykami wykonania programu (dopisanie na jego koniec z kazdym wykonaniem programu, nie tworzenie od nowa)


        WriteToFile.writeRowsNumber(numberOfThreads, seqTimeFormatted, parallelTimeFormatted);

//        System.out.println("\n" + "Liczba aktywnych watkow Thread.activeCount(): " + Thread.activeCount());
//        System.out.println("Liczba dostepnych watkow Runtime.getRuntime().availableProcessors(): " + Runtime.getRuntime().availableProcessors());
    }


}
