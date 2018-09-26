package mainclass;

import tool.Constant;

public class SingleSignalObjectMain {

    public static void main(String[] args) {
        WorkerThread workerThread = new WorkerThread(Constant.COMMAND_SINGLE_SIGNAL_OBJECT);
        new Thread(workerThread).start();
    }
}
