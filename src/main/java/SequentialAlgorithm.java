public class SequentialAlgorithm {
    public static void callRScript(){
        // argumenty dla sekwencyjnego algorytmu
//        String input = "turnover.csv";
//        String input = "prostate_cancer.txt";
        String input = "prost_cancer_mln.csv";
        String outputTxtFile = "output-seq.txt";
        String kphPlotPath = "km_seq.jpg";
        String cphPlotPath = "cph_seq.jpg";
        String outputFolderName = "output_seq";
//        String rSeparator = "\"\""; // dla prostate cancer
        String rSeparator = ",";     // dla work oraz prost cancer mln
        String dfName = "ramka_seq.csv";

        String command = "rscript --vanilla script.r " + input + " " +
                outputTxtFile + " " + kphPlotPath + " " + cphPlotPath + " " + outputFolderName + " " + rSeparator + " " + dfName;

//        String command = "rscript --vanilla script-work.r " + input + " " +
//                outputTxtFile + " " + kphPlotPath + " " + cphPlotPath + " " + outputFolderName + " " + rSeparator + " "  + dfName;

        TalkToR.runScript(command, false);
    }
}
