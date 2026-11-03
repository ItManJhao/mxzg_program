package com.ayjs.mxzg.gameserver.module.util;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.util.CharsetUtil;
import org.apache.commons.lang3.RandomStringUtils;

/**
 * 字符简单加密处理
 */
public class StringEncryptUtil {
    /**
     * 随机字符长度
     */
    private final static int RANDOM_KEY_LENGTH = 11;

    /**
     * 参数做base64处理后，前面加11位随机数
     *
     * @param str
     * @return
     */
    public static String simpleBase64Encryption(String str) {
        return RandomStringUtils.randomAlphanumeric(RANDOM_KEY_LENGTH) + Base64.encode(str, CharsetUtil.CHARSET_UTF_8);
    }

    /**
     * 前面减11位随机数，做base64解码
     *
     * @param str
     * @return
     */
    public static String simpleBase64Decryption(String str) {
        return Base64.decodeStr(str.substring(RANDOM_KEY_LENGTH), CharsetUtil.CHARSET_UTF_8);
    }
}
