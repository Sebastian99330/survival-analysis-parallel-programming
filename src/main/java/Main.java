import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.Executors;

public class Main {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello");

        String inputFileName = "prostate_cancer.txt";
//        String inputFileName = "prost_cancer_mln.csv";
        String outputFileName = "output.txt";

        ParallelAlgorithm.runScript();

        // sciezka do pliku musi byc w cudzyslowach
        inputFileName = "\"" + inputFileName + "\"";
        outputFileName = "\"" + outputFileName + "\"";

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

        // polecenie ktore odpalimy - bez czekania,
        // rzuca blad jak jest duzo danych i sie usunie output dzialania poprzedniego skryptu
//        String command = "rscript --vanilla script.r " + inputFileName + " "  + outputFileName;
//        System.out.println(command);
//        Runtime.getRuntime().exec(command);


        // wyswietlenie wykresow
        DisplayImage.displayPlots();

        System.out.println(Thread.activeCount());
        System.out.println(Runtime.getRuntime().availableProcessors());
    }
    // tutaj byl blad
}
