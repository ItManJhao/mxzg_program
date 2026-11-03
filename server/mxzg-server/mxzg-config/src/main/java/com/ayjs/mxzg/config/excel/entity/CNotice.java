/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CNotice implements BaseExcelModel {
	private int idx;
	private String scene;
	private int marquee;
	private int scope;
	private int[] channel;
	private String lamp_lang;
	private String chat_lang;
	private int[] param;
	private int loop_count;
	private int space;
	private int force;
	
	@Override
	public int getExcelId() {
		return idx;
	}
}
