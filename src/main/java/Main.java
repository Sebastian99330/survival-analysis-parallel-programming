import java.time.Duration;
import java.time.Instant;

public class Main {
    public static void main(String[] args) {
        final int numberOfThreads = 5;
        final int numberOfFirstThread = 1;

        TalkToR.clearWorkspace(numberOfThreads);

        // sekwencyjnie
        Instant startSeq = Instant.now(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda sekwencyjna
        SequentialAlgorithm.callRScript();
        Instant endSeq = Instant.now();
        Duration intervalSeq = Duration.between(startSeq, endSeq);


        //rownolegle
        Instant startParallel = Instant.now(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda rownolegla

        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(numberOfFirstThread, numberOfThreads);
        parallelAlgorithm.splitInputData();
        parallelAlgorithm.runScriptParallel();

        Instant endParallel = Instant.now();
        Duration intervalParallel = Duration.between(startParallel, endParallel);

        System.out.println("Czas wykonania skryptu dla algorytmu sekwencyjnego: " + intervalSeq.getSeconds() + "\n");
        System.out.println("Czas wykonania skryptu dla algorytmu rownoleglego: " + intervalParallel.getSeconds() + "\n");


        // wyswietlenie wykresow
//        DisplayImage.displayPlots();

//        System.out.println("\n" + "Liczba aktywnych watkow Thread.activeCount(): " + Thread.activeCount());
//        System.out.println("Liczba dostepnych watkow Runtime.getRuntime().availableProcessors(): " + Runtime.getRuntime().availableProcessors());
    }
}
