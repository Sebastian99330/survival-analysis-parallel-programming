import java.time.Duration;
import java.time.Instant;

public class TalkToR {

    /** metoda clearWorkspace "czysci" i przygotowuje przestrzen dla algorytmow
     * czyli usuwa foldery z wynikami poprzednich wykonan programu (jesli istnieja)
     * i tworzy nowe, puste foldery do ktorych skrypt zapisze output z analizy przezycia
     * (i sekwencyjnych, i rownoleglych)
      */
    public static void clearWorkspace(int numberOfThreads) {
        // tworzymy fodlery na output dla algorytmu sekwencyjnego
        String command = "Rscript --vanilla utworz-output.r output_seq";
        TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu

        // tworzymy foldery na output dla algorytmu odpalanego rownolegle
        for (int i = 1; i <= numberOfThreads; i++) {
            command = "Rscript --vanilla utworz-output.r output_" + i;
            TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu
        }
    }

    public static void runScript(String command, boolean measureTime) {
        Instant start = Instant.now(); // pobranie czasu do mierzenia czasu wykonania skryptu

        // polecenie ktore odpalimy
        System.out.println(command);

        try {
            Process p = Runtime.getRuntime().exec(command); // uruchomienie procesu ktory wykona "w konsoli" komende command
            p.waitFor(); // obecny proces czeka dopoki wykonanie skryptu sie nie skonczy
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        Instant end = Instant.now();
        Duration interval = Duration.between(start, end);
        if (measureTime) {
            System.out.println("Czas wykonania skryptu w sekundach: " + interval.getSeconds() + "\n");
        }
    }

}
