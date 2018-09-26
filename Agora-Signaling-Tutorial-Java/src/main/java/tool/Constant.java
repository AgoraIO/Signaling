package tool;

import java.util.ArrayList;

public class Constant {
	public static int CURRENT_APPID = 0;
	public static ArrayList <String>app_ids = new ArrayList<String>();
	static {
		//app_ids.add("Your_appId");
		//app_ids.add("Your_appId");
	}
	public static String COMMAND_LOGOUT="logout";
	public static String COMMAND_LEAVE_CHART="leave";
	
	//11public static String COMMAND
	public static String COMMAND_TYPE_SINGLE_POINT="2";
	public static String COMMAND_TYPE_CHANNEL="3";
	
	public static String RECORD_FILE_P2P="test_p2p.tmp";
	public static String RECORD_FILE_CHANEEL="test_channel.tmp";
	public static int TIMEOUT=20000;
	
	
	//add by
	public static String COMMAND_CREATE_SIGNAL="0";
	public static String COMMAND_CREATE_ACCOUNT="1";
	
	public static String COMMAND_SINGLE_SIGNAL_OBJECT = "0";
	public static String COMMAND_MULTI_SIGNAL_OBJECT = "1";
	
}
