package com.ayjs.mxzg.largecross.web.support;

import lombok.Value;

/**
 * http返回
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Value(staticConstructor = "of")
public class WebResult {
    private int code;
    private String desc;
}
