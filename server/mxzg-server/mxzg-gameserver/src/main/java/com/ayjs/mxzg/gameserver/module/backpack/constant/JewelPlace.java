/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.backpack.constant;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 *
 */
public enum JewelPlace {
	ATK(1),
	HP(2),
	SPEED(3),
	;
	
	private int value;

	JewelPlace(int value) {
        this.value = value;
    }

    public static JewelPlace of(int value) {
    	JewelPlace result = null;
        for (JewelPlace type : JewelPlace.values()) {
            if (type.value == value) {
                result = type;
                break;
            }
        }
        Asserts.notNull(result, ErrorCode.ERROR_PARAM.getValue(), () -> String.format("获取宝石类型出错，value={%d}", value));
        return result;
    }

    public int getValue() {
        return this.value;
    }
}
