public class SequentialAlgorithm {
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
    // sekwencyjny wypisuje csv, bo to juz nie jest posredni output tylko ostateczny\
    // jednak nie, musi byc rds bo potem rownolegle jeszcze to wczytuja
//        String dfName = "ramka_seq.csv";
    String dfName = "ramka_seq.rds";
    //        String timeStatus = "time, status"; // dla input prostate cancer
//        String groupingVariablesKm = "treatment"; // dla input prostate cancer
//        String groupingVariablesCox = "treatment + age + sh + size + index"; // dla input prostate cancer
    String timeStatus = "exp, event"; // dla input work
    String groupingVariablesKm = "branch"; // dla input work
    String groupingVariablesCox = "branch + pipeline"; // dla input work

    public SequentialAlgorithm(String[] args) {
        this.input = args[0];
        this.outputTxtFile = args[1];
        this.kphPlotPath = args[2];
        this.cphPlotPath = args[3];
        this.outputFolderName = args[4];
        this.rSeparator = args[5];
        this.dfName = args[6];
        this.timeStatus = args[7];
        this.groupingVariablesKm = args[8];
        this.groupingVariablesCox = args[9];
    }

    public void callRScript(){

        String command = "rscript --vanilla script.r " + this.input + " " +
                this.outputTxtFile + " " + this.kphPlotPath + " " + this.cphPlotPath + " " + this.outputFolderName + " " + this.rSeparator + " " +
                this.dfName + " " + this.timeStatus + " " + this.groupingVariablesKm + " " + this.groupingVariablesCox;

        TalkToR.runScript(command, false);
    }
}
