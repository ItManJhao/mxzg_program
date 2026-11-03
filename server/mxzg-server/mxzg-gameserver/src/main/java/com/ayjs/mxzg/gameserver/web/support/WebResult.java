package com.ayjs.mxzg.gameserver.web.support;

import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * http返回
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
//@Value(staticConstructor = "of")
@Getter
@Setter
public class WebResult {
    private int code;
    private String desc;
    private String msg;


    public static WebResult of(int code, String desc) {
        WebResult res = new WebResult();
        res.code = code;
        res.desc = desc;
        res.msg = desc;
        return res;
    }

    public static WebResult of(int code, String desc, String msg) {
        WebResult res = new WebResult();
        res.code = code;
        res.desc = desc;
        res.msg = msg;
        return res;
    }

    /**
     * 响应数据
     */
    private Map<String, String> data = new HashMap<>();
}
