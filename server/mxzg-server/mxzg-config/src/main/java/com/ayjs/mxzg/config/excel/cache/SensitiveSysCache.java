/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSensitive;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class SensitiveSysCache extends BaseExcelCache<CSensitive> {

	@Override
	public String getFileName() {
		return "sensitive";
	}

//	@Override
//	protected void loadAfterReady() {
//		String[] words = new String[this.getAll().size()];
//		for(int i = 0; i < this.getAll().size(); i++) {
//			CSensitive c = this.getAll().get(i);
//			words[i] = c.getValue();
//		}
//		//加载敏感字
//		SensitiveUtil.loadSensitiveWord(words);
//	}


}
