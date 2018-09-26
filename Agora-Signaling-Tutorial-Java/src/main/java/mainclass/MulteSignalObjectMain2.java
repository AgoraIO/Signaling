package mainclass;

import tool.Constant;

public class MulteSignalObjectMain2 {

    public static void main(String[] args) {
        WorkerThread workerThread = new WorkerThread(Constant.COMMAND_MULTI_SIGNAL_OBJECT);
        new Thread(workerThread).start();
    }
}
