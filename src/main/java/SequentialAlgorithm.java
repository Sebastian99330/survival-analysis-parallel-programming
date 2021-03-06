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
    String groupingVariablesCox;
    String savePlot;

    public SequentialAlgorithm(String[] args) {
        this.input = args[0];
        this.outputTxtFile = args[1];
        this.kphPlotPath = args[2];
        this.cphPlotPath = args[3];
        this.outputFolderName = args[4];
        this.rSeparator = args[5];
        this.dfName = args[6];
        this.timeStatus = args[7];
        this.groupingVariablesCox = args[8];
        this.savePlot = args[9];
    }

    public void callRScript(){

        String command = "rscript --vanilla script.R " + this.input + " " +
                this.outputTxtFile + " " + this.kphPlotPath + " " + this.cphPlotPath + " " + this.outputFolderName + " " + this.rSeparator + " " +
                this.dfName + " \"" + this.timeStatus + "\" \"" + this.groupingVariablesCox + "\" " + this.savePlot;

        TalkToR.runScript(command, true);
    }
}
