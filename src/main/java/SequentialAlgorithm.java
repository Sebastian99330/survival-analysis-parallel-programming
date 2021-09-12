public class SequentialAlgorithm {
    public static void callRScript(){
        // argumenty dla sekwencyjnego algorytmu
        String input = "turnover.csv";
//        String input = "prostate_cancer.txt";
//        String input = "prost_cancer_mln.csv";
        String outputTxtFile = "output-seq.txt";
        String kphPlotPath = "km-seq.jpg";
        String cphPlotPath = "cph-seq.jpg";
        String outputFolderName = "output_seq";
//        String rSeparator = "\"\""; // dla prostate cancer
        String rSeparator = ",";     // dla work

//        String command = "rscript --vanilla script.r " + input + " " +
//                outputTxtFile + " " + kphPlotPath + " " + cphPlotPath + " " + outputFolderName + " " + rSeparator;

        String command = "rscript --vanilla script-work.r " + input + " " +
                outputTxtFile + " " + kphPlotPath + " " + cphPlotPath + " " + outputFolderName + " " + rSeparator;

        TalkToR.runScript(command, false);
    }
}
