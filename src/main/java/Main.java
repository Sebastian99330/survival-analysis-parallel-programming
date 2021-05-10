import java.time.Duration;
import java.time.Instant;

public class Main {
    public static void main(String[] args) {

        String inputFilePath = "prostate_cancer.txt";
//        String inputFilePath = "prost_cancer_mln.csv";
        String outputFilePath = "output\\output.txt";

        SequentialAlgorithm.runScript(inputFilePath,outputFilePath);

        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(inputFilePath);
        parallelAlgorithm.splitInputData(inputFilePath);
//        parallelAlgorithm.runScript(inputFilePath,outputFilePath);

        // wyswietlenie wykresow
//        DisplayImage.displayPlots();

//        System.out.println("\n" + "Liczba aktywnych watkow Thread.activeCount(): " + Thread.activeCount());
//        System.out.println("Liczba dostepnych watkow Runtime.getRuntime().availableProcessors(): " + Runtime.getRuntime().availableProcessors());
    }
}
