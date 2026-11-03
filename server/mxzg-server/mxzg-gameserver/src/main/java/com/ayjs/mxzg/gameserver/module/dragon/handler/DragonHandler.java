/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.dragon.handler;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.alibaba.fastjson.JSONArray;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.DragonIdentifySysCache;
import com.ayjs.mxzg.config.excel.cache.DragonLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.DragonRelicSysCache;
import com.ayjs.mxzg.config.excel.cache.DragonRemainsChanceSysCache;
import com.ayjs.mxzg.config.excel.cache.DragonRemainsSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.entity.CDragonIdentify;
import com.ayjs.mxzg.config.excel.entity.CDragonLevel;
import com.ayjs.mxzg.config.excel.entity.CDragonRelic;
import com.ayjs.mxzg.config.excel.entity.CDragonRemains;
import com.ayjs.mxzg.config.excel.entity.CDragonRemainsChance;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.dragon.domain.Dragon;
import com.ayjs.mxzg.gameserver.module.dragon.event.DragonChangeEvent;
import com.ayjs.mxzg.gameserver.module.dragon.event.DragonUpStarEvent;
import com.ayjs.mxzg.gameserver.module.dragon.service.DragonService;
import com.ayjs.mxzg.gameserver.module.dragon.struct.DragonIdentity;
import com.ayjs.mxzg.gameserver.module.dragon.struct.DragonSlot;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.UpStarRequire;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PrivilegeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonChange;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonChangeSort;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonCollection;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonIdentityFinish;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonPutStone;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonResolve;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonScanInfo;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonSpeedUpIdentity;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonUpStarInBag;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonUpStarInSlot;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonUpgradeIdentity;
import com.ayjs.mxzg.protocol.DragonGMsg.GReqDragonUpgradeLevel;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonChange;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonChangeSort;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonCollection;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonFinishNotice;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonIdentityFinish;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonPutStone;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonResolve;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonScanInfo;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonSpeedUpIdentity;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonUpStarInBag;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonUpStarInSlot;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonUpgradeIdentity;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonUpgradeLevel;
import com.ayjs.mxzg.protocol.DragonGMsg.PSDragonChoose;
import com.ayjs.mxzg.protocol.DragonGMsg.PSDragonIdentity;
import com.ayjs.mxzg.protocol.DragonGMsg.PSDragonSlot;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;

/**
 * @author YY
 *
 */
@Controller
public class DragonHandler extends ProtocolHandler {

	@Autowired
	private DragonService dragonService;
	@Autowired
	private ThingService thingService;
	@Autowired
	private DragonIdentifySysCache dragonIdentifySysCache;
	@Autowired
	private DragonLevelSysCache dragonLevelSysCache;
	@Autowired
	private DragonRelicSysCache dragonRelicSysCache;
	@Autowired
	private DragonRemainsSysCache dragonRemainsSysCache;
	@Autowired
	private RoleRechargeService roleRechargeService;
	@Autowired
	private DragonRemainsChanceSysCache dragonRemainsChanceSysCache;
	@Autowired
	private RewardGroupSysCache rewardGroupSysCache;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;
	@Autowired
	private HeroService heroService;
	@Autowired
	private HeroTypeSysCache heroTypeSysCache;
	@Autowired
	private HeroLineUpService heroLineUpService;
	
	//查看圣龙数据
	@CMD(id = CmdCode._59001)
	public void scanDragonInfo(PlayerContext playerContext, GReqDragonScanInfo msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		
		GResDragonScanInfo.Builder builder = GResDragonScanInfo.newBuilder();
		builder.setIdentifyLevel(dragon.getIdentifyLevel());
		builder.setAttrLevel(dragon.getAttrLevel());
		for(DragonIdentity identity : dragon.getIdentitys().values()) {
			builder.addIdentities(buildIdentity(identity));
		}
		for(DragonSlot slot : dragon.getSlots().values()) {
			builder.addSlots(buildSlot(slot));
		}
		PrivilegeGift privilegeGift = promotion010PrivilegeGiftService.getPrivilegeGift(playerContext.getId(), PrivilegeType.DRAGON_LUXURY);
		if(privilegeGift != null) {
			builder.setPrivilegeEndTime(privilegeGift.getEndTime());
		}
		playerContext.write(CmdCode._59001, builder.build());
	}
	
	
	public PSDragonSlot buildSlot(DragonSlot slot) {
		PSDragonSlot.Builder builder = PSDragonSlot.newBuilder();
		builder.setId(slot.getId());
		builder.setSysId(slot.getSysId());
		return builder.build();
	}
	
	public PSDragonIdentity buildIdentity(DragonIdentity identity) {
		PSDragonIdentity.Builder builder = PSDragonIdentity.newBuilder();
		builder.setType(identity.getType());
		builder.setStartTime(identity.getStartTime());
		builder.setLevel(identity.getLevel());
		builder.setSpeedAdd(identity.getSpeedAdd());
		return builder.build();
	}
	
	//放入源石
	@CMD(id = CmdCode._59002)
	public void putStone(PlayerContext playerContext, GReqDragonPutStone msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		
		DragonIdentity identity = dragon.getIdentitys().get(msg.getType());
		Asserts.isTrue(identity != null, ErrorCode.ERROR_PARAM.getValue(), "参数错误" + msg.getType());
		Asserts.isTrue(identity.getLevel() == 0, ErrorCode.DRAGON_IDENTITY_RUNNING.getValue(), "当前鉴定还没有完成");
		
		if(identity.getType() == 2) {
			boolean active = promotion010PrivilegeGiftService.isPrivilegeActive(playerContext.getId(), PrivilegeType.DRAGON_LUXURY);
			//验证是否开通了特权
			Asserts.isTrue(active, ErrorCode.DRAGON_NEED_PRIVILEGE.getValue(), "还没有开通该特权");
		}
		
		CDragonRemains cDragonRemains = dragonRemainsSysCache.getIdentityRemains(msg.getLevel());
		Asserts.isTrue(cDragonRemains != null, ErrorCode.ERROR_PARAM.getValue(), "参数错误" + msg.getLevel());
		
		thingService.cost(playerContext.getId(), cDragonRemains.getCost(), GameEvent.DRAGON_IDENTITY);
		
		identity.setLevel(msg.getLevel());
		identity.setSpeedAdd(0);
		identity.setStartTime(TimeDateUtil.getCurrentTimeInt());
		dragonService.update(dragon);
		
		GResDragonPutStone.Builder builder = GResDragonPutStone.newBuilder();
		builder.setIdentity(buildIdentity(identity));
		playerContext.write(CmdCode._59002, builder.build());
	}
	
	//提升鉴定等级
	@CMD(id = CmdCode._59003)
	public void upgradeIdentityLevel(PlayerContext playerContext, GReqDragonUpgradeIdentity msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		Asserts.isTrue(dragon.getIdentifyLevel() < dragonIdentifySysCache.getMaxLevel(), ErrorCode.DRAGON_IDENTITY_MAX.getValue(), "鉴定等级已达到最大");
		
		CDragonIdentify cDragonIdentify = dragonIdentifySysCache.getOrThrow(dragon.getIdentifyLevel());
		
		RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(playerContext.getId());
		Asserts.isTrue(roleRecharge.getTotalRecharge() >= cDragonIdentify.getNeed_recharge(), ErrorCode.DRAGON_NEED_RECHARGE.getValue(), "累充金额还没有达到升级要求");
		
		
		List<UpStarRequire> heroRequire = JSONArray.parseArray(cDragonIdentify.getUpgrade_require(), UpStarRequire.class);
		List<Hero> heroList = new ArrayList<>();
		
		boolean matchAllCost = true;
		
		OutLoop : for(PSDragonChoose choose : msg.getChooseList()) {
			Asserts.isTrue(choose.getSlot() <= heroRequire.size(), ErrorCode.ERROR_PARAM.getValue(),
					"参数异常" + choose.getSlot() + "，限制" + heroRequire.size());
			UpStarRequire require = heroRequire.get(choose.getSlot() - 1);
			Asserts.isTrue(require.getNum() == choose.getHeroIdsList().size(), ErrorCode.ERROR_PARAM.getValue(),
					"参数异常，需要" + require.getNum() + "，参数" + choose.getHeroIdsList().size());
			for(long heroId : choose.getHeroIdsList()) {
				Hero hero = heroService.getUnlockInLineUpHero(playerContext.getId(), heroId);
				Asserts.isTrue(hero != null, ErrorCode.HERO_MUST_IDLE.getValue(), "素材英雄不能在阵上");
				boolean match = isMatch(require, hero);
				if(match) {
					heroList.add(hero);
				} else {
					matchAllCost = false;
					break OutLoop;
				}
			}
		}
		Asserts.isTrue(matchAllCost, ErrorCode.DRAGON_IDENTITY_NOTMATCH.getValue(), "提升鉴定等级所需的英雄未满足要求");

		List<Long> heroIds = heroList.stream().map(Hero::getId).collect(Collectors.toList());;
		Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), heroIds), ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(),
				"不能删除指定阵型上的所有英雄");

		heroService.deleteHeros(playerContext.getId(), heroList, GameEvent.DRAGON_UP_IDENTITY);
		
		GResDragonUpgradeIdentity.Builder builder = GResDragonUpgradeIdentity.newBuilder();
		
		//结算鉴定中的进度
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		for(DragonIdentity identity : dragon.getIdentitys().values()) {
			if(identity.getLevel() <= 0) {
				continue;
			}
			int time = nowTime - identity.getStartTime();
			int addProcess = cDragonIdentify.getSpeed() * time;
			identity.setSpeedAdd(identity.getSpeedAdd() + addProcess);
			identity.setStartTime(nowTime);
			
			builder.addIdentities(buildIdentity(identity));
		}
		dragon.setIdentifyLevel(dragon.getIdentifyLevel() + 1);
		dragonService.update(dragon);
		
		builder.setIdentifyLevel(dragon.getIdentifyLevel());
		playerContext.write(CmdCode._59003, builder.build());
	}
	
	
	private boolean isMatch(UpStarRequire require, Hero hero) {
		CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
		if(require.getElem() != 0 && require.getElem() != cHeroType.getElem()) {
			return false;
		}
		if(require.getType() != 0 && require.getType() != hero.getType()) {
			return false;
		}
		if(require.getStar() != 0 && require.getStar() > hero.getStar()) {
			return false;
		}
		return true;
	}
	
	//加速鉴定
	@CMD(id = CmdCode._59005)
	public void speedUpIdentity(PlayerContext playerContext, GReqDragonSpeedUpIdentity msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		
		DragonIdentity identity = dragon.getIdentitys().get(msg.getType());
		Asserts.isTrue(identity != null, ErrorCode.ERROR_PARAM.getValue(), "参数错误" + msg.getType());
		Asserts.isTrue(identity.getLevel() > 0, ErrorCode.DRAGON_NEED_STONE.getValue(), "请先放进源石开始鉴定");
		
		CDragonRemains cDragonRemains = dragonRemainsSysCache.getSpeedRemains(msg.getSpeed());
		if(msg.getAuto() == 1) {
			//自动购买
			if(thingService.enough(playerContext.getId(), cDragonRemains.getCost())) {
				thingService.cost(playerContext.getId(), cDragonRemains.getCost(), GameEvent.DRAGON_SPEED_UP);
			} else {
				thingService.cost(playerContext.getId(), cDragonRemains.getBuy(), GameEvent.DRAGON_SPEED_UP);
			}
		} else {
			thingService.cost(playerContext.getId(), cDragonRemains.getCost(), GameEvent.DRAGON_SPEED_UP);
		}
		
		identity.setSpeedAdd(identity.getSpeedAdd() + cDragonRemains.getPoint());
		dragonService.update(dragon);
		
		GResDragonSpeedUpIdentity.Builder builder = GResDragonSpeedUpIdentity.newBuilder();
		builder.setIdentity(buildIdentity(identity));
		playerContext.write(CmdCode._59005, builder.build());
		
		if(dragonService.hasIdentityFinish(playerContext.getId())) {
			//通知玩家鉴定完成
			playerContext.write(CmdCode._59014, GResDragonFinishNotice.getDefaultInstance());
		}
	}
	
	//鉴定完成
	@CMD(id = CmdCode._59006)
	public void identityFinish(PlayerContext playerContext, GReqDragonIdentityFinish msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		
		List<ImmutableThing> rewards = new ArrayList<>();
		
		GResDragonIdentityFinish.Builder builder = GResDragonIdentityFinish.newBuilder();
		
		for(DragonIdentity identity : dragon.getIdentitys().values()) {
			if(identity.getLevel() <= 0) {
				continue;
			}
			CDragonRemains cDragonRemains = dragonRemainsSysCache.getIdentityRemains(identity.getLevel());
			if(cDragonRemains == null) {
				continue;
			}
			CDragonIdentify cDragonIdentify = dragonIdentifySysCache.getOrThrow(dragon.getIdentifyLevel());
			int currentPoint = (nowTime - identity.getStartTime()) * cDragonIdentify.getSpeed();
			//最终进度=当前进度+加速进度
			int finalPoint = currentPoint + identity.getSpeedAdd();
			if(cDragonRemains.getPoint() > finalPoint) {
				continue;
			}
			
			int num = dragon.getIdentityNum().getOrDefault(identity.getLevel(), 0);
			CDragonRemainsChance cDragonRemainsChance = dragonRemainsChanceSysCache.getChance(identity.getLevel(), num + 1);
			
			dragon.getIdentityNum().put(identity.getLevel(), num + 1);
			if(cDragonRemainsChance.getMax_num() > 0) {
				dragon.getIdentityNum().put(identity.getLevel(), 0);
			}
			ImmutableList<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(cDragonRemainsChance.getReward_group());
			rewards.addAll(rewardList);
			
			identity.setSpeedAdd(0);
			identity.setStartTime(0);
			identity.setLevel(0);
			for(ImmutableThing reward : rewardList) {
				dragon.getManuals().add(reward.getItem_type());
			}
			builder.addIdentities(buildIdentity(identity));
		}
		if(rewards.isEmpty()) {
			playerContext.write(CmdCode._59006, GResDragonIdentityFinish.getDefaultInstance());
			return;
		}
		dragonService.update(dragon);
		
		rewards = ImmutableThingUtil.mergeThing(rewards);
		thingService.add(playerContext.getId(), rewards, GameEvent.DRAGON_IDENTITY_FINISH, NoticeType.SLIENT);
		
		for(ImmutableThing reward : rewards) {
			builder.addRewards(PbUtil.buildReward(reward));
		}
		playerContext.write(CmdCode._59006, builder.build());
	}
	
	//提升圣龙等级
	@CMD(id = CmdCode._59007)
	public void upgradeLevel(PlayerContext playerContext, GReqDragonUpgradeLevel msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		Asserts.isTrue(dragon.getAttrLevel() < dragonLevelSysCache.getMaxLevel(), ErrorCode.DRAGON_ATTR_MAX.getValue(), "圣物等级已达到上限");
		
		CDragonLevel cDragonLevel = dragonLevelSysCache.getOrThrow(dragon.getAttrLevel());
		
		thingService.cost(playerContext.getId(), cDragonLevel.getItem_require(), GameEvent.DRAGON_ATTR_UP);
		
		dragon.setAttrLevel(dragon.getAttrLevel() + 1);
		DragonSlot newSlot = null;
		CDragonLevel currDragonLevel = dragonLevelSysCache.getOrThrow(dragon.getAttrLevel());
		if(!dragon.getSlots().containsKey(currDragonLevel.getRelic_unlock())) {
			newSlot = new DragonSlot();
			newSlot.setId(currDragonLevel.getRelic_unlock());
			dragon.getSlots().put(newSlot.getId(), newSlot);
		}
		dragonService.update(dragon);
		
		GResDragonUpgradeLevel.Builder builder = GResDragonUpgradeLevel.newBuilder();
		builder.setAttrLevel(dragon.getAttrLevel());
		if(newSlot != null) {
			builder.setSlot(buildSlot(newSlot));
		}
		playerContext.write(CmdCode._59007, builder.build());
		
		//刷新战力
	}
	
	//圣物替换，放上或脱下
	@CMD(id = CmdCode._59008)
	public void changeDragonBall(PlayerContext playerContext, GReqDragonChange msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		DragonSlot slot = dragon.getSlots().get(msg.getSlotId());
		Asserts.isTrue(slot != null, ErrorCode.DRAGON_SLOT_LOCK.getValue(), "还没有解锁该圣物槽位");
	
		if(msg.getSysId() != 0) {
			CDragonRelic cDragonRelic = dragonRelicSysCache.getOrThrow(msg.getSysId());
			
			//是否有同类型的圣物在其它的槽位上
			for(DragonSlot otherSlot : dragon.getSlots().values()) {
				if(otherSlot.getId() == slot.getId() || otherSlot.getSysId() == 0) {
					continue;
				}
				CDragonRelic otherRelic = dragonRelicSysCache.getOrThrow(otherSlot.getSysId());
				Asserts.isTrue(otherRelic.getKind() != cDragonRelic.getKind(), ErrorCode.DRAGON_SAME_KIND.getValue(),
						"已经有同类型的圣物在别的槽位中");
			}
		}
		
		if(slot.getSysId() != 0) {
			//返还原来的圣物到背包
			ImmutableThing thingBack = ImmutableThing.of(slot.getSysId(), 1);
			thingService.add(playerContext.getId(), thingBack, GameEvent.DRAGON_CHANGE_BACK, NoticeType.SLIENT);
			slot.setSysId(0);
		}
		if(msg.getSysId() != 0) {
			ImmutableThing thingCost = ImmutableThing.of(msg.getSysId(), 1);
			thingService.cost(playerContext.getId(), thingCost, GameEvent.DRAGON_CHANGE_PUT);
			slot.setSysId(msg.getSysId());
		}
		dragonService.update(dragon);
		
		GResDragonChange.Builder builder = GResDragonChange.newBuilder();
		builder.setSlot(buildSlot(slot));
		playerContext.write(CmdCode._59008, builder.build());
		
		//刷新战力
		eventBus.post(DragonChangeEvent.of(playerContext.getId(), GameEvent.DRAGON_CHANGE_PUT));
	}
	
	//调整圣物顺序
	@CMD(id = CmdCode._59009)
	public void changeDragonSort(PlayerContext playerContext, GReqDragonChangeSort msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		Asserts.isTrue(msg.getSlotsCount() == dragon.getSlots().size(), ErrorCode.ERROR_PARAM.getValue(),
				"参数错误，期望" + dragon.getSlots().size() + "参数" + msg.getSlotsCount());
		
		Set<Integer> slotIds = new HashSet<>();
		Set<Integer> relicKind = new HashSet<>();
		for(PSDragonSlot slot : msg.getSlotsList()) {
			Asserts.isTrue(dragon.getSlots().containsKey(slot.getId()), ErrorCode.ERROR_PARAM.getValue(),
					"参数错误，还没有解锁槽位" + slot.getId());
			slotIds.add(slot.getId());
			
			if(slot.getSysId() != 0) {
				CDragonRelic cDragonRelic = dragonRelicSysCache.getOrThrow(slot.getSysId());
				Asserts.isTrue(!relicKind.contains(cDragonRelic.getKind()), ErrorCode.ERROR_PARAM.getValue(),
						"不能装备同类型的圣物");
				relicKind.add(cDragonRelic.getKind());
			}
		}
		Asserts.isTrue(slotIds.size() == msg.getSlotsList().size(), ErrorCode.ERROR_PARAM.getValue(),
				"参数错误，存在重复的槽位ID");
		
		//需要扣除的圣物
		List<ImmutableThing> changeThings = new ArrayList<>();
		for(PSDragonSlot slot : msg.getSlotsList()) {
			if(slot.getSysId() == 0) {
				continue;
			}
			boolean wearing = false;
			for(DragonSlot wearingSlot : dragon.getSlots().values()) {
				if(slot.getSysId() == wearingSlot.getSysId()) {
					wearing = true;
					break;
				}
			}
			if(!wearing) {
				changeThings.add(ImmutableThing.of(slot.getSysId(), 1));
			}
		}
		if(!changeThings.isEmpty()) {
			thingService.cost(playerContext.getId(), changeThings, GameEvent.DRAGON_CHANGE_SORT);
		}
		
		Set<Integer> backToBag = new HashSet<>();
		//将当前装备中的全部看作是需要退回到背包中的
		for(DragonSlot wearingSlot : dragon.getSlots().values()) {
			if(wearingSlot.getSysId() != 0) {
				backToBag.add(wearingSlot.getSysId());
			}
		}
		//从将要回退的物品列表中删除需要装备上的圣物
		for(PSDragonSlot slot : msg.getSlotsList()) {
			if(slot.getSysId() != 0) {
				backToBag.remove(slot.getSysId());
			}
		}
		for(PSDragonSlot slot : msg.getSlotsList()) {
			DragonSlot wearingSlot = dragon.getSlots().get(slot.getId());
			wearingSlot.setSysId(slot.getSysId());
		}
		dragonService.update(dragon);
		if(!backToBag.isEmpty()) {
			List<ImmutableThing> backRewards = new ArrayList<>();
			for(int itemId : backToBag) {
				backRewards.add(ImmutableThing.of(itemId, 1));
			}
			thingService.add(playerContext.getId(), backRewards, GameEvent.DRAGON_CHANGE_SORT, NoticeType.SLIENT);
			//刷新战力
			eventBus.post(DragonChangeEvent.of(playerContext.getId(), GameEvent.DRAGON_CHANGE_SORT));
		}
		
		GResDragonChangeSort.Builder builder = GResDragonChangeSort.newBuilder();
		for(DragonSlot wearingSlot : dragon.getSlots().values()) {
			builder.addSlots(buildSlot(wearingSlot));
		}
		playerContext.write(CmdCode._59009, builder.build());
	}
	
	//圣物图鉴
	@CMD(id = CmdCode._59010)
	public void dragonCollection(PlayerContext playerContext, GReqDragonCollection msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		
		GResDragonCollection.Builder builder = GResDragonCollection.newBuilder();
		builder.addAllSysId(dragon.getManuals());
		playerContext.write(CmdCode._59010, builder.build());
	}
	
	//圣物升星，圣物在背包中时
	@CMD(id = CmdCode._59011)
	public void dragonBallUpStarInBag(PlayerContext playerContext, GReqDragonUpStarInBag msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		
		CDragonRelic cDragonRelic = dragonRelicSysCache.getOrThrow(msg.getSysId());
		Asserts.isTrue(cDragonRelic.getUp_star_type() > 0, ErrorCode.DRAGON_STAR_MAX.getValue(), "该圣物已经达到最大星级");
		
		List<ImmutableThing> upStarCost = new ArrayList<>();
		upStarCost.add(ImmutableThing.of(msg.getSysId(), 1));
		upStarCost.addAll(cDragonRelic.getUp_star_require());
		upStarCost = ImmutableThingUtil.mergeThing(upStarCost);
		thingService.cost(playerContext.getId(), upStarCost, GameEvent.DRAGON_STAR_BAG);
		
		if(!dragon.getManuals().contains(cDragonRelic.getUp_star_type())) {
			dragon.getManuals().add(cDragonRelic.getUp_star_type());
			dragonService.update(dragon);
		}
		ImmutableThing reward = ImmutableThing.of(cDragonRelic.getUp_star_type(), 1);
		thingService.add(playerContext.getId(), reward, GameEvent.DRAGON_STAR_BAG);
		
		GResDragonUpStarInBag.Builder builder = GResDragonUpStarInBag.newBuilder();
		playerContext.write(CmdCode._59011, builder.build());
	}
	
	//圣物升星，圣物在背包中时
	@CMD(id = CmdCode._59012)
	public void dragonBallUpStarInSlot(PlayerContext playerContext, GReqDragonUpStarInSlot msg) {
		Dragon dragon = dragonService.getDragon(playerContext.getId());
		DragonSlot slot = dragon.getSlots().get(msg.getSlotId());
		Asserts.isTrue(slot != null, ErrorCode.DRAGON_SLOT_LOCK.getValue(), "还没有解锁该圣物槽位");
		Asserts.isTrue(slot.getSysId() > 0, ErrorCode.DRAGON_SLOT_EMPTY.getValue(), "该圣物槽位还没有放入圣物");
		
		CDragonRelic cDragonRelic = dragonRelicSysCache.getOrThrow(slot.getSysId());
		Asserts.isTrue(cDragonRelic.getUp_star_type() > 0, ErrorCode.DRAGON_STAR_MAX.getValue(), "该圣物已经达到最大星级");
		
		thingService.cost(playerContext.getId(), cDragonRelic.getUp_star_require(), GameEvent.DRAGON_STAR_SLOT);
		
		if(!dragon.getManuals().contains(cDragonRelic.getUp_star_type())) {
			dragon.getManuals().add(cDragonRelic.getUp_star_type());
		}
		slot.setSysId(cDragonRelic.getUp_star_type());
		dragonService.update(dragon);
		
		GResDragonUpStarInSlot.Builder builder = GResDragonUpStarInSlot.newBuilder();
		builder.setSlot(buildSlot(slot));
		playerContext.write(CmdCode._59012, builder.build());
		
		//刷新战力
		eventBus.post(DragonUpStarEvent.of(playerContext.getId(), GameEvent.DRAGON_STAR_SLOT));
	}
	
	
	//圣物分解
	@CMD(id = CmdCode._59013)
	public void dragonBallResolve(PlayerContext playerContext, GReqDragonResolve msg) {
		Asserts.isTrue(msg.getNum() > 0, ErrorCode.ERROR_PARAM.getValue(), "参数错误" + msg.getNum());
		CDragonRelic cDragonRelic = dragonRelicSysCache.getOrThrow(msg.getSysId());
		
		ImmutableThing cost = ImmutableThing.of(msg.getSysId(), msg.getNum());
		thingService.cost(playerContext.getId(), cost, GameEvent.DRAGON_RESOLVE);
		
		List<ImmutableThing> things = ImmutableThingUtil.multiplyThing(cDragonRelic.getSell(), msg.getNum());
		thingService.add(playerContext.getId(), things, GameEvent.DRAGON_RESOLVE);
		
		playerContext.write(CmdCode._59013, GResDragonResolve.getDefaultInstance());
	}
}
