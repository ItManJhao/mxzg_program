/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.entity.CClanWarReward;

/**
 * @author YY
 *
 */
@Component
public class ClanWarRewardSysCache extends BaseExcelCache<CClanWarReward> {

	private Map<Integer, List<CClanWarReward>> kindMap;
	
	@Override
	public String getFileName() {
		return "clanwarreward";
	}

	@Override
	protected void loadAfterReady() {
		this.kindMap = this.fillListMap(CClanWarReward::getKind);
	}
	
	public CClanWarReward randomBoxReward(int type) {
		List<CClanWarReward> kindList = kindMap.get(type);
		ConfigAsserts.notNull(kindList, () -> String.format("配置数据不存在{%s}{%s}", type));
		return DropUtil.randomDrop(kindList);
	}
}
