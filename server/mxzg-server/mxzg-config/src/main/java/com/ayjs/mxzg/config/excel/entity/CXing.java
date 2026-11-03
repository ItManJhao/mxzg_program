/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.LanguageConfig;
import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CXing implements BaseExcelModel, LanguageConfig {
	private int idx;
    /**
     * 简体
     */
    private String value;
    /**
     * 繁体
     */
    private String cn_trad;
    /**
     * 韩文
     */
    private String kor;
    /**
     * 日文
     */
    private String jpn;
    /**
     * 越南
     */
    private String vn;
    /**
     * 英语
     */
    private String en;
    /**
     * 泰文
     */
    private String thai;
    /**
     * 印尼语
     */
    private String idn;
	@Override
	public int getExcelId() {
		return idx;
	}
}
