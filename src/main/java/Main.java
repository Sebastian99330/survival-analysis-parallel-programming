import com.google.common.base.Stopwatch;
import java.util.concurrent.TimeUnit;

public class Main {
    public static void main(String[] args) {
        String[] newArgs = new String[4];
        if(args.length != 4){
            newArgs = new String[]{"input//turnover.csv", "exp, event", "branch + pipeline", "3"};
//            newArgs = new String[]{"input//turnover-mln-7.csv", "exp, event", "branch + pipeline", "10"};
//            newArgs = new String[]{"input//prostate_cancer_mln.csv", "time, status", "treatment + age + sh + size + index", "10"};
//            newArgs = new String[]{"input//turnover-edward.csv", "stag,event", "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator", "8"};
//            newArgs = new String[]{"input//turnover-edward-mln.csv", "stag,event", "gender+age+industry+profession+traffic+coach+head_gender+greywage+way+extraversion+independ+selfcontrol+anxiety+novator", "11"};
//            newArgs = new String[]{"input//nwtco-mln.csv", "edrel, rel", "instit + histol + stage + study + age + in_subcohort", "10"};
        }
        else {
            newArgs[0] = args[0];
            newArgs[1] = args[1];
            newArgs[2] = args[2];
            newArgs[3] = args[3];
        }

        String inputFileName = newArgs[0];
        String timeStatus = newArgs[1];
        String groupingCPH = newArgs[2];
        final Integer numberOfThreads = Integer.parseInt(newArgs[3]);
        final int numberOfFirstThread = 1;

        String argsSeq [] = {inputFileName,"output-seq.txt","km_seq.jpg","cph_seq.jpg","output//output_seq",
                ",","ramka_seq.rds",timeStatus,groupingCPH,"T"};

//        String argsPar [] = {inputFileName,"output//split-data//zbior_",".rds","output//output_",".txt","km_","cph_",".jpg",
//                "output//output_", ",","ramka_",".rds", timeStatus,groupingCPH,"F"};

        String argsPar [] = {inputFileName,"output//split-data//zbior_",".csv","output//output_",".txt","km_","cph_",".jpg",
                "output//output_", ",","ramka_",".rds", timeStatus,groupingCPH,"F"};

        TalkToR.clearWorkspace(numberOfThreads); // tworzy puste foldery na output (i ewentualnie usuwa istniejace)

        // sekwencyjnie
        Stopwatch timeSeq = Stopwatch.createStarted(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda sekwencyjna
        SequentialAlgorithm sequentialAlgorithm = new SequentialAlgorithm(argsSeq);
        sequentialAlgorithm.callRScript();
//        try {
//            Thread.sleep(1000);
//            System.out.println("Tutaj jest obliczanie modelu seq, ktore sie nie odbywa");
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
        timeSeq.stop();

        //rownolegle
        Stopwatch timeParallel = Stopwatch.createStarted(); // pobranie czasu do mierzenia czasu wykonania algorytmu metoda rownolegla
        System.out.println("1 Przed ParallelAlgorithm parallelAlgorithm");
        ParallelAlgorithm parallelAlgorithm = new ParallelAlgorithm(numberOfFirstThread, numberOfThreads, null, argsPar);
        System.out.println("2 Po ParallelAlgorithm parallelAlgorithm");

//        parallelAlgorithm.splitInputData();
        SplitFile.splitFile(numberOfThreads,inputFileName,"output//split-data//zbior_");
        System.out.println("3 Po parallelAlgorithm.splitInputData();");
        parallelAlgorithm.runScriptParallel();
        System.out.println("4 Po parallelAlgorithm.runScriptParallel();");
        parallelAlgorithm.mergePartialOutputs();
        System.out.println("5 Po parallelAlgorithm.mergePartialOutputs();");
//        parallelAlgorithm.runOneParallelScript();
//        System.out.println("3 Po runOneParallelScript();");
        timeParallel.stop();

        // zapisanie do obiektu czasu wykonania obliczen metoda sekwencyjna i rownolegla
        String seqTimeFormatted = WriteToFile.getMillisAsFormattedSeconds(timeSeq.elapsed(TimeUnit.MILLISECONDS));
        String parallelTimeFormatted = WriteToFile.getMillisAsFormattedSeconds(timeParallel.elapsed(TimeUnit.MILLISECONDS));
        System.out.println("seqTimeFormatted: " + seqTimeFormatted);
        System.out.println("parallelTimeFormatted: " + parallelTimeFormatted);
        // wypisanie czasu wykonania programu do pliku -
        // do folderu, do ktorego wpada output z laczenia modeli po zrownolegleniu
        // WriteToFile.saveTimeToMergedFolder(seqTimeFormatted, parallelTimeFormatted);
        // jednak statystyki zapisujemy do innych plikow, w inny sposob wiec zakomentowuje
        // WriteToFile.appendStatsToFile(seqTimeFormatted, parallelTimeFormatted);
        // wypisanie do zbiorczego programu ze statystykami wykonania programu (dopisanie na jego koniec z kazdym wykonaniem programu, nie tworzenie od nowa)
        WriteToFile.writeErrors();
        WriteToFile.savePlotAndCsv(); // narysowanie wykresow do plikow png
        WriteToFile.writeRowsNumber(numberOfThreads, seqTimeFormatted, parallelTimeFormatted, argsSeq[0]);
        parallelAlgorithm.writeGroupedOutputToFile();


    }


}
