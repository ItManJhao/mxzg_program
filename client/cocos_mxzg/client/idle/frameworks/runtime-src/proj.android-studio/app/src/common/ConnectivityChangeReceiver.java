package common;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;

public class ConnectivityChangeReceiver extends BroadcastReceiver {

	@Override
	public void onReceive(Context context, Intent intent) {
		System.out.println("onReceive: " + intent.getAction());

		if (ConnectivityManager.CONNECTIVITY_ACTION.equals(intent.getAction())) {
//			int s = GameSystem.getNetworkState(context);
//			switch (s) {
//			case 1:
//				Toast.makeText(context, "无线网络连接成功！", Toast.LENGTH_SHORT).show();
//				break;
//			case 2:
//				Toast.makeText(context, "手机网络连接成功！", Toast.LENGTH_SHORT).show();
//				break;
//			default:
//				Toast.makeText(context, "手机没有任何网络...", Toast.LENGTH_SHORT).show();
//				break;
//			}
		}
	}
}
