import java.time.Duration;
import java.time.Instant;

public class SequentialAlgorithm {
    public static void runScript(String inputFileName, String outputFileName){
        try {
            Instant start = Instant.now(); // pobranie czasu do mierzenia czasu wykonania skryptu

            // polecenie ktore odpalimy
            String command = "rscript --vanilla script.r " + inputFileName + " "  + outputFileName;
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
