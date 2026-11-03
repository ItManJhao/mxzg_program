/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;

/**
 * @author YY
 *
 */
@Component
public class RainbowConst extends ExcelDictionaryCache {
	/**
	 * 彩虹圣殿记录条数
	 */
	@ExcelDictionaryField("rainbow_record_count")
	public static int RECORD_COUNT;
	/**
	 * 彩虹圣殿挑战等级要求
	 */
	@ExcelDictionaryField("rainbow_challenge_level")
	public static int CHALLENGE_LEVEL;
	/**
	 * 彩虹圣殿挑战失败冷却时间
	 */
	@ExcelDictionaryField("rainbow_challenge_cd")
	public static int CHALLENGE_CD;
	
	@Override
	protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
//		this.printFieldValue();
	}
}
