/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion010PrivilegeGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion010PrivilegeGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PrivilegeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.protocol.Promotion010GMsg.GReqPrivilegeGiftAddOrUpdate;
import com.ayjs.mxzg.protocol.Promotion010GMsg.GReqPrivilegeGiftBuy;
import com.ayjs.mxzg.protocol.Promotion010GMsg.GResPrivilegeGiftAddOrUpdate;
import com.ayjs.mxzg.protocol.Promotion010GMsg.GResPrivilegeGiftBuy;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * @author YY
 *
 */
@Controller
public class Promotion010PrivilegeGiftHandler extends ProtocolHandler {

	@Autowired
	private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;
	@Autowired
	private Promotion010PrivilegeGiftSysCache promotion010PrivilegeGiftSysCache;
	@Autowired
	private ThingService thingService;
	
	/**
	 * 查看特权礼包信息
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._20014)
	public void scanPrivilegeGiftList(PlayerContext playerContext, GReqPrivilegeGiftAddOrUpdate msg) {
		
		List<PrivilegeGift> list = promotion010PrivilegeGiftService.getPrivilegeGifts(playerContext.getId());
		
		GResPrivilegeGiftAddOrUpdate.Builder builder = GResPrivilegeGiftAddOrUpdate.newBuilder();
		for(PrivilegeGift gift : list) {
			builder.addList(promotion010PrivilegeGiftService.serializePrivilegeGift(gift));
		}
		playerContext.write(CmdCode._20014, builder.build());
	}
	
	/**
	 * 购买钻石类特权礼包
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._20015)
	public void buyPrivilegeGift(PlayerContext playerContext, GReqPrivilegeGiftBuy msg) {
		CPromotion010PrivilegeGift cGift = promotion010PrivilegeGiftSysCache.getOrThrow(msg.getIdx());
		
		Asserts.isTrue(cGift.getBuy_type() == 2, ErrorCode.PRIVILEGE_NOT_GEM_BUY.getValue(), "该特权不能通过钻石购买");
		
		PrivilegeType privilegeType = PrivilegeType.valueOf(msg.getIdx());
		
		PrivilegeGift privilegeGift = promotion010PrivilegeGiftService.getPrivilegeGift(playerContext.getId(), privilegeType);
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		if(privilegeGift != null && (privilegeGift.getEndTime() == 0 || privilegeGift.getEndTime() > nowTime)) {
			Asserts.isTrue(false, ErrorCode.PRIVILEGE_HAS.getValue(), "已经拥有该特权");
		}
		ImmutableThing cost = ImmutableThing.of(ItemType.IT_GEM, cGift.getCost_gem());
		thingService.cost(playerContext.getId(), cost, GameEvent.BUY_PRIVILEGE);
		
		privilegeGift = promotion010PrivilegeGiftService.addOrUpdatePrivilegeGift(playerContext.getId(), cGift);
		
		thingService.add(playerContext.getId(), cGift.getItem(), GameEvent.BUY_PRIVILEGE);
		
		GResPrivilegeGiftBuy.Builder builder = GResPrivilegeGiftBuy.newBuilder();
		builder.setData(promotion010PrivilegeGiftService.serializePrivilegeGift(privilegeGift));
		playerContext.write(CmdCode._20015, builder.build());
	}
}
