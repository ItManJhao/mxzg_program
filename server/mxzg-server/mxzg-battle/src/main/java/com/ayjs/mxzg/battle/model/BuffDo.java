package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import lombok.Getter;
import lombok.Setter;

/**
 * buff 信息
 * @author meiyc
 *
 */
@Getter
@Setter
public class BuffDo implements Comparable<BuffDo>{

	/** 单位id */
	private int unitId;
	
	/** buff所属的单位id */
	private int targetId;
	
	/** 来源单位id */
	private int sourceId;
	
	/** 过期的回合数 */
	private int expiredRound;
	
	/** Buff配置表 */
	private CBuff buff;
	
	/** 参数值 */
	private long value;

	/** 是否是光环 */
	private boolean halo;
	
	public static BuffDo createOf(int unitId, int targetId, int sourceId, int expiredRound, CBuff buff, boolean halo){
		BuffDo buffDo = new BuffDo();
		buffDo.setUnitId(unitId);
		buffDo.setTargetId(targetId);
		buffDo.setSourceId(sourceId);
		buffDo.setExpiredRound(expiredRound);
		buffDo.setBuff(buff);
		buffDo.setHalo(halo);
		return buffDo;
	}

	/**
	 * 获取buff类型
	 * @return
	 */
	public BuffType getType(){
		return buff.getType();
	}
	
	/**
	 * 让buff过期
	 */
	public void expired(){
		this.expiredRound = -1;
	}
	
	/**
	 * 是否过期
	 * @param currentRound
	 * @return
	 */
	public boolean isExpired(int currentRound){
		return this.expiredRound <= currentRound;
	}


	/**
	 * 是否执行指定的回合buff
	 * @param buffType
	 * @param currentRound
	 * @return
	 */
	public boolean isExecuteRoundBuff(BuffType buffType, int currentRound) {
		if (buffType == BuffType.BT_ROUND_END) {
			return this.buff.getType() == buffType;
		} else if (buffType == BuffType.BT_FIXED_ROUND) {
			return (this.buff.getType() == buffType || this.getType().isFixedRound()) && this.expiredRound == currentRound;
		} else if(buffType == BuffType.BT_ROUND_START) {
			return this.buff.getType().isRoundBuff();
		} else {
			return this.buff.getType() == buffType;
		}
	}
	
	/**
	 * Buff是否冲突
	 * @param buffDo
	 * @return
	 */
	public boolean isConflict(BuffDo buffDo){
		return this.buff.getConflict_type() != 0 && this.buff.getConflict_type() == buffDo.getBuff().getConflict_type();
	}

	/**
	 * 是否是buff触发类型
	 * @param buffType
	 * @return
	 */
	public boolean isTriggerType(BuffType buffType){
		return this.getType() == buffType || this.getType().listenType() == buffType || this.getType().listenType2() == buffType;
	}
	
	/**
	 * 是否是被动技能
	 * @return
	 */
	public boolean isPassiveSkill(){
		return this.expiredRound >= BattleConstant.PASSIVE_ROUND_NUMBER;
	}
	
	/**
	 * 是否是自己的buff
	 * @return
	 */
	public boolean isSelf(){
		return this.targetId == this.sourceId;
	}
	
	/**
	 * 增加值
	 * @param addValue
	 */
	public void addValue(long addValue){
		this.value += addValue;
	}
	
	/**
	 * 转换为buff协议对象
	 * @return
	 */
	public BuffInfo toBuffInfo(){
		return toBuffBuilder().build();
	}
	
	/**
	 * 转换为buffInfo.Builder对象
	 * @return
	 */
	public BuffInfo.Builder toBuffBuilder(){
		BuffInfo.Builder builder = BuffInfo.newBuilder();
		builder.setBuffId(buff.getIdx()).setUnitId(unitId).setExpiredRound(expiredRound).setTargetUnitId(this.targetId).setHit(HitType.HIT.ordinal());
		return builder;
	}
	
	/**
	 * 将buff信息构建到buff构造器里面
	 * @param builder
	 */
	public BuffDo buildBaseTo(BuffInfo.Builder builder){
		if(builder != null){
			builder.setBuffId(this.buff.getIdx()).setUnitId(this.unitId).setHit(HitType.HIT.ordinal());
			builder.setExpiredRound(this.expiredRound).setTargetUnitId(this.targetId);
		}
		return this;
	}
	
	@Override
	public int compareTo(BuffDo o) {
		//原实现是先执行别人的buff再执行自己的buff
		//新逻辑增加对自身buff的排序
		if(this.isSelf() && !o.isSelf()) {
			return 1;
		} else if(!this.isSelf() && o.isSelf()) {
			return -1;
		} else if(!this.isSelf() && !o.isSelf()) {
			return 0;
		} else {
			return Integer.compare(o.getType().getPriority(), this.getType().getPriority());
		}
	}

	@Override
	public String toString() {
		return "BuffDo [" + buff + "]";
	}
	
}
