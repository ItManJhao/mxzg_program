/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBattleMatrix;

/**
 * @author YY
 *
 */
@Component
public class BattleMatrixSysCache extends BaseExcelCache<CBattleMatrix> {

	@Override
	public String getFileName() {
		return "battlematrix";
	}
}
