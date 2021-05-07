public class Main {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello");

        String inputFilePath = "prostate_cancer.txt";
//        String inputFilePath = "prost_cancer_mln.csv";
        String outputFilePath = "output\\output.txt";

        // sciezka do pliku musi byc w cudzyslowach
        inputFilePath = "\"" + inputFilePath + "\"";
        outputFilePath = "\"" + outputFilePath + "\"";

        SequentialAlgorithm.runScript(inputFilePath,outputFilePath);

        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(inputFilePath, outputFilePath);
        parallelAlgorithm.runScript(inputFilePath,outputFilePath);

        // wyswietlenie wykresow
        DisplayImage.displayPlots();

        System.out.println("To jest blad ktory bede chcial usunac");

        System.out.println("\n" + "Liczba aktywnych watkow Thread.activeCount(): " + Thread.activeCount());
        System.out.println("Liczba dostepnych watkow Runtime.getRuntime().availableProcessors(): " + Runtime.getRuntime().availableProcessors());
    }
}
