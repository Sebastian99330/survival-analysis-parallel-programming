public class Main {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello");

        String inputFileName = "prostate_cancer.txt";
//        String inputFileName = "prost_cancer_mln.csv";
        String outputFileName = "output\\output.txt";

        // sciezka do pliku musi byc w cudzyslowach
        inputFileName = "\"" + inputFileName + "\"";
        outputFileName = "\"" + outputFileName + "\"";

        SequentialAlgorithm.runScript(inputFileName,outputFileName);

        // wyswietlenie wykresow
        DisplayImage.displayPlots();

        System.out.println(Thread.activeCount());
        System.out.println(Runtime.getRuntime().availableProcessors());

    }
}
