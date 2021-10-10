import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
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
     * metoda wpisujaca do pliku testkwego liczbe wierszy w danych wejsciowych
     * potrzebna jest, bo potrzebujemy pliku, ktory zbierze w calosc wyniki testow
     * @param numberOfThreads Liczba watkow dla ktorych obliczenia sa wykonywane rownolegle
     */
    public static void writeRowsNumber(Integer numberOfThreads, String timeSeq, String timePar, String inputFileName){
        String inputFileNameNoFolder = inputFileName.replace("input//",""); // nazwa pliku bez foleru, czyli np. "turnover.csv" zamiast "input//turnover.csv" bo to niepotrzebny przedrostek
        inputFileNameNoFolder = inputFileNameNoFolder.replace("input\\",""); // usuwamy takze backslash w druga strone czyli jak bylo input\turnover.csv
        try {
            // obiekt niepotrzebny ale dla czytelnosci. -1 bo pierwsza linia to header
            String numberOfLinesStr = Integer.toString(checkNumberOfLinesInAFile(inputFileName)-1);
            // otrzymujemy przyspieszenie - ile razy jest szybciej?
            Double parTimePercentageOfSeq = (double)(Math.round((Double.parseDouble(timeSeq) / Double.parseDouble(timePar))*100))/100;
            String strParTimePercentageOfSeq = Double.toString(parTimePercentageOfSeq) + "x";
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            Date date = new Date();
            String currentDate = "\"" + formatter.format(date) + "\"";
            // str moze miec wartosc np. "1785,2," czyli poczatek linijki ze statystykami - wpis do pliku csv
            // potem skrypt R dokonczy ta linijke i zrobi znak new line. Na kazde wykonanie programu bedzie 1 taka linijka
            String str = numberOfLinesStr + "," + numberOfThreads.toString() + "," + timeSeq + "," + timePar  + "," + strParTimePercentageOfSeq +
                    "," + inputFileNameNoFolder  + "," +  currentDate + "\n";
            // wstawia znak nowej linii zanim doklei zawartosc stringa str
//            Files.write(Paths.get("statystyki.csv"), str.getBytes(), StandardOpenOption.APPEND);
            // nie wstawia nowej linii, tylko od razu dopisuje na koncu ostatniej linijki
            Files.write(Paths.get("statystyki.csv"), str.getBytes(Charset.forName("UTF-8")), StandardOpenOption.APPEND);

        }catch (IOException e) {
            System.out.println("Something went wrong.");
            e.printStackTrace();
        }
    }

    public static int checkNumberOfLinesInAFile(String input){
        int lines = 0;
        try {
            BufferedReader reader = new BufferedReader(new FileReader(input));
            while (reader.readLine() != null) { lines++; }
            reader.close();
        } catch (Exception e){
            e.printStackTrace();
        }
        return lines;
    }

    public static void savePlotAndCsv(){
        String command = "rscript --vanilla prezentacja.R \"output\\output_polaczone\\survival.rds\" \"output\\output_polaczone\\cox_polaczony.jpg\" "
                + "\"output\\output_polaczone\\ramka-polaczona.csv\" survival";
        // "\"output_seq\\cph_seq.jpg
        TalkToR.runScript(command, false);

        command = "rscript --vanilla prezentacja.R \"output\\output_seq\\ramka_seq.rds\" \"output\\output_seq\\cox_seq.jpg\" "
                + "\"output\\output_seq\\ramka-seq.csv\" survival";
        TalkToR.runScript(command, false);

        command = "rscript --vanilla zapisz-statystyki.R \"output\\output_polaczone\\bledy.rds\" \"output\\output_polaczone\\bledy_csv.csv\"";
        TalkToR.runScript(command, false);
    }

    public static void writeErrors(){
        String command = "rscript --vanilla liczenie-bledow.R";
        TalkToR.runScript(command, false);
    }

    public static String getMillisAsFormattedSeconds(long millis) {
        long secs = millis / 1000;
        long tenths = (millis - (secs * 1000)) / 100;
        long hundredths = (millis - (secs * 1000) - (tenths * 100)) / 10;
        return secs + "." + tenths + hundredths;
    }
}
