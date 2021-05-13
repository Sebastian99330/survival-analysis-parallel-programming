import java.time.Duration;
import java.time.Instant;

public class SequentialAlgorithm{

    public static void clearWorkspace(){
        try {
            String command = "Rscript --vanilla utworz-output.r output_seq";
            Process p = Runtime.getRuntime().exec(command);

            // obecny proces czeka dopoki wykonanie skryptu sie nie skonczy
            p.waitFor();

            for (int i = 1; i <= 4; i++) {
                command = "Rscript --vanilla utworz-output.r output_"+i;
                System.out.println(command);
                p = Runtime.getRuntime().exec(command);
                // obecny proces czeka dopoki wykonanie skryptu sie nie skonczy
                p.waitFor();
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void runScript(String inputFileName, String outputTxtFile, String kmPath, String cphPath, String outputFolderName, String rSeparator){
        try {
            Instant start = Instant.now(); // pobranie czasu do mierzenia czasu wykonania skryptu

            // polecenie ktore odpalimy
            String command = "rscript --vanilla script.r " + inputFileName + " "  +
                    outputTxtFile + " " + kmPath + " " + cphPath + " " + outputFolderName + " " + rSeparator;
            System.out.println(command);
            Process p = Runtime.getRuntime().exec(command);

            // obecny proces czeka dopoki wykonanie skryptu sie nie skonczy
            p.waitFor();

            Instant end = Instant.now();
            Duration interval = Duration.between(start, end);
            System.out.println("Czas w sekundach wykonania algorytmu metodą sekwencyjną: " + interval.getSeconds());

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

}
