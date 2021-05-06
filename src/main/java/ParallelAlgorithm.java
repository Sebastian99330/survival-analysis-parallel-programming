public class ParallelAlgorithm implements Runnable{
    String inputFilePath;
    String outputFilePath;

    public ParallelAlgorithm(String inputFilePath, String outputFilePath) {
        this.inputFilePath = inputFilePath;
        this.outputFilePath = outputFilePath;
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
