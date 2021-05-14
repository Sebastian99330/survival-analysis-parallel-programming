import java.time.Duration;
import java.time.Instant;

public class Main {
    public static void main(String[] args) {

        String input = "prostate_cancer.txt";
//        String input = "prost_cancer_mln.csv";
        String output = "output.txt";
        String kphPlotPath = "km-seq.jpg";
        String cphPlotPath = "cph-seq.jpg";
        String outputSequential = "output_seq";
        String rSeparator = "\"\"";

        int numberOfThreads = 6;

        Instant startSeq = Instant.now(); // pobranie czasu do mierzenia czasu wykonania skryptu

        TalkToR.clearWorkspace(numberOfThreads);
        SequentialAlgorithm.runSequentialAlgorithm(input, output, kphPlotPath, cphPlotPath, outputSequential, rSeparator);
        Instant endSeq = Instant.now();
        Duration intervalSeq = Duration.between(startSeq, endSeq);


        Instant startParallel = Instant.now(); // pobranie czasu do mierzenia czasu wykonania skryptu

        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(input);
        parallelAlgorithm.splitInputData(input, numberOfThreads);
        parallelAlgorithm.runParallelAlgorithm(input,output, numberOfThreads);

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
