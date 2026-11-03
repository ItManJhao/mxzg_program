package com.ayjs.mxzg.common.util;

/**
 * 掉落随机物接口
 */
public interface IDrop {
    /**
     * 掉落资源Id
     */
    int getDropId();
    /**
     * 概率
     */
    int getRate();
}
