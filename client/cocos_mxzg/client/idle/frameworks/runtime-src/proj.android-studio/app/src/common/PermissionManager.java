package common;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

import common.PermissionData;



public class PermissionManager {
    // 按钮位置， 拒绝显示为 positiveText ，允许显示为negativeText，因为提示框的位置和需求是相反的。
    // 左边是拒绝，右边是返回
    public static String positiveText = "允許"; // 允许
    public static String negativeText = "拒絕"; // 拒绝
    public static String titleText = "提示";    // 提示
    public static String comeBackText = "返回"; // 返回
    public static String settingText = "設置"; // 设置
    public static String exitGameText = "退出遊戲"; // 退出游戏


    public AppActivity mainView = null;
    private static PermissionManager instance;

    // 需要请求的权限列表
    List<PermissionData> requestList;

    //构造器私有化
    private PermissionManager(){
        this.requestList = new ArrayList<>();
    }

    public static synchronized PermissionManager getInstance(){
        if(instance == null){
            instance = new PermissionManager();
        }
        return instance;
    }

    // 必须要设置主界面
    public void setMainView(AppActivity view) {
        this.mainView = view;
    }


    public PermissionData getPermissionData(String permission) {
        for (int i = 0; i < this.requestList.size(); i++) {
            PermissionData data = this.requestList.get(i);
            Log.e("log", "getPermissionData   " + data.permissionType + "   " + permission);
            if (data.permissionType.equals(permission)) {
                return data;
            }
        }
        return null;
    }

    public void setPermissionData(PermissionData data) {
        PermissionData oldData = this.getPermissionData(data.permissionType);
        if (oldData != null)
        {
            oldData.permissionExplain = data.permissionExplain;
            oldData.permissionType = data.permissionType;
            oldData.permissionStatus = data.permissionStatus;
            oldData.isGranted = data.isGranted;
            oldData.isMust = data.isMust;
            oldData.exitTip = data.exitTip;
            oldData.requestCount = data.requestCount;
        }
        else
        {
            this.addPermissionData(data.permissionType,  data.permissionExplain, data.exitTip, data.isMust, data.isGranted, data.permissionStatus, data.requestCount);
        }
    }

    // 添加权限数据
    public PermissionData addPermissionData(String permissionType, String permissionExplain, String exitTip, boolean isMust) {

        PermissionData data = new PermissionData();
        data.permissionType = permissionType;
        data.permissionExplain = permissionExplain;
        data.exitTip = exitTip;
        data.isMust = isMust;
        this.requestList.add(data);

        return data;
    }

    // 添加权限数据
    public PermissionData addPermissionData(String permissionType, String permissionExplain, String exitTip, boolean isMust, boolean isGranted, int permissionStatus, int requestCount) {

        PermissionData data = new PermissionData();
        data.permissionType = permissionType;
        data.permissionExplain = permissionExplain;
        data.isGranted = isGranted;
        data.exitTip = exitTip;
        data.isMust = isMust;
        data.permissionStatus = permissionStatus;
        data.requestCount = requestCount;
        this.requestList.add(data);

        return data;
    }

    public void finishPermission(String permissionType) {
        for (int i = 0; i < this.requestList.size(); i++) {
            PermissionData data = this.requestList.get(i);
            if (data.permissionType.equals(permissionType)) {
                this.requestList.remove(data);
                break;
            }
        }
    }

    // 开始请求权限
    protected void requestRunTimePermission(){
//        this.mlistener = listener;
        if (this.mainView == null) {
            Log.e("error", "PermissionManager is null");
            return;
        }

        // 用于存放为授权的权限
        // 遍历传递过来的权限集合
        for (PermissionData permission : requestList) {
            // 判断是否已经授权
            if (ContextCompat.checkSelfPermission(this.mainView, permission.permissionType) != PackageManager.PERMISSION_GRANTED){
                // 逐条请求权限
                List<String> tmpPermissionList = new ArrayList<>();
                tmpPermissionList.add(permission.permissionType);
                ActivityCompat.requestPermissions(this.mainView, tmpPermissionList.toArray(new String[tmpPermissionList.size()]),1);
            }
        }
    }

    // 请求权限结果
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
//        Toast.makeText(mainView.getApplicationContext(),
//                Integer.toString(requestCode) + permissions + grantResults, Toast.LENGTH_SHORT).show();

        switch (requestCode) {
            case 1:
                    for (int i = 0; i < grantResults.length; i++) {
                        //获取授权结果，这是一个int类型的值
                        int grantResult = grantResults[i];
                        if (grantResult == PackageManager.PERMISSION_DENIED){
                            final PermissionData data = this.getPermissionData(permissions[i]);
                            Log.e("log", "PermissionData data =" + permissions[i]);
                            if (data == null) {
                                Log.e("log", "data == null" + permissions[i]);
                                break;
                            }
                            // 用户拒绝授权的权限
                            // 判断用户是否选择 “不再提示” 选项，在这种情况下需要引导用户至设置也手动授权
                            if (!ActivityCompat.shouldShowRequestPermissionRationale(this.mainView, data.permissionType)) {
                                Log.e("log", "data.isMust" + data.isMust);
                                // 不是必须的权限
                                if (!data.isMust) {
                                    break;
                                }

//                                StringBuilder permissionName = new StringBuilder();
//                                for (String s : permissions) {
//                                    permissionName = permissionName.append(s + "\r\n");
//                                }

                                AlertDialog.Builder dialog = new AlertDialog.Builder(this.mainView);
                                dialog.setCancelable(false);
                                dialog.setTitle(PermissionManager.titleText) // 设置对话框标题
                                        .setMessage(data.permissionExplain)//设置显示的内容
                                        .setPositiveButton(PermissionManager.negativeText, new DialogInterface.OnClickListener() {//添加确定按钮
                                            @Override
                                            public void onClick(DialogInterface dialog, int which) {//确定按钮的响应事件
                                                // 点击取消授权
                                                PermissionManager.getInstance().showExitGameTip(data.permissionType);
                                                dialog.dismiss();
                                            }
                                        })
                                        .setNegativeButton(PermissionManager.settingText, new DialogInterface.OnClickListener() {//添加返回按钮
                                        @Override
                                        public void onClick(DialogInterface dialog, int which) {//响应事件
                                            // 打开应用权限设置中心
                                            PermissionManager permissionManager = PermissionManager.getInstance();
                                            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                                            Uri uri = Uri.fromParts("package", permissionManager.mainView.getApplicationContext().getPackageName(), null);
                                            intent.setData(uri);
                                            permissionManager.mainView.startActivity(intent);
                                            dialog.dismiss();
                                        }})
                                       .show(); //在按键响应事件中显示此对话框
                            } else {
                                this.showPermissionsAgain(data.permissionType);
                            }
                        } else {
                            PermissionManager.getInstance().finishPermission(permissions[i]);
                            PermissionManager.getInstance().requestRunTimePermission();
                        }
                    }
                break;
            default:
                break;
        }
    }

    public void showPermissionsAgain(String permissionType) {
        Log.e("log", "showPermissionsAgain");
        // 跟玩家解释一下为什么需要这个权限
        final PermissionData data = this.getPermissionData(permissionType);
        if (data == null)
        {
            return;
        }
        AlertDialog.Builder dialog = new AlertDialog.Builder(this.mainView);
        dialog.setCancelable(false);
        dialog.setTitle(PermissionManager.titleText)//设置对话框标题
                .setMessage(data.permissionExplain) // 设置显示的内容
                .setPositiveButton(PermissionManager.negativeText, new DialogInterface.OnClickListener() {//添加确定按钮
                    @Override
                    public void onClick(DialogInterface dialog, int which) {//确定按钮的响应事件
                        // 如果不是必要的权限，不需要退出游戏
                        if (data.isMust == true) {
                            PermissionManager.getInstance().showExitGameTip(data.permissionType);
                        } else {
                            PermissionManager.getInstance().finishPermission(data.permissionType);
                            PermissionManager.getInstance().requestRunTimePermission();
                        }
                    }
                }).setNegativeButton(PermissionManager.comeBackText, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    // 重新请求权限
                    PermissionManager.getInstance().requestRunTimePermission();
                }
        }).show();// 在按键响应事件中显示此对话框
    }

    public void showExitGameTip(String permissionType) {

        PermissionData data = this.getPermissionData(permissionType);
        if (data == null) {
            return;
        }

        AlertDialog.Builder dialog = new AlertDialog.Builder(this.mainView);
        dialog.setCancelable(false);
        dialog.setTitle(PermissionManager.titleText)// 设置对话框标题
                .setMessage(data.exitTip) // 设置显示的内容
                .setPositiveButton(PermissionManager.exitGameText, new DialogInterface.OnClickListener() { // 添加确定按钮
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        // 确定按钮的响应事件
                        System.exit(0);
                    }
                }).show(); // 在按键响应事件中显示此对话框
    }
}
