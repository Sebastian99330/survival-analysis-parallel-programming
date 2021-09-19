import java.time.Duration;
import java.time.Instant;

public class Main {
    public static void main(String[] args) {
        final int numberOfThreads = 4;
        final int numberOfFirstThread = 1;

        TalkToR.clearWorkspace(numberOfThreads); // tworzy puste foldery na output (i ewentualnie usuwa istniejace)

        // sekwencyjnie
        Instant startSeq = Instant.now(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda sekwencyjna
        SequentialAlgorithm.callRScript();
        Instant endSeq = Instant.now();
        Duration intervalSeq = Duration.between(startSeq, endSeq);

        //rownolegle
//        Instant startParallel = Instant.now(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda rownolegla
        System.out.println("1 Przed ParallelAlgorithm parallelAlgorithm");
        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(numberOfFirstThread, numberOfThreads, null);
        System.out.println("2 Po ParallelAlgorithm parallelAlgorithm");

        parallelAlgorithm.splitInputData();
        System.out.println("3 Po parallelAlgorithm.splitInputData();");

        Instant startParallel = Instant.now(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda rownolegla
        parallelAlgorithm.runScriptParallel();
        System.out.println("4 Po parallelAlgorithm.runScriptParallel();");

        parallelAlgorithm.mergePartialOutputs();
        System.out.println("5 Po parallelAlgorithm.mergePartialOutputs();");
        Instant endParallel = Instant.now();
        Duration intervalParallel = Duration.between(startParallel, endParallel);

        System.out.println("6 Czas wykonania skryptu w sekundach dla algorytmu sekwencyjnego: " + intervalSeq.getSeconds() + "\n");
        System.out.println("7 Czas wykonania skryptu w sekundach dla algorytmu rownoleglego: " + intervalParallel.getSeconds() + "\n");


        // wyswietlenie wykresow
//        DisplayImage.displayPlots();

//        System.out.println("\n" + "Liczba aktywnych watkow Thread.activeCount(): " + Thread.activeCount());
//        System.out.println("Liczba dostepnych watkow Runtime.getRuntime().availableProcessors(): " + Runtime.getRuntime().availableProcessors());
    }
}
