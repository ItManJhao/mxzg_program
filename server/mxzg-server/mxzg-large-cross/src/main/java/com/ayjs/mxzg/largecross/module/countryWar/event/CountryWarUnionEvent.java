package com.ayjs.mxzg.largecross.module.countryWar.event;

import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Value(staticConstructor = "of")
public class CountryWarUnionEvent {
    /***
     * 组所在所有服务器
     */
    private List<Integer> serverIds;
    /***
     * 是否是解散
     */
    private boolean dissolve;
    /***
     * 单独服务器
     */
    private int soleServerId;

}
