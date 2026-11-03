package com.ayjs.mxzg.cross.web.support;

/**
 * http返回
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
public class WebResult {
    private int code;
    private String desc;
    private String msg;

    public static WebResult of(int code, String desc) {
        return of(code, desc, "");
    }

    public static WebResult of(int code, String desc, String msg) {
        WebResult result = new WebResult();
        result.code = code;
        result.desc = desc;
        result.msg = msg;
        return result;
    }

}
