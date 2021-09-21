import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Klasa sluzy do obslugi pisania do plikow statystyk z wykonania programu
 */
public class WriteToFile {
    /**
     * metoda wypisuje czas wykonania programu do pliku - do folderu, do ktorego wpada output z laczenia modeli po zrownolegleniu
     * @param seqTimeFormatted - czas wykonywania programu wykonujacego obliczenia sekwencyjnie (String, format ss.ms)
     * @param parallelTimeFormatted - czas wykonywania programu wykonujacego obliczenia rownolegle (String, format ss.ms)
     */
    public static void saveTimeToMergedFolder(String seqTimeFormatted, String parallelTimeFormatted){
        // wypisanie czasu do pliku - do folderu z outputem z polaczona ramka danych po zrownolegleniu
        try {
            Files.createDirectories(Paths.get("output_laczenie"));
            PrintWriter writer = new PrintWriter("output_laczenie\\\\czas.txt", "UTF-8");
            writer.println("Czas wykonania skryptu w sekundach dla algorytmu sekwencyjnego: " + seqTimeFormatted);
            writer.println("Czas wykonania skryptu w sekundach dla algorytmu rownoleglego: " + parallelTimeFormatted);
            // obecny czas
            SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date(System.currentTimeMillis());
            writer.println("Data testu: " + formatter.format(date));
            writer.close();
        } catch (Exception e){
            System.out.println("Something went wrong.");
            e.printStackTrace();
        }
    }

    /**
     * metoda wypisuje statystki do pliku tekstowego
     * plik tekstowy jest "zbiorczy" dla wszystkich testow i program dolacza nowe statystki na koniec pliku z kazdym wykonaniem programu
     * a nie tworzy calkiem nowy plik od nowa.
     * Ta metoda wypisuje jedynie czas wykonania programu, ale do tego samego pliku dane wypisuja takze skrypty R
     * @param parallelTimeFormatted - czas wykonywania programu wykonujacego obliczenia sekwencyjnie (String, format ss.ms)
     * @param seqTimeFormatted - czas wykonywania programu wykonujacego obliczenia rownolegle (String, format ss.ms)
     */
    public static void appendStatsToFile (String seqTimeFormatted, String parallelTimeFormatted) {
        SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date(System.currentTimeMillis());
        String s = "Czas wykonania skryptu w sekundach dla algorytmu sekwencyjnego: " + seqTimeFormatted + "\n"
                + "Czas wykonania skryptu w sekundach dla algorytmu rownoleglego: " + parallelTimeFormatted + "\n"
                + "Data testu: " + formatter.format(date) + "\n\n";
        try {
            Files.write(Paths.get("wyniki-testow-wszystkie.csv"), s.getBytes(), StandardOpenOption.APPEND);
        }catch (IOException e) {
            System.out.println("Something went wrong.");
            e.printStackTrace();
        }
    }

    /**
     * metoda wpisujaca do pliku testkwego liczbe wierszy w danych wejsciowych
     * potrzebna jest, bo potrzebujemy pliku, ktory zbierze w calosc wyniki testow
     * @param numberOfThreads
     */
    public static void writeRowsNumber(Integer numberOfThreads, String timeSeq, String timePar){
        try {
            String numberOfLinesStr = "63,"; // obiekt niepotrzebny ale dla czytelnosci
            // str moze miec wartosc np. "1785,2," czyli poczatek linijki ze statystykami - wpis do pliku csv
            // potem skrypt R dokonczy ta linijke i zrobi znak new line. Na kazde wykonanie programu bedzie 1 taka linijka
            String str = numberOfLinesStr + numberOfThreads.toString() + "," + timeSeq + "," + timePar + "\n";
            // wstawia znak nowej linii zanim doklei zawartosc stringa str
//            Files.write(Paths.get("statystyki.csv"), str.getBytes(), StandardOpenOption.APPEND);
            // nie wstawia nowej linii, tylko od razu dopisuje na koncu ostatniej linijki
            Files.write(Paths.get("statystyki.csv"), str.getBytes(Charset.forName("UTF-8")), StandardOpenOption.APPEND);

        }catch (IOException e) {
            System.out.println("Something went wrong.");
            e.printStackTrace();
        }
    }
    

    public static String getMillisAsFormattedSeconds(long millis) {
        long secs = millis / 1000;
        long tenths = (millis - (secs * 1000)) / 100;
        long hundredths = (millis - (secs * 1000) - (tenths * 100)) / 10;
        return secs + "." + tenths + hundredths;
    }
}
