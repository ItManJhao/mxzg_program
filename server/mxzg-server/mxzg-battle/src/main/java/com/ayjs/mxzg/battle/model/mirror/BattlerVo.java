package com.ayjs.mxzg.battle.model.mirror;

import com.ayjs.mxzg.battle.model.BattlerDo;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 战场镜像数据
 * @author meiyc
 *
 */
@Getter
@Setter
public class BattlerVo {
	
	/** 玩家id */
	private long playerId;

	/** 单位类型 */
	private int unitType;
	
	/** 女神id */
	private GoddessVo goddess;

	/** 神龙 */
	private DragonVo dragonVo;
	
	/** 英雄列表 */
	private List<HeroVo> heros = new ArrayList<>();

	/** 阵法 */
	private int formationId;

	
	public static BattlerVo createOf(BattlerDo battlerDo){
		BattlerVo battlerVo = new BattlerVo();
		battlerVo.setPlayerId(battlerDo.getPlayerId());
		battlerVo.setUnitType(battlerDo.getUnitType().ordinal());
		battlerVo.setGoddess(GoddessVo.valueOf(battlerDo.getGoddess()));
		battlerVo.setDragonVo(DragonVo.valueOf(battlerDo.getDragonInfo()));
		List<HeroVo> heroVos = battlerDo.getHeroAndContainHelper().stream().map(HeroVo::valueOf).collect(Collectors.toList());
		battlerVo.setHeros(heroVos);
		battlerVo.setFormationId(battlerDo.getFormationId());
		return battlerVo;
	}

	/**
	 * 保存能量到下一次战斗
	 */
	public void saveEnergy(){
		if(goddess != null){
		    goddess.setSaveEnergy(true);
        }
	}

	/**
	 * 保存触发次数
	 */
	public void saveTriggerTimes(){
		heros.stream().forEach(heroVo-> heroVo.setSaveTriggerTimes(true));
	}
	
	/**
	 * 获取指定位置的HeroVO
	 * @param position
	 * @return
	 */
	public HeroVo getHeroBy(int position){
		Optional<HeroVo> heroVo = heros.stream().filter(hero-> hero.getPos() == position).findFirst();
		return heroVo.orElse(null);
	}

	/**
	 * 获取第一个英雄的名字
	 * @return
	 */
	public String getFirstHeroName(){
		return this.heros.get(0).getName();
	}

	/**
	 * 全体回血万分比
	 * @param percent 万分比值
	 */
	public void wholeBloodPercent(int percent){
		this.heros.stream().forEach(heroVo-> heroVo.recoverHP(percent));
	}

	/**
	 * 已经被击败
	 * @return
	 */
	public boolean isBeat(){
		return this.heros.stream().allMatch(HeroVo::isDead);
	}

	/**
	 * 获取死亡的英雄主键id列表
	 * @return
	 */
	public List<Long> deadIds(){
		return this.heros.stream().filter(HeroVo::isDead).map(HeroVo::getId).collect(Collectors.toList());
	}
}
