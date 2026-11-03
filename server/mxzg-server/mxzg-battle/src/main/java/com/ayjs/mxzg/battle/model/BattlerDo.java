package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.BattleGMsg.BattlerUnit;
import lombok.Getter;
import lombok.Setter;
import org.apache.commons.collections4.CollectionUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * 战场玩家领域对象
 * @author meiyc
 *
 */
@Getter
@Setter
public class BattlerDo {

	/** 玩家id */
	private long playerId;

	/** 名称 */
	private String name;

	/** 服务器id */
	private int serverId;

	/**头像ID */
	private int headId;

	/** 头像框ID */
	private int borderId;

	/** 等级 */
	private int level;

	/** 战力 */
	private int fighting;

	/** 阵营 */
	private Faction faction;

	/** 单位类型 */
	private UnitType unitType;

	/** 女神 */
	private Goddess goddess;

	/** 圣龙 */
	private DragonInfo dragonInfo;

	/** 英雄列表 */
	private List<HeroDo> heros = new ArrayList<>();

	/** 死亡的英雄列表 */
	private List<HeroDo> deads = new ArrayList<>();

	/** 援助英雄 */
	private HeroDo helper;

	/** 阵法id */
	private int formationId;

	/** 测试用 3 则只放1技能 4则只放2技能 */
	private int testType;


	public static BattlerDo createOf(long playerId, String name, Faction faction, UnitType unitType, List<HeroDo> heros, Goddess goddess, int formationId, DragonInfo dragonInfo){
		BattlerDo battlerDo = new BattlerDo();
		battlerDo.setPlayerId(playerId);
		battlerDo.setName(name);
		battlerDo.setFaction(faction);
		battlerDo.setUnitType(unitType);
		battlerDo.setHeros(heros);
		battlerDo.setGoddess(goddess);
		battlerDo.setFormationId(formationId);
		battlerDo.setDragonInfo(dragonInfo);
		return battlerDo;
	}

	/**
	 * 设置角色基本信息
	 * @param serverId
	 * @param headId
	 * @param borderId
	 * @param level
	 * @param fighting
	 */
	public void setRoleInfo(int serverId, int headId, int borderId, int level, int fighting){
		this.serverId = serverId;
		this.headId = headId;
		this.borderId = borderId;
		this.level = level;
		this.fighting = fighting;
	}

	/**
	 * 初始化
	 * @param unitIdBuilder
	 */
	public void initialize(AtomicInteger unitIdBuilder){
		if(this.goddess != null){
			this.goddess.initialize(unitIdBuilder.incrementAndGet(), this.faction);
		}

		if(this.dragonInfo != null){
			this.dragonInfo.initialize(unitIdBuilder.incrementAndGet(), this.faction);
		}

		List<HeroDo> deads = new ArrayList<>();
		for(HeroDo hero : getAllHeros()){
			hero.setUnitId(unitIdBuilder.incrementAndGet());
			hero.setFaction(this.faction);
			hero.initAttribute();
			if(hero.isDead()){
				deads.add(hero);
			}
			if(hero.isHelper()){
				this.helper = hero;
			}
		}
		if(this.helper != null){
			this.heros.remove(this.helper);
		}
		this.heros.removeAll(deads);
		this.deads.addAll(deads);
	}

	/**
	 * 是否所有英雄全部死亡
	 * @return
	 */
	public boolean isDead(){
		return CollectionUtils.isEmpty(heros) && (this.helper == null || this.helper.isDead());
	}


	/**
	 * 英雄死亡
	 * @param heroDo
	 */
	public void heroDeath(HeroDo heroDo){
		if(heros.remove(heroDo)){
			deads.add(heroDo);
		}
	}

	/**
	 * 复活英雄
	 * @param heroDo
	 */
	public void resurrection(HeroDo heroDo){
		heroDo.setStatus(HeroStatus.SURVIVE);
		if(this.deads.remove(heroDo)){
			this.heros.add(heroDo);
		}
	}

	/**
	 * 获取所有英雄列表(不包含助阵英雄)
	 * @return
	 */
	public List<HeroDo> getAllHeros(){
		List<HeroDo> all = new ArrayList<>();
		all.addAll(this.heros);
		all.addAll(this.deads);
		return all;
	}

	/**
	 * 获取所有英雄列表
	 * @return
	 */
	public List<HeroDo> getHeroAndContainHelper(){
		List<HeroDo> all = getAllHeros();
		if (this.helper != null && !all.contains(this.helper)) {
			all.add(this.helper);
		}
		return all;
	}

	/**
	 * 获取存活的英雄列表
	 * @return
	 */
	public List<HeroDo> getHeros(){
		return new ArrayList<>(this.heros);
	}

	/**
	 * 根据回合回返回有先手技能的英雄列表
	 * @param round
	 * @return
	 */
	public List<HeroDo> getFirsts(int round){
		return this.heros.stream().filter(heroDo-> heroDo.currentSkillIsFirst(round)).collect(Collectors.toList());
	}

	/**
	 * 获取先手英雄
	 * @return
	 */
	public HeroDo getFirst(){
		return this.heros.stream().sorted((h1, h2) -> Long.compare(h2.getSpeed(), h1.getSpeed())).findFirst().get();
	}

	/**
	 * 设置先手英雄
	 * @param firstPos
	 */
	public void setFirstPos(int firstPos){
		if(this.heros.isEmpty()){return;}
		int firstIndex = firstPos < this.heros.size() ? firstPos : firstPos%this.heros.size();
		HeroDo heroDo = this.heros.get(firstIndex);
		heroDo.getAttributeInfo().getTemporaryAttributes().put(AttributeType.SPEED, BattleConstant.FIRST_SPEED);
	}

	/**
	 * 设置英雄全部被秒杀（hp = 1）
	 */
	public void setAllSpikes(){
		this.heros.forEach(hero-> {hero.getAttributeInfo().getInitAttributes().put(AttributeType.HP, 1L);});
	}


	/**
	 * 设置英雄为无敌状态
	 */
	public void setInvincible(){
		this.heros.forEach(this::setSandbag);
	}

	/**
	 * 封印被动技能，
	 */
	public void seal(){
		this.heros.forEach(heroDo -> heroDo.setHangUpSeal(true));
	}

	/**
	 * 设置为沙包
	 * @param hero
	 */
	private void setSandbag(HeroDo hero){
		hero.getAttributeInfo().getInitAttributes().put(AttributeType.HP, 9999999999L);
		hero.getAttributeInfo().getInitAttributes().put(AttributeType.ATTACK, 1L);
		hero.getAttributeInfo().setMaxEnergy(99999);
		hero.getSkillInfo().getSkills().clear();
	}

	/**
	 * 援助英雄上阵
	 * @param heroDo
	 */
	public void helperInBattle(HeroDo heroDo){
		this.heros.add(this.helper);
		this.deads.remove(heroDo);
		this.helper = heroDo;
		this.helper.setPosition(9);
	}

	/**
	 * 转换成protocol
	 * @return
	 */
	public BattlerUnit toBattleUnit(){
		BattlerUnit.Builder unit = BattlerUnit.newBuilder();
		unit.setPlayerId(this.playerId).setName(this.name);
		unit.setFormationId(this.formationId);
		if(this.goddess != null){
			unit.setGoddess(this.goddess.toGoddessUnit());
		}
		if(this.dragonInfo != null){
			unit.setDragon(this.dragonInfo.toDragonUnit());
		}

		getHeroAndContainHelper().forEach(hero-> unit.addHeros(hero.toHeroUnit()));
		return unit.build();
	}

	/**
	 * 转换成战场vo
	 * @return
	 */
	public BattlerVo toBattlerVo(){
		return BattlerVo.createOf(this);
	}

	/**
	 * 构建英雄日志
	 */
	public BattleGMsg.BattlerFightLog buildHeroLog() {
		List<BattleGMsg.HeroLog> heroLogs = this.getHeroAndContainHelper().stream().map(HeroDo::buildHeroLog).collect(Collectors.toList());
		BattleGMsg.BattlerFightLog.Builder builder = BattleGMsg.BattlerFightLog.newBuilder();
		builder.addAllHeroLog(heroLogs).setRid(this.playerId).setName(this.name).setBorderId(this.borderId);
		builder.setHeadId(this.headId).setLevel(this.level).setServerId(this.serverId).setFighting(this.fighting);
		builder.setFormationId(this.formationId);
		return builder.build();
	}

	/**
	 * 获取携带指定buff的存活英雄
	 * @param buffType
	 * @return
	 */
	public List<HeroDo> getHeroByBuff(BuffType buffType) {
		return this.getHeros().stream().filter(hero -> hero.haveBuff(buffType)).collect(Collectors.toList());
	}

	/**
	 * 获取指定元素的英雄
	 * @param elem
	 * @return
	 */
	public List<HeroDo> getHeroByElem(int elem) {
		return this.getHeros().stream().filter(hero -> hero.getElementMul().getIdx() == elem).collect(Collectors.toList());
	}
}
