public class SequentialAlgorithm {
    public static void runScript(String inputFileName, String outputFileName){
        try {
            System.out.println("Tworze proces");

            // polecenie ktore odpalimy
            String command = "rscript --vanilla script.r " + inputFileName + " "  + outputFileName;
            System.out.println(command);
            Process p = Runtime.getRuntime().exec(command);

            // obecny proces czeka dopoki wykonanie skryptu sie nie skonczy
            p.waitFor();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
