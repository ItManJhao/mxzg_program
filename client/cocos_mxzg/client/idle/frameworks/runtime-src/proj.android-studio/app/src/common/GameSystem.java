package common;

import com.blank.cleck.Cleck;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

public class GameSystem {
	
	public static String getMainClassNameForJNI() {
		String s = Cleck.class.getName();
		s = s.replace(".", "/");
		return s;
	}
	
	public static native void dialogCallBack(int msg_box_address, int button_index);

	// 获取语言包文字
	public static native String getLanguage(int lang);
	
	public static native void exitGame();
	
	public static native boolean pluginMonitor();
	
	public static int getNetworkState() {
		return getNetworkState(null);
	}
	
	public static int getNetworkState(Context context) {
		// 0: 没有网络    1: WIFI     2: 移动数据
		if (context == null) {
			context = AppActivity.shared;
		}

		if (context == null) {
			return 0;
		}

		//Log.d("getNetInfo", "enter the function getNetInfo ----- ");
		// 根据Android的安全机制，在使用ConnectivityManager时，必须在AndroidManifest.xml中添加<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /> 否则无法获得系统的许可。
		ConnectivityManager connMgr = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
		if (null == networkInfo) {
			//Log.d("getNetInfo", "net type : null");
			return 0;
		}

		int nType = networkInfo.getType();
		if (nType == ConnectivityManager.TYPE_MOBILE) {
			//Log.d("getNetInfo", "net type : mobile");
			return 2;
		}
		if (nType == ConnectivityManager.TYPE_WIFI) {
			//Log.d("getNetInfo", "net type : wifi");
			return 1;
		}

		//Log.d("getNetInfo", "net type : null");
		return 0;
	}

	public static native void orientationChange(int orient);


	// SDK接口
	public static native void loginCallback(int success, String user_id, String user_token, String user_name, String game_id);
	public static native void payCallback(int success, String order_id, String error_msg);

	// 信鸽
	public static native void xingeCallback(String token);

	// success:0 为实名，1已实名  user_id:用户id   adult: 0->成年人； 1->未成年人； -1->无
	public static native void realName(int success, String user_id, int adult);

	public static native void shareLinkCallback(int success, String msg);
	public static native void dzCallback(int success, String msg);
	public static native void giftBagCallback(int success, String msg);
	public static native void showAdCallback(String type);
}
