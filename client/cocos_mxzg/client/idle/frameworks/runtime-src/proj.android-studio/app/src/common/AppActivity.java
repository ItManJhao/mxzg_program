package common;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;
import java.util.Vector;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;
import org.cocos2dx.lib.Cocos2dxHelper;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.graphics.PixelFormat;
import android.hardware.SensorManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PowerManager;
import android.provider.Settings.Secure;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.OrientationEventListener;
import android.view.Surface;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import com.tencent.bugly.crashreport.CrashReport;

// import com.tencent.android.tpush.XGIOperateCallback;
// import com.tencent.android.tpush.XGPushConfig;
// import com.tencent.android.tpush.XGPushManager;

import com.oversgame.mobile.Lhwl_Platform;
import com.oversgame.mobile.haiwai.Lhwl_CallBack;
import com.oversgame.mobile.net.model.Lhwl_PayParams;
import com.oversgame.mobile.net.model.Lhwl_UserExtraData;
import com.oversgame.mobile.net.status.Lhwl_UserInfo;
import com.oversgame.mobile.permission.PermissionApply;
import com.oversgame.mobile.utils.RechargeType;
import com.oversgame.mobile.utils.UtilCom;

// import android.support.annotation.NonNull;

import android.content.ClipboardManager;

//  @SuppressLint("InlinedApi") public class AppActivity extends Cocos2dxActivity

@SuppressLint("InlinedApi") public class AppActivity extends Cocos2dxActivity {
	public static AppActivity shared = null;
	public static ViewGroup viewGroup = null;
	private static WebView web_view = null;

	// 亮度控制
	// 最大的屏幕亮度
	private float maxLight;

	// 当前的亮度
	private float currentLight;

	// 用来控制屏幕亮度
	private Handler lightHandler;

	// 60秒时间不点击屏幕，屏幕变暗
	private long delayTime = 150 * 1000L;


	// 屏蔽旋转
	OrientationEventListener mOrientationListener;
	int orientation = -1;
	int notch_height = -1;
	private long backKeyDownTime = 0; // 上一次点返回按键的时间


	// <!--信鸽SDK start-->
	public String xingeId = "2100341152";
	public String xingeKey = "AXS3V72BR15S";
	public static String xinge_token = "";

	// <!--非凡SDK start-->
	boolean is_logouting = false;	//隐藏分享，获取公众号的按钮
	boolean is_logining = false;	// 是否正在登陆中
	boolean is_init_finish = false; // 是否初始化完成
	Timer time_login = null;
	// <!--非凡SDK end-->


	// <!--可以SDK start-->
	private String gameId = "177";
	private String gameKey = "7c9a1c54bb3583bb7af9054efbd9ba3c";

	// 临时缓存的数据
	String bill_no = "";

	//用户userCode ,玩家信息接口以及充值接口需要改参数
	String user_code = "";
	String user_token = "";
	String user_name = "";
	String guide_num = "";				// 新手指引进度
	String role_id = "";				// 角色ID
	String role_create_time = "";		// 角色创建等级
	String role_name = "";				// 角色名称
	String role_level = "";				// 角色等级
	String server_id = "";				// 服务器ID
	String server_name = "";			// 服务器名称
	String balance = "";				// 游戏币余额
	String vip_level = "";				// VIP等级
	String gem_num = "";				// 钻石余额
	String attack_num = "";				// 战斗力（攻击力）
	String extra_info = "";				// 拓展信息
	String clan_name = "";				// 公会名称

	boolean isHideShareAndPublic = true;//隐藏分享，获取公众号的按钮
    // <!--可以SDK end-->

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		shared = this;

		Cocos2dxGLSurfaceView glView = this.getGLSurfaceView();
		if (glView != null) {
			glView.setMultipleTouchEnabled(false);
		}

//		CrashReport.initCrashReport(getApplicationContext(),"1f9982182c", false);

		Log.i("cleck", "game activity on create232323asdsad . . .");
		viewGroup = (ViewGroup) getWindow().getDecorView();


		// 防息屏相关
//		getCurrentFocus().setKeepScreenOn(true);

		// 保持屏幕常亮

		getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
				  			 WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

		// 屏幕亮度控制
		lightHandler = new Handler(Looper.getMainLooper());
		maxLight = getLightness();

		this.hideNavigationBar();
		shared.is_logouting = false;

		shared.initFeiFanSdk();

//		String[] permissions = {Manifest.permission.WRITE_EXTERNAL_STORAGE};
//		PermissionManager.getInstance().setMainView(this);
//		PermissionManager.getInstance().requestRunTimePermission(permissions);

		// <!--可以SDK start-->
//		init(viewGroup);


		//  线程切换代码示例
//		this.runOnUiThread(new Runnable() {
//			@Override
//			public void run() {
//				AlertDialog dialog = new AlertDialog.Builder(runrun.getInstance()).create();
//				dialog.setTitle("cocos2dx:");
//				dialog.setMessage("Android");
//				dialog.setCancelable(false);
//				dialog.show();
//			}
//		});

//		this.runOnGLThread(new Runnable() {
//			@Override
//			public void run() {
//				// TODO Auto-generated method stub
//				Log.e("--->", "Untils_  "+Thread.currentThread().getName());
//				CallCpp.getItem(id);
//			}
//		});

	}

	public void initFeiFanSdk() {
		/*********初始化开始 下面代码可以直接拷贝到 onCreate 对应的调整就可以了*********/
		Lhwl_Platform.getInstance().twInitFacebook(this);//初始化facebook
		UtilCom.setIsDebug(true);
//		RechargeType.setType(RechargeType.THIRD_TYPE);//第三方充值包
// RechargeType.ALL_TYPE

		int rechargeType = RechargeType.ALL_TYPE;
		if (rechargeType == RechargeType.ALL_TYPE) {
			if (Cocos2dxHelper.getObbFile() == null) {
				Log.i("cleck", "Cocos2dxHelper.getObbFile() == null");
				PermissionManager permissionManager = PermissionManager.getInstance();
				permissionManager.setMainView(this);
				permissionManager.addPermissionData(Manifest.permission.WRITE_EXTERNAL_STORAGE,
													"應用需要存儲空間權限才能讀取到OBB文件，禁用將導致遊戲無法正常運行。",
													"文件存儲權限已被禁用，遊戲無法正常運行。",
													true);
				permissionManager.requestRunTimePermission();
			}
		}
		RechargeType.setType(rechargeType);	//google包

		//由于google 包上线
		Lhwl_Platform.getInstance().fhwf_InitSDK(shared, new Lhwl_CallBack.TwCallBackListener() {
			@Override
			public void onInitResult(boolean b) {
				if (b == false) {
					Lhwl_Platform.getInstance().fhwf_chooselogin(shared, true);
					return;
				}


				//初始化成功 才会回调到这里
				Log.i("MainActivity", "init success");
				try{
					shared.is_init_finish = true;
					if (shared.is_logining) {
//						shared.time_login =  new Timer();
//						shared.time_login.schedule(new TimerTask() {
//							@Override
//							public void run() {
								shared.runOnUiThread(new Runnable() {
									@Override
									public void run() {
										Log.i("MainActivity", "init success login");
										Lhwl_Platform.getInstance().fhwf_chooselogin(shared, true);

										// shared.time_login.cancel();
										// shared.time_login = null;
									}
								});
//							}
//						},1000, 1000);
					}
				} catch (NullPointerException e) {
					Log.e("crsh:","报空指针异常");
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			@Override
			public void onLoginResult(Lhwl_UserInfo userInfo) {
				android.util.Log.i("MainActivity", userInfo.getWhiteListFlag() + " uid=" + userInfo.getUid() + " token=" + userInfo.getToken());

				shared.is_logining = false;
				final String str_user_id = userInfo.getUid();
				final String str_user_token = userInfo.getToken();
				final String str_user_name = userInfo.getUserName();
				shared.user_code = userInfo.getUid();

				shared.runOnGLThread(new Runnable() {
					@Override
					public void run() {
						GameSystem.loginCallback(1, str_user_id, str_user_token, str_user_name, getFuseAgent("FF_APP_ID"));
					}
				});
			}

			@Override
			public void onLogoutResult() {
				//不能在这里面执行登陆
				Log.i("MainActivity", "demo logout");

				if (shared.is_logouting) {
					shared.is_logouting = false;
					shared.runOnGLThread(new Runnable() {
						@Override
						public void run() {
							GameSystem.loginCallback(0, "", "", "", "");
						}
					});
				}
			}

			@Override
			public void onAccountUpgrade(Lhwl_UserInfo userInfo) {
				//帐号升级回调
				userInfo.getUid();
				userInfo.getToken();
				android.util.Log.i("MainActivity", userInfo.getWhiteListFlag() + " uid=" + userInfo.getUid() + " token=" + userInfo.getToken());
			}

			@Override
			public void onSwitchAccount() {
				// 登陆成功后，可以看到平台浮标，浮标里面有切换帐号功能，点击后在这可以监听到。
				//这部分逻辑必须处理。
				//1、调用登陆界面 需要取消自动登陆功能
//				shared.is_logouting = true;
//				Lhwl_Platform.getInstance().fhwf_chooselogin(shared, false);
				//2、下面需执行返回登陆界面逻辑，进行切换玩家信息，
				Log.i("MainActivity", "onSwitchAccount");

				shared.runOnGLThread(new Runnable() {
					@Override
					public void run() {
						GameSystem.loginCallback(0, "", "", "", "");
					}
				});
			}
			@Override
			public void onShareResult(boolean b) {//分享成功回调
				if(b)
				{
					//分享成功回调后： 显示领取界面——>点击领取按钮
					shared.runOnGLThread(new Runnable() {
						@Override
						public void run() {
							GameSystem.shareLinkCallback(1, "");
						}
					});
				}

			}
			@Override
			public void onDZResult(boolean b) {//点赞回调
				if( b)
				{
					//点赞成功后： 显示领取界面——>点击领取按钮
					shared.runOnGLThread(new Runnable() {
						@Override
						public void run() {
							GameSystem.dzCallback(1, "");
						}
					});
				}

			}
			@Override
			public void onBindResult(boolean b) {//绑定回调
				if( b)
				{
					//绑定成功回调后： 显示领取界面——>点击领取按钮

				}

			}
			@Override
			public void onBindAccountResult(boolean b) {
				//sdk登陆成功后，sdk会执行查询是否绑定手机或邮箱，在这里进行监听。（主要用于研发想知道，当前帐号绑定状态，根据这个状态来判断是否需要显示绑定按钮）
//				android.util.Log.i(TAG, " onBindAccountResult  b =" + b);

				if (b) {
					//已绑定

				} else {
					//未绑
				}
			}
			@Override
			public void onPayResult(int result) {
			}
		});
		/*****************************初始化结束********************************/
	}
		// <!--可以SDK start-->

	// sdk登录
	public void sdkLogin(View view){
		shared.is_logining = true;
		if (shared.is_init_finish) {
			shared.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					Lhwl_Platform.getInstance().fhwf_chooselogin(shared, true);
				}
			});
		} else {
			if (shared.time_login != null) {
				shared.time_login.cancel();
				shared.time_login = null;
			}



		}
	}

	@Override
	public boolean dispatchTouchEvent(MotionEvent ev) {
		if (currentLight == 10) {
			startSleepTask();
			return false;
		}

		startSleepTask();
		return super.dispatchTouchEvent(ev);
	}

	/**
	 * 获取亮度
	 */
	private float getLightness() {
		WindowManager.LayoutParams localLayoutParams = this.getWindow().getAttributes();
		return localLayoutParams.screenBrightness;
	}

	/**
	 * 设置亮度
	 */
	private void setLightness(int light) {
		currentLight = light;
		WindowManager.LayoutParams localLayoutParams = this.getWindow().getAttributes();
		localLayoutParams.screenBrightness = (light / 255.0F);
		this.getWindow().setAttributes(localLayoutParams);
	}


	/**
	 * 开启休眠任务
	 */
	public void startSleepTask() {
		setLightness((int)maxLight);
		stopSleepTask();
		lightHandler.postDelayed(sleepWindowTask, delayTime);
	}

	/**
	 * 结束休眠任务
	 */
	public void stopSleepTask() {
		if (sleepWindowTask != null) {
			lightHandler.removeCallbacks(sleepWindowTask);
		}
	}

	/**
	 * 休眠任务
	 */
	Runnable sleepWindowTask = new Runnable() {
		@Override
		public void run() {
			setLightness(10);
		}
	};



	//切换账号
	public void switchAccount(View view){

	}




	//分享
	public void share(View view){

	}

	//获取公众号
	public void publicAccount(View view){

	}

	//退出
	public void exitGame(View view){

	}
	// <!--可以SDK end-->

	public static class SystemProperties {
		public static String get(String key) {
			String value = "";
			Class<?> cls = null;
			try {
				cls = Class.forName("android.os.SystemProperties");
				Method hideMethod = cls.getMethod("get", String.class);
				Object object = cls.newInstance();
				value = (String) hideMethod.invoke(object, key);
			} catch (ClassNotFoundException e) {
				Log.e("error", "get error() ", e);
			} catch (NoSuchMethodException e) {
				Log.e("error", "get error() ", e);
			} catch (InstantiationException e) {
				Log.e("error", "get error() ", e);
			} catch (IllegalAccessException e) {
				Log.e("error", "get error() ", e);
			} catch (IllegalArgumentException e) {
				Log.e("error", "get error() ", e);
			} catch (InvocationTargetException e) {
				Log.e("error", "get error() ", e);
			}
			return value;
		}
	}
	public static int getNotchSize(Context context) {

		int height = 0;
		int[] ret = new int[]{0, 0};

		// 华为的不需要适配
		// 华为适配方案  http://developer.huawei.com/consumer/cn/devservice/doc/50114
		// int[0]值为刘海宽度 int[1]值为刘海高度。
//		try {
//
//			ClassLoader cl = context.getClassLoader();
//
//			Class HwNotchSizeUtil = cl.loadClass("com.huawei.android.util.HwNotchSizeUtil");
//
//			Method get = HwNotchSizeUtil.getMethod("getNotchSize");
//
//			ret = (int[]) get.invoke(HwNotchSizeUtil);
//
//		} catch (ClassNotFoundException e) {
//			Log.e("test", "getNotchSize ClassNotFoundException");
//		} catch (NoSuchMethodException e) {
//			Log.e("test", "getNotchSize NoSuchMethodException");
//		} catch (Exception e) {
//			Log.e("test", "getNotchSize Exception");
//		} finally {
//			height = ret[1];
//		}

		// 小米适配方案  https://dev.mi.com/console/doc/detail?pId=1293
		// 系统增加了 property ro.miui.notch，值为1时则是 Notch 屏手机。
//		SystemProperties.getInt("ro.miui.notch", 0) == 1;

//		SystemProperties.getInt("ro.miui.notch", 0);
		if (height == 0)
		{
			String is_has_notch = SystemProperties.get("ro.miui.notch");
			if (is_has_notch == "1")
			{
				int resourceId = context.getResources().getIdentifier("notch_height", "dimen", "android");
				if (resourceId > 0) {
					height = context.getResources().getDimensionPixelSize(resourceId);
				}
			}
		}


		// Oppo适配方案  https://open.oppomobile.com/service/message/detail?id=61876
		if (height == 0)
		{
			boolean is_has_notch = context.getPackageManager().hasSystemFeature("com.oppo.feature.screen.heteromorphism");
			if (is_has_notch) {
				String mProperty = "";
				mProperty = SystemProperties.get("ro.oppo.screen.heteromorphism");

				String[] sourceStrArray = mProperty.split(",");
				if (sourceStrArray.length >= 3) {
					try {
						ret[1] = Integer.parseInt(sourceStrArray[2]);
					} finally {
						height = ret[1];
					}
				}
			}
		}

		// Vivo适配方案 https://dev.vivo.com.cn/doc/document/info?id=103
		int NOTCH_IN_SCREEN_VOIO_MARK = 0x00000020;//是否有凹槽
		int ROUNDED_IN_SCREEN_VOIO_MARK = 0x00000008;//是否有圆角
		boolean is_has_notch = false;
		try {
			ClassLoader cl = context.getClassLoader();
			Class ftFeature = cl.loadClass("android.util.FtFeature");
			Method get = ftFeature.getMethod("isFeatureSupport", int.class);
			is_has_notch = Boolean.valueOf(get.invoke(ftFeature, NOTCH_IN_SCREEN_VOIO_MARK).toString());

		} catch (ClassNotFoundException e)
		{ Log.e("test", "hasNotchInScreen ClassNotFoundException"); }
		catch (NoSuchMethodException e)
		{ Log.e("test", "hasNotchInScreen NoSuchMethodException"); }
		catch (Exception e)
		{ Log.e("test", "hasNotchInScreen Exception"); }
		finally  {

		}

		if (is_has_notch) {
			// 没有函数可以获取高度
			height = 27;
		}

		return height;
	}


	@Override
	protected void onStart() {
		super.onStart();

		Log.i("cleck", "game activity on start . . .");

//		new Handler().postDelayed(new Runnable(){
//			public void run() {
//				if (shared == null || shared.mOrientationListener != null) {
//					return;
//				}
//
//				mOrientationListener = new OrientationEventListener(shared,
//						SensorManager.SENSOR_DELAY_NORMAL) {
//
//					@Override
//					public void onOrientationChanged(int orientation) {
//						if (orientation == OrientationEventListener.ORIENTATION_UNKNOWN) {
//							return;  //手机平放时，检测不到有效的角度
//						}
//
//						if (shared == null) {
//							return;
//						}
//
//						//可以根据不同角度检测处理，这里只检测四个角度的改变
//						if (orientation > 315 || orientation <= 45) { //0度
//							orientation = 1;
//						} else if (orientation > 45 && orientation <= 135) { //90度
//							orientation = 4;
//						} else if (orientation > 135 && orientation <= 225) { //180度
//							orientation = 2;
//						} else if (orientation > 225 && orientation <= 315) { //270度
//							orientation = 3;
//						} else {
////					orientation = getDeviceOrientation();
//							return;
//						}
//
//						if (shared.orientation != orientation && orientation > 0) {
//							shared.orientation = orientation;
////					shared.orientation
//							Log.v("debug", "Orientation changed to " + shared.orientation);
//
//							shared.runOnUiThread(new Runnable() {
//								@Override
//								public void  () {
//									GameSystem.orientationChange(shared.orientation);
//								}
//							});
//						}
//					}
//				};
//
//				if (mOrientationListener.canDetectOrientation()) {
//					Log.v("debug", "Can detect orientation");
//					mOrientationListener.enable();
//				} else {
//					Log.v("debug", "Cannot detect orientation");
//					mOrientationListener.disable();
//				}
//
//			}
//		}, (long) 1000);

//		Intent intent = new Intent(this, NotificationService.class);
//		startService(intent);
//
//		NotificationReceiver.background_running = false;
//
//		if (timer != null) {
//			timer.cancel();
//			timer = null;
//		}
//		timer = new Timer();
//		timer.schedule(new TimerTask() {
//			@Override
//			public void run() {
//				gamePluginList = null;
//				// if (gamePluginList == null || gamePluginList.length == 0) {
//				String tmp = GameSystem.getGamePluginList();
//				tmp = tmp.trim().toLowerCase();
//				if (!tmp.equals("")) {
//					gamePluginList = tmp.split(";");
//				}
//				// }
//
//				if (gamePluginList == null || gamePluginList.length == 0) {
//					return;
//				}
//
//				ArrayList<String> all_names = new ArrayList<String>();
//
//				// System.out.println("serv =====================");
//				// 检查Service状态
//				ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
//				for (RunningServiceInfo serv : manager
//						.getRunningServices(Integer.MAX_VALUE)) {
//					// System.out.println("serviceName: " + serv.clientPackage +
//					// ", " + serv.process + ", " +
//					// serv.service.getClassName());
//					all_names.add(serv.service.getClassName().toLowerCase());
//				}
//
//				// System.out.println("app =====================");
//				for (RunningAppProcessInfo app : manager
//						.getRunningAppProcesses()) {
//					// System.out.println("app processName: " +
//					// app.processName);
//					all_names.add(app.processName.toLowerCase());
//				}
//
//				// System.out.println("task =====================");
//				for (RunningTaskInfo task : manager
//						.getRunningTasks(Integer.MAX_VALUE)) {
//					if (task.baseActivity == null) {
//						continue;
//					}
//					// System.out.println("taskName: " +
//					// task.baseActivity.getPackageName());
//					all_names.add(task.baseActivity.getPackageName()
//							.toLowerCase());
//				}
//
//				for (String name : all_names) {
//					for (String key : gamePluginList) {
//						if (key.equals("")) {
//							continue;
//						}
//						if (name.contains(key)) {
//							// 发现有外挂，停止游戏
//							// System.out.println("stop game here");
//							timer.cancel();
//							timer = null;
//
//							GameSystem.exitGame();
//							return;
//						}
//					}
//				}
//			}
//		}, 5000, 5000);


	}

	@Override
	protected void onResume() {
		super.onResume();
		this.hideNavigationBar();

		Lhwl_Platform.getInstance().fhwf_OnResume(this);


		// 清空所有的通知
//		((NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE))
//				.cancelAll();
	}

	// <!--可以SDK start-->
	@Override
	protected void onRestart() {
		super.onRestart();
	}

	@Override
	protected void onPause() {
//		if (this.wakeLock != null) {
//			this.wakeLock.release();
//		}
		super.onPause();
		Lhwl_Platform.getInstance().fhwf_OnPause(this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		Lhwl_Platform.getInstance().fhwf_OnActivityResult(requestCode, resultCode, data);
	}

	// <!--可以SDK end-->

	@Override
	protected void onStop() {
//		NotificationReceiver.background_running = true;
//
//		if (timer != null) {
//			timer.cancel();
//			timer = null;
//		}

		super.onStop();

	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Lhwl_Platform.getInstance().fhwf_OnDestroy(this);
		if (mOrientationListener != null) {
			mOrientationListener.disable();
		}

	}

	@Override
	public void onRequestPermissionsResult(int requestCode,String[] permissions, int[] grantResults) {
		PermissionApply.getInstance().onRequestPermissionsResult(requestCode,permissions,grantResults);
		super.onRequestPermissionsResult(requestCode, permissions, grantResults);
		PermissionManager.getInstance().onRequestPermissionsResult(requestCode, permissions, grantResults);
	}


	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
		Log.d("debug","hasFocus = " + hasFocus);

		if (shared != null) {
			shared.setLightness((int)maxLight);
			shared.stopSleepTask();
		}

		if (hasFocus){
			hideNavigationBar();

			if (shared != null) {
				shared.startSleepTask();
			}
		}

	    super.onWindowFocusChanged(hasFocus);

	}



	public static void hideNavigationBarNow() {
		//隐藏虚拟按键，并且全屏
		int nViewFlag =  View.SYSTEM_UI_FLAG_LAYOUT_STABLE
				| View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
				| View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
				| View.SYSTEM_UI_FLAG_HIDE_NAVIGATION 	// hide nav bar
				| View.SYSTEM_UI_FLAG_FULLSCREEN 		// hide status bar
				| View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
			viewGroup.setSystemUiVisibility(nViewFlag);
		}
//		AndroidBug5497Workaround.assistActivity(shared);
	}

	public static void hideNavigationBar() {
//    	Log.d("debug", "hideNavigationBar");
		hideNavigationBarNow();
		new Handler().postDelayed(new Runnable(){
			public void run() {
				hideNavigationBarNow();
			}
		}, (long) 10);

		//隐藏虚拟按键，并且全屏
//        if (Build.VERSION.SDK_INT > 11 && Build.VERSION.SDK_INT < 19) { // lower api
//            viewGroup.setSystemUiVisibility(View.GONE);
//        } else if (Build.VERSION.SDK_INT >= 19) {
//            //for new api versions.
//			int uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
//							View.SYSTEM_UI_FLAG_FULLSCREEN;
//
////            int uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
////            				View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY |
////            				View.SYSTEM_UI_FLAG_FULLSCREEN;
//            viewGroup.setSystemUiVisibility(uiOptions);
//        }

//		int nViewFlag =  View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//				| View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//				| View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
//				| View.SYSTEM_UI_FLAG_HIDE_NAVIGATION // hide nav bar
//				| View.SYSTEM_UI_FLAG_FULLSCREEN // hide status bar
//				| View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;
//
//		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
//			viewGroup.setSystemUiVisibility(nViewFlag);
//		}

        // InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
        // boolean isOpen=imm.isActive();//isOpen若返回true，则表示输入法打开

	}

	public Cocos2dxGLSurfaceView onCreateView() {
		Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);
		// Empire should create stencil buffer
//		glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8);
		glSurfaceView.setEGLConfigChooser(8, 8, 8, 8, 16, 8);
		glSurfaceView.getHolder().setFormat(PixelFormat.TRANSLUCENT);

		return glSurfaceView;
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		Log.d("debug", "on key event . . .");
		if (keyCode == KeyEvent.KEYCODE_BACK) {

			return true;
		}

		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);

//		Log.d("debug", "onConfigurationChanged");
//		int orientation = getDeviceOrientation();
//		GameSystem.orientationChange(orientation);
	}

	// MessageBox回调用
	private static Handler mMsgHandler = new Handler(new Handler.Callback() {
		@Override
		public boolean handleMessage(Message msg) {
			AlertDialog mDialog = new AlertDialog.Builder(shared).create();
			mDialog.setCancelable(false);

			Object[] args = (Object[]) msg.obj;

			final int msg_box_address = 0; //(Integer) args[0];

			if ((String) args[1] == "" || (String) args[2] == "" || (String) args[3] == "") {
				mDialog.setTitle("连接错误");
				mDialog.setMessage("与服务器失去连接，请查看您的网络连接后再次连接。");
				mDialog.setButton(DialogInterface.BUTTON_POSITIVE, "重试",
						new AlertDialog.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog, int which) {

								shared.runOnGLThread(new Runnable() {
									@Override
									public void run() {
										GameSystem.dialogCallBack(msg_box_address, 0);
									}
								});

								if (shared != null){
									shared.hideNavigationBar();
								}
							}
						});
			} else {
				mDialog.setTitle((String) args[1]);
				mDialog.setMessage((String) args[2]);
				mDialog.setButton(DialogInterface.BUTTON_POSITIVE, (String) args[3],
						new AlertDialog.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog, int which) {

								shared.runOnGLThread(new Runnable() {
									@Override
									public void run() {
										GameSystem.dialogCallBack(msg_box_address, 0);
									}
								});


								if (shared != null){
									shared.hideNavigationBar();
								}
							}
						});
			}

			if (args[4] != null) {
				mDialog.setButton(DialogInterface.BUTTON_NEGATIVE, (String) args[4],
						new AlertDialog.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog,
									int which) {

								shared.runOnGLThread(new Runnable() {
									@Override
									public void run() {
										GameSystem.dialogCallBack(msg_box_address, 1);
									}
								});

								if (shared != null){
									shared.hideNavigationBar();
								}
							}
						});
			}
			// Cocos2dxEditBoxDialog.cancelInput();
			mDialog.show();
			return true;
		}
	});

	public static void messageBox(int msg_box_address, String title,
			String content, String button_str0, String button_str1) {
		Object[] args = new Object[5];
		args[0] = msg_box_address;
		args[1] = title;
		args[2] = content;
		args[3] = button_str0;
		args[4] = button_str1;

		Message mes = new Message();
		mes.obj = args;
		mMsgHandler.sendMessage(mes);
	}

	public static void openUrl(final String url) {
		if (shared == null) {
			return;
		}

		if (url.equals("")) {
			return;
		}

		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					Intent intent = new Intent(Intent.ACTION_VIEW, Uri
							.parse(url));
					// intent.setClassName("com.android.browser",
					// "com.android.browser.BrowserActivity"); //
					// 这是指定打开的浏览器应用，我们这里不能指定
					shared.startActivity(intent);

				} catch (Exception e) {
					Toast.makeText(shared.getApplicationContext(),
							"Can not open the browser.", Toast.LENGTH_SHORT)
							.show();
					e.printStackTrace();
				}
			}
		});
	}


	public static void setClipboard(final String text) {
		if (shared == null) {
			return;
		}

		if (text.equals("")) {
			return;
		}

		try
        {
            //Log.d("cocos2dx","copyToClipboard " + text);
            Runnable runnable = new Runnable() {
                public void run() {
                    android.content.ClipboardManager clipboard = (android.content.ClipboardManager) shared.getContext().getSystemService(Context.CLIPBOARD_SERVICE);
                    android.content.ClipData clip = android.content.ClipData.newPlainText("Copied Text", text);
                    clipboard.setPrimaryClip(clip);
                }
            };
            //getSystemService运行所在线程必须执行过Looper.prepare()
            //否则会出现Can't create handler inside thread that has not called Looper.prepare()
			shared.runOnUiThread(runnable);

        }catch(Exception e){
           // Log.d("cocos2dx","copyToClipboard error");
            e.printStackTrace();
            // return -1;
        }
	}

	public static String getDeviceUUID() {
		SharedPreferences sp = getContext().getApplicationContext()
				.getSharedPreferences("MEAccount", Context.MODE_PRIVATE);
		String strUUID = sp.getString("DeviceUUID", null);
		if (strUUID == null) {
			strUUID = makeDeviceUUID();

			Editor editor = sp.edit();
			editor.putString("DeviceUUID", strUUID);
			editor.commit();
		}
		return strUUID;
	}

	public static String updateDeviceUUID() {
		SharedPreferences sp = getContext().getApplicationContext()
				.getSharedPreferences("MEAccount", Context.MODE_PRIVATE);
		String strUUID = UUID.randomUUID().toString();
		Editor editor = sp.edit();
		editor.putString("DeviceUUID", strUUID);
		editor.commit();
		return strUUID;
	}

	private static String makeDeviceUUID() {
		// final TelephonyManager tm = (TelephonyManager)
		// shared.getApplicationContext().getSystemService(Context.TELEPHONY_SERVICE);
		// String tmDevice = tm.getDeviceId();
		// if (tmDevice == null) {
		// tmDevice = "";
		// }
		// String tmSerial = tm.getSimSerialNumber();
		// if (tmSerial == null) {
		// tmSerial = "";
		// }

		String androidId = Secure.getString(getContext().getContentResolver(),
				Secure.ANDROID_ID);
		if (androidId == null) {
			// 设备没有设置google账号，生成随机uuid
			return UUID.randomUUID().toString();
		} else {
			// 使用设备的google账号生成uuid
			return UUID.nameUUIDFromBytes(androidId.getBytes()).toString();
		}
	}

	public static String getVersion() {
		try {
			PackageManager manager = getContext().getPackageManager();
			PackageInfo info = manager.getPackageInfo(getContext()
					.getPackageName(), 0);
			String version = info.versionName;
			return version;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	public static boolean isInstallOnSDCard(String packageName) {
		PackageManager pm = getContext().getPackageManager();
		ApplicationInfo appInfo;
		try {
		appInfo = pm.getApplicationInfo(packageName, 0);

		if ((appInfo.flags & ApplicationInfo.FLAG_EXTERNAL_STORAGE) != 0) {
		return true;
		}
		} catch (NameNotFoundException e) {
		e.printStackTrace();
		}
		return false;
	}
	public static double getFreeDiskSpace() {
		double space = -1;

		if (isInstallOnSDCard(getContext().getPackageName())) {
			String state = Environment.getExternalStorageState();
			if (Environment.MEDIA_MOUNTED.equals(state)) {
				File sdcardDir = Environment.getExternalStorageDirectory();
//				StatFs sf = new StatFs(sdcardDir.getPath());
//				long blockSize = sf.getBlockSize();
//				long availCount = sf.getAvailableBlocks();
//				space = availCount * availCount;
				space = sdcardDir.getFreeSpace();
			}
		}
		else {
			File dataDir = Environment.getDataDirectory();
//	        StatFs stat = new StatFs(dataDir.getPath());
//	        long blockSize = stat.getBlockSize();
//	        long availableBlocks = stat.getAvailableBlocks();
	        space = dataDir.getFreeSpace();
		}

		return space;
	}

	public static int getNotchHeight() {
		if (shared == null) {
			return 0;
		}

		if (shared.notch_height < 0) {
			shared.notch_height = getNotchSize(shared.getContext());
		}

		return shared.notch_height;
	}

	public static int getDeviceOrientation() {
		if (shared == null) {
			return 0;
		}
		/**
		 * 获取当前屏幕旋转角度
		 *
		 * @return 0表示是竖屏; 90表示是左横屏; 180表示是反向竖屏; 270表示是右横屏
		 */

		int rotation = shared.getWindowManager().getDefaultDisplay()
				.getRotation();
		switch (rotation) {
			case Surface.ROTATION_0:
				return 1;
			case Surface.ROTATION_90:
				return 3;
			case Surface.ROTATION_180:
				return 2;
			case Surface.ROTATION_270:
				return 4;
		}
		return 0;
	}

	@SuppressLint("SetJavaScriptEnabled")
	public static void webViewShow(final String web_url, final int width,
			final int height) {
		if (shared == null) {
			return;
		}

		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				if (web_view == null) {
					web_view = new WebView(shared);

					web_view.getSettings().setJavaScriptEnabled(true);

					// 不让他横向拖动
					web_view.setHorizontalScrollBarEnabled(false);

					// 设置网页背景颜色透明
					// web_view.setBackgroundColor(0);

					// 把webView加入到线性布局
					RelativeLayout webParent = new RelativeLayout(shared);
					RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
							LayoutParams.MATCH_PARENT,
							LayoutParams.MATCH_PARENT);
					webParent.setLayoutParams(layoutParams);
					webParent.addView(web_view);
					viewGroup.addView(webParent);
					// shared.getWindow().setContentView(webParent);

					// 当前网页的链接仍在webView中跳转
					web_view.setWebViewClient(new WebViewClient() {
						@Override
						public boolean shouldOverrideUrlLoading(WebView view,
								String url) {
							view.loadUrl(url);
							return true;
						}
					});
				}

				RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
						width, height);
				params.addRule(RelativeLayout.CENTER_IN_PARENT);
				web_view.setLayoutParams(params);
				web_view.loadUrl(web_url);
			}
		});
	}

	public static void webViewClose() {
		if (shared == null) {
			return;
		}

		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
			if (web_view != null) {
					RelativeLayout parent = (RelativeLayout) web_view
							.getParent();
					parent.removeAllViews();
					viewGroup.removeView(parent);
					web_view = null;
				}
			}
		});
	}

	// 获取指定文件夹下的文件路径列表
	@SuppressWarnings("unused")
	private static void list(File parent_folder, Vector<String> files, int deep) {
		if (deep >= 4) {
			return;
		}
		File[] sub_items = parent_folder.listFiles();
		System.out.println("deep : " + deep + " list file start : "
				+ parent_folder.getAbsolutePath());
		if (sub_items == null) {
			return;
		}
		for (File file : sub_items) {
			if (file.isFile()) {
				files.add(file.getAbsolutePath());
			} else {
				list(file, files, deep + 1);
			}
		}
		// System.out.println("list file end : " +
		// parent_folder.getAbsolutePath());
	}

	public static String getExternalStorageDirectory() {
		Context context = getContext();
//		ApplicationInfo ai = null;
//		try {
//			ai = context.getPackageManager().getApplicationInfo(
//
//			        context.getPackageName(), PackageManager.GET_META_DATA);
//	        Object value = ai.metaData.get("CHANNEL");
//	        System.out.println("channel id : " + value.toString());
//		} catch (NameNotFoundException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

		String path = null;

		if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())) {
			path = Environment.getExternalStorageDirectory().getAbsolutePath();
		} else {
			path = context.getFilesDir().getAbsolutePath();
		}

		if (path == null) {
			return "";
		}

		if (!path.endsWith("/")) {
			path += "/";
		}
		return path;
	}

	public static void deleteFileWithPath(String file_path) {
		File file = new File(file_path);
		System.out.println("delete file with file path : " + file_path);
		if (file.exists()) {
			System.out.println("delete file with file path success . . .");
			file.delete();
		}
	}

	public static void deleteFileInStorageDirectory(String file_name) {
		File file = new File(Environment.getExternalStorageDirectory()
				+ "/" + file_name);
		System.out.println("delete file with file name : " + file_name
				+ ", path is : " + Environment.getExternalStorageDirectory()
				+ "/" + file_name);
		if (file.exists()) {
			System.out.println("delete file with file path success . . .");
			file.delete();
		}
	}

	public static void exitTheGame() {
		if (shared != null) {
			shared.finish();
			System.exit(0);
		}
	}

	public static void initPlatform() {

//		Looper.prepare();
//
//		new Handler().postDelayed(new Runnable(){
//			public void run() {
//				if (shared == null) {
//					return;
//				}
//				shared.init(viewGroup);
//			}
//		}, (long) 10);
//
//		Looper.loop();

		if (shared == null) {
			return;
		}
		shared.sdkLogin(viewGroup);
	}

	public static void logout() {
		if (shared == null) {
			return;
		}
		Log.i("MainActivity", "logout");
		shared.is_logouting = true;
		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Lhwl_Platform.getInstance().fhwf_Logout(shared);
			}
		});
	}

	public static void pay(final String productId, final String billNo, final String extraInfo) {
		if (shared == null) {
			return;
		}

		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Lhwl_PayParams params = new Lhwl_PayParams ();//
				params.setServerId(shared.server_id);//区服id
				params.setServerName(shared.server_name);//区服名称
				params.setRoleId(shared.role_id);//角色ID
				params.setRoleName(shared.role_name);//角色昵称
				params.setRoleLevel(shared.role_level);//角色等级
				params.setPruductId(productId);//内购，必填 产品id
				params.setCpOrderId(billNo);//cp自定义订单号
				params.setExt1(extraInfo);//扩展参数1
				params.setExt2("");//扩展参数2
				params.setExt3("");//扩展参数3
				Lhwl_Platform.getInstance().fhwf_Pay(shared, params);
			}
		});

		//充值0.01
//		public void payWithOneFen(View view){
//			Lgame.payment(AppActivity.this, getPaymentInfo("com.ceshi.001rmb"));
//		}
//		//充值1
//		public void payWithOneYuan(View view){
//			Lgame.payment(AppActivity.this,  getPaymentInfo("com.ceshi.1rmb"));
//		}
	}

	public String getActivityInfoEx(String param1) {
		String value = "";
		String str = null;
		try{
//            ApplicationInfo mapplicationInfo = this.getApplicationContext().getApplicationInfo();//方法失败
//            ApplicationInfo mapplicationInfo = this.getBaseContext().getApplicationInfo();//方法依然失败

			ApplicationInfo mapplicationInfo = this.getPackageManager().getApplicationInfo(
					this.getPackageName(), PackageManager.GET_META_DATA);
			if (mapplicationInfo.metaData != null) {
				Object valueO = mapplicationInfo.metaData.get(param1);
				if (valueO != null) {
					value = valueO.toString();
				}
			}
		} catch (NullPointerException e) {
			Log.e("crsh:","报空指针异常");
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return value;
	}

	public static String getFuseAgent(String param1) {
		if (shared == null) {
			return "";
		}
		// return "1";
		return shared.getActivityInfoEx(param1);

	}

	public static Lhwl_UserExtraData getSubmitRoleInfo(int type) {
		String str_default = "暂时没能获取";
		String str_server_id = shared.server_id;
		String str_server_name = shared.server_name;
		String str_role_id = shared.role_id;
		String str_role_name = shared.role_name;
		String str_role_level = shared.role_level;
		String str_balance = shared.balance;
		int balance = 0;
		int role_level = 0;
		int server_id = 0;
		Log.d("debug", "getSubmitRoleInfo");
		try {
			if (str_server_id != "") server_id = Integer.valueOf(str_server_id).intValue();
			if (str_server_name == "") str_server_name = str_default;
			if (str_role_id == "") str_role_id = str_default;
			if (str_role_name == "") str_role_name = str_default;
			if (str_role_level != "") role_level = Integer.valueOf(str_role_level).intValue();
			if (str_balance != "") balance = Integer.valueOf(str_balance).intValue();
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}


		Log.d("debug", "1");

		Lhwl_UserExtraData extraData = new Lhwl_UserExtraData();
		extraData.setDataType(type); //上报时机，共有五个，详见文档3.7
		extraData.setServerId(server_id);	//服务器id,没能获取时传"暂时没能获取",不能不传或null
		extraData.setServerName(str_server_name);//服务器名称,没能获取时传"暂时没能获取",不能不传或null
		extraData.setRoleId(str_role_id);//角色id,没能获取时传"暂时没能获取",不能不传或null
		extraData.setRoleName(str_role_name);//角色名称,没能获取时传"暂时没能获取",不能不传或null
		extraData.setRoleLevel(role_level);//角色等级,没能获取时传"暂时没能获取",不能不传或null
		extraData.setMoneyNum(balance);//玩家身上的钱,没能获取时传0,不能不传
		Log.d("debug", "2");
		return extraData;
	}

	public static void submitRoleInfo(final String type) {
		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				if (shared == null || shared.user_code.length() <= 0 || type.length() <= 0) {
					return;
				}

				Log.d("debug", "submitRoleInfo . . ." + type);
				if (type.equals("create_role")) {
					Lhwl_Platform.getInstance().fhwf_SubmitExtendData(getSubmitRoleInfo(2));
				} else if (type.equals("enter_game")) {
					Lhwl_Platform.getInstance().fhwf_SubmitExtendData(getSubmitRoleInfo(3));
				} else if (type.equals("level_up")) {
					Lhwl_Platform.getInstance().fhwf_SubmitExtendData(getSubmitRoleInfo(4));
				} else if (type.equals("guide_num")) {
				} else if (type.equals("select_server")) {
					Lhwl_Platform.getInstance().fhwf_SubmitExtendData(getSubmitRoleInfo(1));
				} else if (type.equals("exit_game")) {
					Lhwl_Platform.getInstance().fhwf_SubmitExtendData(getSubmitRoleInfo(5));
				} else if (type.equals("vip_uplevel")) {
					Lhwl_Platform.getInstance().fhwf_SubmitExtendData(getSubmitRoleInfo(6));
				} else if (type.equals("join_clan")) {
					Lhwl_Platform.getInstance().fhwf_SubmitExtendData(getSubmitRoleInfo(7));
				}
				Log.d("debug", "submitRoleInfo end");
			}
		});
	}

	public static void submitRoleInfoType(final String type) {
		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				if (shared == null || shared.user_code.length() <= 0 || type.length() <= 0) {
					return;
				}

				int type_value = 0;
				try {
					type_value = Integer.valueOf(type).intValue();
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}

				if (type_value != 0) {
					Lhwl_Platform.getInstance().fhwf_SubmitExtendData(getSubmitRoleInfo(type_value));
				}
			}
		});
	}

	public static void updateExtraData(String guide_num,
									   String role_id,
									   String role_create_time,
									   String role_name,
									   String role_level,
									   String server_id,
									   String server_name,
									   String balance,
									   String vip_level,
									   String gem_num,
									   String attack_num,
									   String extra_info,
									   String clan_name) {
		if (shared == null) {
			return;
		}

		shared.guide_num = guide_num;
		shared.role_id = role_id;
		shared.role_create_time = role_create_time;
		shared.role_name = role_name;
		shared.role_level = role_level;
		shared.server_id = server_id;
		shared.server_name = server_name;
		shared.balance = balance;
		shared.vip_level = vip_level;
		shared.gem_num = gem_num;
		shared.attack_num = attack_num;
		shared.extra_info = extra_info;
		shared.clan_name = clan_name;
	}

	public static String getXingeToken() {
		return shared.xinge_token;
	}


	public static void showUserCenter() {
		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Lhwl_Platform.getInstance().fhwf_showUserCenter(shared);
			}
		});
	}

	public static void showCustomerService() {
		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Lhwl_Platform.getInstance().fhwf_showCustomerService(shared);
			}
		});
	}

	public static void shareLink() {
		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Lhwl_Platform.getInstance().fhwf_FBsharelink (shared);
			}
		});
	}

	public static void dz() {
		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Lhwl_Platform.getInstance().fhwf_dz (shared);
			}
		});
	}

	public static void zhuXiao() {

	}

	public static void discuss() {
		shared.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				 Lhwl_Platform.getInstance().fhwf_openGpShop(shared);
			}
		});
	}

//	public static int isQQInstalled() {
//		//ArrayList<AppInfo> appList = new ArrayList<AppInfo>();
//		List<PackageInfo> packages = getContext().getPackageManager().getInstalledPackages(0); 
//		for(int i=0;i<packages.size();i++) { 
//				PackageInfo packageInfo = packages.get(i); 
//				//AppInfo tmpInfo = new AppInfo(); 
////				String appname = packageInfo.applicationInfo.loadLabel(getContext().getPackageManager()).toString();
////				System.out.println("%%%%%%%%%$$$$ appname = " + appname);
//				String packagename = packageInfo.packageName; 
//				//System.out.println("%%%%%%%%%$$$$ appname = " + packagename);
//				if( packagename.equals("com.tencent.mobileqq")) {
//					return 1;
//				}
//				
//		}
//		
//		return 0;
//	}
}
