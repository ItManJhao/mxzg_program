/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.config.excel.entity.CTitle;
import com.ayjs.mxzg.config.struct.TitleType;

/**
 * @author YY
 *
 */
@Component
public class TitleSysCache extends BaseExcelCache<CTitle> {

	private Map<Integer, List<CTitle>> typeTitleMap;
	
	@Override
	public String getFileName() {
		return "title";
	}

	@Override
	protected void loadAfterReady() {
		this.typeTitleMap = this.fillListMap(CTitle::getType);
	}

	public List<CTitle> getTitles(TitleType titleType) {
		return typeTitleMap.get(titleType.getValue());
	}

	@Override
	protected void formSpecial(CTitle t) {
		t.setRankCondition(StringUtil.stringToIntArray(t.getCondition(), "_"));
	}

	@Override
	public boolean check(CTitle t) {
		return t.getRankCondition().length == 2;
	}
}
