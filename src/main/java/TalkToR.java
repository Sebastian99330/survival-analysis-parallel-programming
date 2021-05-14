import java.time.Duration;
import java.time.Instant;

public class TalkToR {
    public static void runScript(String command, boolean measureTime) {
        Instant start = Instant.now(); // pobranie czasu do mierzenia czasu wykonania skryptu

        // polecenie ktore odpalimy
        System.out.println(command);

        try {
            Process p = Runtime.getRuntime().exec(command);
            p.waitFor(); // obecny proces czeka dopoki wykonanie skryptu sie nie skonczy
        } catch (Exception ex) {
            ex.printStackTrace();
        }


        Instant end = Instant.now();
        Duration interval = Duration.between(start, end);
        if (measureTime == true) {
            System.out.println("Czas wykonania skryptu w sekundach: " + interval.getSeconds() + "\n");
        }
    }
}
