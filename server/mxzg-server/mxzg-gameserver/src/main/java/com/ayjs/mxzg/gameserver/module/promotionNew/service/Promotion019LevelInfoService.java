/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion019LevelInfoDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion019LevelInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.Promotion019SystemInfo;

/**
 * @author YY
 *
 */
@Service
public class Promotion019LevelInfoService extends BasePromotionService<Promotion019LevelInfo> {
	
	@Autowired
	private Promotion019LevelInfoDao promotion019LevelInfoDao;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.SHENG_JI_YOU_LI;
	}

	@Override
	public IRepository<Promotion019LevelInfo> getRepository() {
		return promotion019LevelInfoDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion019LevelInfo promotion, PromotionControl control) {
		promotion.getLevelInfo().clear();
	}
	
	public Promotion019SystemInfo getSystemInfo() {
		PromotionControl control = promotionControlService.getControl(thisPromotionType());
		return JsonUtil.parseJson(control.getExtraInfo(), Promotion019SystemInfo.class);
	}
}
