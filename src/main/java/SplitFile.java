import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SplitFile {

    public static void splitFile(int numberOfThreads, String inputFile, String outputFileNameBase){
        List<String> records = SplitFile.readFile(inputFile);
        String headers = String.join(",", records.remove(0)); // wyciagamy headers do zmiennej i usuwamy z ramki

        Collections.shuffle(records); // moze to doda jakiejs losowosci do podzialu danych

        // dzielimy jedna duza "ramke danych" na liste kilku mniejszych "ramek danych"
        List[] dividedRecords = SplitFile.splitLists(records, numberOfThreads);


//        SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd 'at' HH:mm:ss z");
//        System.out.println("Przed zapisem list do plikow"  + " " + formatter.format(System.currentTimeMillis()));
        // zapisujemy czastkowe ramki do pliku
        int i = 0;
        for(List<String> oneList : dividedRecords){
            String fileName = outputFileNameBase + ++i + ".csv";
//            System.out.println("Przed zapisem do pliku: " + fileName + " " + formatter.format(System.currentTimeMillis()));
            oneList.add(0, headers);
            SplitFile.writeToFileSync(oneList, fileName);
        }

    }

    // Generic method to partition a list into sublists of size `numberOfSublists` each
    // in Java using Guava (The final list might have fewer items)
    public static<T> List[] splitLists(List<T> list, int numberOfSublists)
    {
        // get the size of the list
        int size = list.size();

        // Calculate the total number of partitions `nomOfRecordsInSublist` of size `numberOfSublists` each
        int nomOfRecordsInSublist = size / numberOfSublists;
        if (size % numberOfSublists != 0) {
            nomOfRecordsInSublist++;
        }

        // create `numberOfSublists` empty lists and initialize them using `List.subList()`
        List<T>[] partition = new ArrayList[numberOfSublists];
        for (int i = 0; i < numberOfSublists; i++)
        {
            int fromIndex = i*nomOfRecordsInSublist;
            int toIndex = (i*nomOfRecordsInSublist + nomOfRecordsInSublist < size) ? (i*nomOfRecordsInSublist + nomOfRecordsInSublist) : size;

            partition[i] = new ArrayList(list.subList(fromIndex, toIndex));
        }

        // return the lists
        return partition;
    }

    public static List<String> readFile(String fileName){
        List<String> records = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {
            String line;
            while ((line = br.readLine()) != null) {
                records.add(line);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return records;
    }

    public static void writeToFileSync(List<String> records, String fileName){
        FileWriter writer;
        try {
            writer = new FileWriter(fileName);
            for (String str : records) {
                writer.write(str + System.lineSeparator());
            }
            writer.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

}
