/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.handler;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.cache.JewelTypeSysCache;
import com.ayjs.mxzg.config.excel.constant.JewelConst;
import com.ayjs.mxzg.config.excel.entity.CJewelType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.JewelPlace;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroJewel;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroJewelChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroJewelService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GReqHeroJewel;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GReqHeroJewelChange;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GReqHeroJewelDisboard;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GReqHeroJewelOneKeyDisboard;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GReqHeroJewelOneKeyWear;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GReqJewelAllCombine;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GReqJewelCombine;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GResHeroJewel;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GResHeroJewelChange;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GResHeroJewelDisboard;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GResHeroJewelOneKeyDisboard;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GResHeroJewelOneKeyWear;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GResJewelAllCombine;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.GResJewelCombine;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.PSHeroJewelData;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 *
 */
@Controller
public class HeroJewelHandler extends ProtocolHandler {

	@Autowired
	private HeroService heroService;
	@Autowired
	private HeroJewelService heroJewelService;
	@Autowired
	private JewelTypeSysCache jewelTypeSysCache;
	@Autowired
	private ThingService thingService;
	@Autowired
    private EventBus eventBus;
	
	/**
	 * 查看英雄身上的宝石
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._4101)
	public void scanHeroJewel(PlayerContext playerContext, GReqHeroJewel msg) {
		List<Hero> heros = heroService.getHeros(playerContext.getId());
		List<HeroJewel> jewels = heroJewelService.getRoleParts(playerContext.getId());
		Map<Long, List<HeroJewel>> heroJewels = ListMapUtil.fillListMap(jewels, HeroJewel::getHeroId);

		GResHeroJewel.Builder builder = GResHeroJewel.newBuilder();
		for (Hero hero : heros) {
			PSHeroJewelData.Builder model = PSHeroJewelData.newBuilder();
			model.setHeroId(hero.getId());
			List<HeroJewel> list = heroJewels.get(hero.getId());
			if (list != null) {
				for (HeroJewel jewel : list) {
					// 没有按装备的部位进行排序
					model.addJewelList(PbUtil.buildJewel(jewel));
				}
			}
			builder.addJewelList(model.build());
		}
		playerContext.write(CmdCode._4101, builder.build());
		
	}
	
	@CMD(id = CmdCode._4102)
	public void heroJewelChange(PlayerContext playerContext, GReqHeroJewelChange msg) {
		Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
		Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + msg.getHeroId());
		
		CJewelType cJewelType = jewelTypeSysCache.getOrThrow(msg.getSysId());

		int needStar = JewelConst.OPEN_STAR.get(cJewelType.getPlace());
		Asserts.isTrue(hero.getStar() >= needStar, ErrorCode.HERO_JEWEL_STAR.getValue(), "还没有达到镶嵌该宝石的星级要求");
		
		HeroJewel currJewel = heroJewelService.partChange(playerContext.getId(), msg.getHeroId(), cJewelType,
				GameEvent.JEWEL_CHANGE);

		GResHeroJewelChange.Builder builder = GResHeroJewelChange.newBuilder();
		builder.setHeroId(hero.getId());
		builder.setJewel(PbUtil.buildJewel(currJewel));
		playerContext.write(CmdCode._4102, builder.build());
		
		//英雄换宝石
		eventBus.post(HeroJewelChangeEvent.of(hero, GameEvent.JEWEL_CHANGE));
	}
	
	@CMD(id = CmdCode._4103)
	public void heroJewelDisboard(PlayerContext playerContext, GReqHeroJewelDisboard msg) {
		Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
		Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + msg.getHeroId());

		HeroJewel currJewel = heroJewelService.getPlacePart(playerContext.getId(), hero.getId(), msg.getJewelId());
		Asserts.isTrue(currJewel != null && currJewel.getSysId() > 0, ErrorCode.HERO_JEWEL_EMPTY.getValue(), "没有镶嵌着的宝石");
		
		// 将脱下的装备转换回道具
		ImmutableThing jewelItem = ImmutableThing.of(currJewel.getSysId(), 1);
        thingService.add(playerContext.getId(), jewelItem, GameEvent.JEWEL_OFF, NoticeType.SLIENT);
        
        currJewel.setSysId(0);
		heroJewelService.updateHeroPart(currJewel);

		GResHeroJewelDisboard.Builder builder = GResHeroJewelDisboard.newBuilder();
		builder.setHeroId(hero.getId());
		builder.setJewel(PbUtil.buildJewel(currJewel));
		playerContext.write(CmdCode._4103, builder.build());

		//英雄换宝石
		eventBus.post(HeroJewelChangeEvent.of(hero, GameEvent.JEWEL_OFF));
	}
	
	@CMD(id = CmdCode._4104)
	public void heroJewelOneKeyChange(PlayerContext playerContext, GReqHeroJewelOneKeyWear msg) {
		Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
		Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + msg.getHeroId());

		Set<Integer> sysIdSet = new HashSet<>(msg.getSysIdList());
		Asserts.isTrue(!sysIdSet.isEmpty(), ErrorCode.ERROR_PARAM.getValue(), "参数为空");
		
		//可以镶嵌的宝石，帮前端过滤数据而不进行报错
		Set<Integer> usableSysIdSet = new HashSet<>();
		for(Integer sysId : sysIdSet) {
			CJewelType cJewelType = jewelTypeSysCache.getOrThrow(sysId);
			int needStar = JewelConst.OPEN_STAR.get(cJewelType.getPlace());
			if(hero.getStar() >= needStar) {
				usableSysIdSet.add(sysId);
			}
		}
		Asserts.isTrue(!usableSysIdSet.isEmpty(), ErrorCode.HERO_JEWEL_LACK.getValue(), "没有可用的宝石");
		
		heroJewelService.oneKeyPartChange(playerContext.getId(), msg.getHeroId(),
				usableSysIdSet, GameEvent.JEWEL_ALL_WEAR);
		//oneKeyPartChange里面只返回了修改过的数据，前端需要英雄的全数据
		List<HeroJewel> currParts = heroJewelService.getHeroParts(playerContext.getId(), msg.getHeroId());
		
		GResHeroJewelOneKeyWear.Builder builder = GResHeroJewelOneKeyWear.newBuilder();
		builder.setHeroId(hero.getId());
		for(HeroJewel jewel : currParts) {
			builder.addJewel(PbUtil.buildJewel(jewel));
		}
		playerContext.write(CmdCode._4104, builder.build());

		//英雄换宝石
		eventBus.post(HeroJewelChangeEvent.of(hero, GameEvent.JEWEL_ALL_WEAR));
	}
	
	@CMD(id = CmdCode._4105)
	public void heroJewelOneKeyDisboard(PlayerContext playerContext, GReqHeroJewelOneKeyDisboard msg) {
		Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
		Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + msg.getHeroId());

		List<HeroJewel> jewelList = heroJewelService.clearHeroPlaingParts(playerContext.getId(),
				Collections.singletonList(hero), GameEvent.JEWEL_ALL_OFF);

		GResHeroJewelOneKeyDisboard.Builder builder = GResHeroJewelOneKeyDisboard.newBuilder();
		builder.setHeroId(hero.getId());
		for (HeroJewel jewel : jewelList) {
			builder.addJewel(PbUtil.buildJewel(jewel));
		}
		playerContext.write(CmdCode._4105, builder.build());

		//英雄换宝石
		eventBus.post(HeroJewelChangeEvent.of(hero, GameEvent.JEWEL_ALL_OFF));
	}
	
	@CMD(id = CmdCode._4106)
	public void makeJewel(PlayerContext playerContext, GReqJewelCombine msg) {
		Asserts.isTrue(msg.getMakeCount() > 0, ErrorCode.ERROR_PARAM.getValue(), "参数错误" + msg.getMakeCount());

		CJewelType newJewelType = jewelTypeSysCache.getOrThrow(msg.getJewelType());
		Asserts.isTrue(!newJewelType.getNeed_equipment().isEmpty(), ErrorCode.BAG_COST_ERROR.getValue(),
				"消耗配置错误" + newJewelType.getJewel_type());

		List<ImmutableThing> finalCostList = ImmutableThingUtil.multiplyThing(newJewelType.getNeed_equipment(),
				msg.getMakeCount());
		thingService.cost(playerContext.getId(), finalCostList, GameEvent.JEWEL_MAKE);

        // 达成合成要求
        ImmutableThing newJewel = ImmutableThing.of(newJewelType.getJewel_type(), msg.getMakeCount());
        Rewards rewardList = thingService.add(playerContext.getId(), newJewel, GameEvent.JEWEL_MAKE, NoticeType.SLIENT);

        GResJewelCombine.Builder builder = GResJewelCombine.newBuilder();
        Map<Integer, Integer> equipMap = new HashMap<>();
        for (ImmutableThing reward : rewardList.getThingSet().asList()) {
            builder.addJewel(PbUtil.buildReward(reward));
            equipMap.put(reward.getItem_type(), equipMap.getOrDefault(reward.getItem_type(), 0) + (int) reward.getItem_num());
        }
        playerContext.write(CmdCode._4106, builder.build());

//        eventBus.post(MakeEquipEvent.of(playerContext.getId(), msg.getMakeCount(), equipMap));
	}
	
	@CMD(id = CmdCode._4107)
	public void makeAllJewel(PlayerContext playerContext, GReqJewelAllCombine msg) {
        JewelPlace jewelPlace = JewelPlace.of(msg.getJewelPlace());
        Asserts.notNull(jewelPlace, ErrorCode.ERROR_PARAM.getValue(), () -> "JewelPlace error:" + msg.getJewelPlace());

        List<CJewelType> jewelTypeList = jewelTypeSysCache.getPlaceJewels(msg.getJewelPlace());
		Asserts.isTrue(Objects.nonNull(jewelTypeList) && !jewelTypeList.isEmpty(), ErrorCode.ERROR_PARAM.getValue(),
				"jewelTypeList is null or empty:" + msg.getJewelPlace());

        // 最终需要展示的结果
        List<ImmutableThing> resultList = new ArrayList<>();
        
        //TODO 后续如果策划需要进行一些活动的数据记录，则会用到makeCount跟jewelMap
        @SuppressWarnings("unused")
		int makeCount = 0;
        Map<Integer, Integer> jewelMap = new HashMap<>();
        
        for (CJewelType type : jewelTypeList) {

        	CJewelType currType = jewelTypeSysCache.getOrThrow(type.getJewel_type());
            List<ImmutableThing> costList = currType.getNeed_equipment();
            if (Objects.isNull(costList) || costList.isEmpty()) {
                continue;
            }
            // 计算道具能合几次
            int jewelNumber = 0;
			for (; true; jewelNumber++) {
            	List<ImmutableThing> tempCostList = ImmutableThingUtil.multiplyThing(costList, jewelNumber + 1);
            	if (!thingService.enough(playerContext.getId(), tempCostList)) {
                    break;
                }
            }
            // 得到和合并几次
            if (jewelNumber <= 0) {
                continue;
            }
            // 组织扣除数据
            List<ImmutableThing> realCostList = ImmutableThingUtil.multiplyThing(costList, jewelNumber);
            thingService.cost(playerContext.getId(), realCostList, GameEvent.JEWEL_ALL_MAKE);

            ImmutableThing newJewel = ImmutableThing.of(currType.getJewel_type(), jewelNumber);
            Rewards rewardList = thingService.add(playerContext.getId(), newJewel, GameEvent.JEWEL_ALL_MAKE, NoticeType.SLIENT);

            rewardList.getThingSet().asList().forEach(jewel -> {
            	jewelMap.put(jewel.getItem_type(), jewelMap.getOrDefault(jewel.getItem_type(), 0) + (int) jewel.getItem_num());
            });
            //最终结果=合成后获得的物品数量-合成中消耗的物品数量
            resultList.addAll(rewardList.getThingSet().asList());
            resultList.addAll(realCostList.stream().map(thing ->
                    ImmutableThing.of(thing.getItem_type(), -thing.getItem_num())).collect(Collectors.toList()));

            makeCount += jewelNumber;
        }
        resultList = ImmutableThingUtil.mergeThing(resultList).stream()
                .filter(thing -> thing.getItem_num() > 0).collect(Collectors.toList());

        GResJewelAllCombine.Builder builder = GResJewelAllCombine.newBuilder();
        for(ImmutableThing reward : resultList) {
        	builder.addJewel(PbUtil.buildReward(reward));
        }
        playerContext.write(CmdCode._4107, builder.build());

//        eventBus.post(MakeEquipEvent.of(role.getId(), makeCount, equipMap));
	}
}
