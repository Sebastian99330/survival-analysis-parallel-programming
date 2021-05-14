public class Main {
    public static void main(String[] args) {

//        String input = "prostate_cancer.txt";
        String input = "prost_cancer_mln.csv";
        String output = "output.txt";
        String kphPlotPath = "km-seq.jpg";
        String cphPlotPath = "cph-seq.jpg";
        String outputSequential = "output_seq";
        String rSeparator = "\"\"";

        SequentialAlgorithm.clearWorkspace();
        SequentialAlgorithm.runSequentialAlgorithm(input, output, kphPlotPath, cphPlotPath, outputSequential, rSeparator);

        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(input);
        parallelAlgorithm.splitInputData(input);
        parallelAlgorithm.runParallelAlgorithm(input,output);


        // wyswietlenie wykresow
//        DisplayImage.displayPlots();

//        System.out.println("\n" + "Liczba aktywnych watkow Thread.activeCount(): " + Thread.activeCount());
//        System.out.println("Liczba dostepnych watkow Runtime.getRuntime().availableProcessors(): " + Runtime.getRuntime().availableProcessors());
    }
}
