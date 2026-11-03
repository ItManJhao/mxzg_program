package common;

public class PermissionData {

    final int PERMISSION_NOTCHECK = -1;
    final int PERMISSION_DENIED_NO_ASK = 0;
    final int PERMISSION_DENIED = 1;
    final int PERMISSION_GRANTED = 2;

    // 是否已经通过授权
    boolean isGranted = false;

    // 是否是必要的权限
    boolean isMust = false;

    // 申请次数
    int requestCount = 0;

    // 权限类型
    String permissionType = "";

    // 权限解释
    String permissionExplain = "";

    // 退出提示
    String exitTip = "";

    // -1 ： 未执行任何操作。 0 ：用户拒绝授权且不再提示  1 ：用户拒绝授权  2 ：授权通过
    int permissionStatus = -1;
}
