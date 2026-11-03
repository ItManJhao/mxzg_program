/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.growthGiftBag.service;

import com.ayjs.mxzg.config.excel.cache.GrowthGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CGrowthGift;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.growthGiftBag.constant.GrowthGiftType;
import com.ayjs.mxzg.gameserver.module.growthGiftBag.dao.GrowthGiftDao;
import com.ayjs.mxzg.gameserver.module.growthGiftBag.domain.GrowthGift;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.PromotionGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author YY
 *
 */
@Service
public class GrowthGiftService {

	@Autowired
	private GrowthGiftDao growthGiftDao;
	@Autowired
	private ContextManager contextManager;
	@Autowired
	private GrowthGiftSysCache growthGiftSysCache;

	/**
	 * 获取某种类型的成长礼包
	 * @param rid
	 * @param type
	 * @return
	 */
	public GrowthGift select(long rid, GrowthGiftType type){
		List<GrowthGift> growthGifts = growthGiftDao.selectAll(rid);
		GrowthGift model = null;
		for(GrowthGift growthGift : growthGifts){
			if(growthGift.getType() == type.getType()){
				model = growthGift;
			}
		}
		if(model == null){
			model = new GrowthGift();
			model.setRid(rid);
			model.setType(type.getType());
			growthGiftDao.add(model);
		}
		return model;
	}


	public void update(GrowthGift growthGift){
		growthGiftDao.update(growthGift);
	}


	/**
	 * 获取成长礼包列表1
	 * @param rid
	 */
	public void vipBuyRewardList(long rid){
		PromotionGMsg.GResVipRewardLog.Builder builder = PromotionGMsg.GResVipRewardLog.newBuilder();
		GrowthGift growthGift = select(rid, GrowthGiftType.BUY_GIFT);
		for (Integer idx : growthGift.getReward_idx()){
			builder.addList(idx);
		}
		contextManager.write(rid, CmdCode._20005,builder.build());
	}

	/**
	 * 获取成长礼包列表2
	 * @param rid
	 */
	public void vipDecorateRewardList(long rid){
		PromotionGMsg.GResVipDecorateReward.Builder builder = PromotionGMsg.GResVipDecorateReward.newBuilder();
		GrowthGift growthGift = select(rid,GrowthGiftType.DECORATE_GIFT);

		List<Integer> idxList = growthGift.getReward_idx();
		for(CGrowthGift cModel : growthGiftSysCache.getAll()){
			ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
			data.setKey(cModel.getIdx());
			if(idxList.contains(cModel.getIdx())){
				data.setValue(1);
			}else{
				data.setValue(0);
			}
			builder.addList(data.build());
		}
		contextManager.write(rid,CmdCode._20011,builder.build());
	}

}
