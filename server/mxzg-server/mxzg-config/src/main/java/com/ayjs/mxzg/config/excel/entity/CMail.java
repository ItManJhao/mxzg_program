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
public class CMail implements BaseExcelModel {
	private int idx;
	private String scene;
	private String title_lang;
	private int[] title_param;
	private String content_lang;
	private int[] content_param;
	@Override
	public int getExcelId() {
		return idx;
	}
}
