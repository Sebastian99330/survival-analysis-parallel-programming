import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.time.Duration;
import java.time.Instant;

public class TalkToR {

    /** metoda clearWorkspace "czysci" i przygotowuje przestrzen dla algorytmow
     * czyli usuwa foldery z wynikami poprzednich wykonan programu (jesli istnieja)
     * i tworzy nowe, puste foldery do ktorych skrypt zapisze output z analizy przezycia
     * (i sekwencyjnych, i rownoleglych)
      */
    public static void clearWorkspace(int numberOfThreads) {
        // tworzymy glowny folder na output
        String command = "Rscript --vanilla utworz-output.R output";
        TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu

        // tworzymy fodlery na output dla algorytmu sekwencyjnego
        command = "Rscript --vanilla utworz-output.R output//output_seq";
        TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu

        // tworzymy foldery na output dla algorytmu odpalanego rownolegle
        for (int i = 1; i <= numberOfThreads; i++) {
            command = "Rscript --vanilla utworz-output.R output//output_" + i;
            TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu
        }

        // tworzymy foldery na output dla polaczonych danych
        command = "Rscript --vanilla utworz-output.R output//output_polaczone";
        TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu

        // tworzymy foldery na podzielone dane czastkowe
        command = "Rscript --vanilla utworz-output.R output//split-data";
        TalkToR.runScript(command, false); // nie mierzymy czasu wykonania bo to tylko usuniecie i utworzenie katalogu

    }

    public static void runScript(String command, boolean measureTime) {
        Instant start = Instant.now(); // pobranie czasu do mierzenia czasu wykonania skryptu

        // polecenie ktore odpalimy
        System.out.println(command);

        try {
            Process p = Runtime.getRuntime().exec(command); // uruchomienie procesu ktory wykona "w konsoli" komende command
            p.waitFor(); // obecny proces czeka dopoki wykonanie skryptu sie nie skonczy

            // wypisanie do konsoli Java outputu ze skryptu
            BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String s = null;
            while ((s = in.readLine()) != null) {
                System.out.println(s);
            }
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
