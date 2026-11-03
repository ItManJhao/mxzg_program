package com.ayjs.mxzg.gameserver.web.constant;

/**
 * web错误码
 */
public enum WebErrorCode {

    //    UNKNOWN_ERROR(-1, "未知错误"),
    SUCCESS(200, "成功"),
//    SDK_LOGIN_ERROR(10000, "SDK登录验证错误"),
//    PARAMS_ERROR(10001, "参数缺省"),
//    NOT_SERVER(10002, "没有可用服务器"),
//    SERVER_ERROR(10003, "服务器有误"),
//    USER_NOT_EXISTS(10004, "玩家不存在"),
//    USER_LOCKED(10005, "玩家被锁定"),
//    CHANNEL_LIMITED(10006, "限制注册"),
//    RID_ERROR(10007, "角色ID有误"),
//    ROLE_NOT_IN_FORBID_TIME(10008, "角色不在封禁时间段内"),
//    SIGNATURE_VERIFY_FAILED(10009, "签名校验失败"),
//
//    CDKEY_IS_NOT_EXISTS(11028, "兑换码不存在"),
//    CDKEY_IS_USED(11029, "兑换码已使用"),
//    CDKEY_IS_NOT_ALLOW_USE(11030, "还没到开始使用时间"),
//    CDKEY_IS_EXPIRE(11031, "兑换码已过期"),
//    CDKEY_IS_LIMITED(11032, "兑换码使用次数受限"),
//    CDKEY_INVALID(11034, "兑换码渠道限制"),
//    SUCCESS(0, null),
    FAIL(1, null),
    EXCEPTION(2, null),
    
    ORDER_GAVE(-11, "充值订单已发货"),
    ;

    private final int code;
    private final String desc;

    public int getCode() {
        return code;
    }

    public String getCodeStr() {
        return String.valueOf(code);
    }

    public String getDesc() {
        return desc;
    }

    WebErrorCode(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }
}
