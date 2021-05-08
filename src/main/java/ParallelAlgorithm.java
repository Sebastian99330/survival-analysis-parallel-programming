import java.time.Duration;
import java.time.Instant;

public class ParallelAlgorithm implements Runnable{
    String inputFilePath;
    String outputFilePath;
    String splitInputFilePath = "Split-data\\zbior_";
    String splitInputFilePathSuffix = ".csv";

    public ParallelAlgorithm(String inputFilePath, String outputFilePath) {
        this.inputFilePath = inputFilePath;
        this.outputFilePath = outputFilePath;
    }

    public void splitInputData(String inputFilePath){
        String command = "rscript --vanilla dzielenie-zbioru.R " + inputFilePath;
        System.out.println("Splitting Data with "+command);
        try {
            Instant start = Instant.now(); // pobranie czasu do mierzenia czasu wykonania skryptu

            Process p = Runtime.getRuntime().exec(command);
            // obecny proces czeka dopoki wykonanie skryptu sie nie skonczy
            p.waitFor();

            Instant end = Instant.now();
            Duration interval = Duration.between(start, end);
            System.out.println("Czas w sekundach dzielenia zbioru danych wejsciowych: " + interval.getSeconds());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void runScript(String inputFileName, String outputFileName){
        for(var i =0;i<4; i++) {
//            System.out.println("\n" + "Nazwa " + i + " watku w petli" + Thread.currentThread().getName());
            Thread thread = new Thread(this);
            thread.start();
        }

    }

    @Override
    public void run() {
        System.out.println("Thread name (ParallelAlgorithm.run): "+Thread.currentThread().getName());
    }
}
