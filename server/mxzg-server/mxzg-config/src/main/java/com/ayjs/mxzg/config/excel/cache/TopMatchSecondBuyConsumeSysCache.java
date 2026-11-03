/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondBuyConsume;
import org.springframework.stereotype.Component;


@Component
public class TopMatchSecondBuyConsumeSysCache extends BaseExcelCache<CTopMatchSecondBuyConsume> {

	@Override
	public String getFileName() {
		return "topmatchsecondbuyconsume";
	}

}
