package com.ayjs.mxzg.battle.model;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * 玩家战场信息
 * @author meiyc
 *
 */
@Setter
@Getter
public class BattlerInfo {

	/** 玩家id */
	private long playerId;
	
	/** 玩家名称 */
	private String name;
	
	/** 女神 */
	private Goddess goddess;
	
	/** 英雄 */
	private List<HeroDo> heroDos;
	
	
	public static BattlerInfo createOf(long playerId, String name){
		BattlerInfo battlerInfo = new BattlerInfo();
		battlerInfo.setPlayerId(playerId);
		battlerInfo.setName(name);
		return battlerInfo;
	}
	
	/**
	 * 添加女神
	 * @param goddess
	 */
	public void addGoddess(Goddess goddess){
		this.goddess = goddess;
	}
	
	
	/**
	 * 添加英雄
	 * @param heroDos
	 */
	public void addHeros(List<HeroDo> heroDos){
		this.heroDos = heroDos;
	}
	
}
