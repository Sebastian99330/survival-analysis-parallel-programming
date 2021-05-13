import java.time.Duration;
import java.time.Instant;

public class ParallelAlgorithm implements Runnable{
    String input;
    String splitOutputFilePath = "output";
    String splitOutputFilePathSuffix = ".txt";
//    String splitInputFilePath = "Split-data\\zbior_";
    String splitInputFilePath = "zbior_";
    String splitInputFilePathSuffix = ".csv";
    String cphPlotOutputPath = "cph";
    String kphPlotOutputPath = "km";
    String plotSuffix = ".jpg";

    public ParallelAlgorithm(String input) {
        this.input = input;
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
        String rSeparator = "\",\"";
        for(int i =1;i<=4; i++) {
            String input = "Split-data\\\\"+ splitInputFilePath + i + splitInputFilePathSuffix;
            String output = splitOutputFilePath + i + splitOutputFilePathSuffix;
            String km = kphPlotOutputPath  + i + plotSuffix;
            String cph = cphPlotOutputPath + i + plotSuffix;
            String outputFolderName = "output_" + i;
            SequentialAlgorithm.runScript(input,output, km, cph, outputFolderName, rSeparator);
//rscript --vanilla script.r Split-data\zbior_1.csv output1.txt km1.jpg cph1.jpg
            // to dziala w folderze R, separator musi byc ustawiony w skrypcie ; albo spacja.
        }

    }

    @Override
    public void run() {
        System.out.println("Thread name (ParallelAlgorithm.run): "+Thread.currentThread().getName());
    }
}
