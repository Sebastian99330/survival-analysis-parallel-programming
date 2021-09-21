public class SequentialAlgorithm {
    public static void callRScript(){
        // argumenty dla sekwencyjnego algorytmu
        String input = "turnover.csv";
//        String input = "prostate_cancer.csv";
//        String input = "prost_cancer_mln.csv";
        String outputTxtFile = "output-seq.txt";
        String kphPlotPath = "km_seq.jpg";
        String cphPlotPath = "cph_seq.jpg";
        String outputFolderName = "output_seq";
//        String rSeparator = "\"\""; // dla prostate cancer
        String rSeparator = ",";     // dla work oraz prost cancer mln
//        String dfName = "ramka_seq.csv";
        String dfName = "ramka_seq.rds";
//        String timeStatus = "time, status"; // dla input prostate cancer
//        String groupingVariablesKm = "treatment"; // dla input prostate cancer
//        String groupingVariablesCox = "treatment + age + sh + size + index"; // dla input prostate cancer
        String timeStatus = "exp, event"; // dla input work
        String groupingVariablesKm = "branch"; // dla input work
        String groupingVariablesCox = "branch + pipeline"; // dla input work

        String command = "rscript --vanilla script.r " + input + " " +
                outputTxtFile + " " + kphPlotPath + " " + cphPlotPath + " " + outputFolderName + " " + rSeparator + " " +
                dfName + " " + timeStatus + " " + groupingVariablesKm + " " + groupingVariablesCox;

        TalkToR.runScript(command, false);
    }
}
