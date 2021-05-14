public class SequentialAlgorithm {

    public static void runSequentialAlgorithm(String inputFileName, String outputTxtFile, String kmPath, String cphPath, String outputFolderName, String rSeparator) {
        // polecenie ktore odpalimy
        String command = "rscript --vanilla script.r " + inputFileName + " " +
                outputTxtFile + " " + kmPath + " " + cphPath + " " + outputFolderName + " " + rSeparator;
        TalkToR.runScript(command, true);
    }

}
