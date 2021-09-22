public class SequentialAlgorithm {
    // argumenty dla sekwencyjnego algorytmu
    String input;
    String outputTxtFile;
    String kphPlotPath;
    String cphPlotPath;
    String outputFolderName;
    String rSeparator;
    String dfName;
    String timeStatus;
    String groupingVariablesKm;
    String groupingVariablesCox;

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
