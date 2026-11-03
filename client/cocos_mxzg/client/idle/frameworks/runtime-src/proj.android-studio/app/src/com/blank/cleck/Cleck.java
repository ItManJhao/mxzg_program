/****************************************************************************
Copyright (c) 2010-2011 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package com.blank.cleck;

import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;

import common.AppActivity;
// import com.OkFramework.common.LApplication;

public class Cleck extends AppActivity {
    
//	static {
//		System.loadLibrary("NativeRQD"); // 游戏需要加载此动态库, 数据上报用
//	}

	public static String LOG_TAG = "cleck";

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
		Log.i(LOG_TAG, "onConfigurationChanged");
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.i(LOG_TAG, "onCreate");
	}
	
	@Override
	protected void onStart() {
		super.onStart();
		Log.i(LOG_TAG, "onStart");
	}

	@Override
	protected void onStop() {
		Log.i(LOG_TAG, "onStop");

		super.onStop();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.i(LOG_TAG, "onDestroy");
	}

	@Override
	protected void onPause() {
		super.onPause();
		Log.i(LOG_TAG, "onPause");
	}

	@Override
	protected void onResume() {
		super.onResume();
		Log.i(LOG_TAG, "onResume");
	}
}
