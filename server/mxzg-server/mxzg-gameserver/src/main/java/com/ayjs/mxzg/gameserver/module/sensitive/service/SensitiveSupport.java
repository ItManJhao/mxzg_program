package com.ayjs.mxzg.gameserver.module.sensitive.service;

import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.common.util.tuple.Tuples;

import java.util.Map;
import java.util.Set;

/**
 * 敏感字
 */
class SensitiveSupport {

    /**
     * 拆分敏感字
     * 字母的敏感字统一转成小写处理
     *
     * @param word
     * @return
     */
    static Tuple2<String, String> splitSensitiveWord(String word) {
        String firstChar = word.substring(0, 1);
        String value = word.substring(1);
        return Tuples.of(firstChar.toLowerCase(), value.toLowerCase());
    }

    /**
     * 查找敏感字词
     *
     * @param context
     * @param sensitiveWordMap
     * @return
     */
    static String findFirstSensitiveWord(String context, Map<String, Set<String>> sensitiveWordMap) {
        String[] strs = context.trim().split("");
        int index = 0;
        while (index < strs.length) {
            String temp = strs[index];
            Set<String> map = sensitiveWordMap.get(temp.toLowerCase());
            if (map == null || map.isEmpty()) {
                index++;
            } else {
                int j = index + 1;
                for (String key : map) {
                    if (j + key.length() > strs.length) {
                        continue;
                    }
                    if (j + key.length() > context.length()) {
                        continue;
                    }
                    if (key.equalsIgnoreCase(context.substring(j, j + key.length()))) {
                        return temp + key;
                    }
                }
                index++;
            }
        }
        return null;
    }

}
