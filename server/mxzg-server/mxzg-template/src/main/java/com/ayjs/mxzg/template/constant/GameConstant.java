/**
 * 
 */
package com.ayjs.mxzg.template.constant;

import java.util.regex.Pattern;

/**
 * @author YY
 *
 */
public interface GameConstant {

	/**
	 * 一百万
	 */
    int MILLION = 1000000;
	/**
	 * 一万
	 */
    int WAN = 10000;

//    /**
//     * 角色名长度
//     */
//    int ROLE_NICK_LENGTH = 12;
//    /**
//     * 商会名长度
//     */
//    int CLAN_NAME_LENGTH = 12;
    /**
     * http请求超时时间
     */
    int HTTP_TIMEOUT = 2000;
    /**
     * 角色名商会名字检测
     */
    Pattern NAME_PATTERN = Pattern.compile("[\\p{Graph}\\p{Space}\\p{Blank}\\w\\u0020-\\uFE4F]+");
}
