package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.EffectType;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * buff 信息
 * @author meiyc
 *
 */
@Getter
@Setter
public class BuffsInfo {

	/**	携带的buff */
	private List<BuffDo> buffs = new ArrayList<>();
	/** 触发次数<buffId, 触发次数> */
	private Map<Integer, Integer> triggerTimes = new HashMap<Integer, Integer>();
    /** 回合比较器 */
    private Comparator<BuffDo> buffRoundComparator = (buff1, buff2)-> Integer.compare(buff1.getExpiredRound(), buff2.getExpiredRound());
	/** 最后过期的buff*/
    private BuffDo lastExpiredBuff;
	
	public static BuffsInfo getInstance(){
		return new BuffsInfo();
	}
	
	public static BuffsInfo createOf(Map<Integer, Integer> triggerTimes){
		BuffsInfo buffsInfo = getInstance();
		if(triggerTimes != null){
			buffsInfo.setTriggerTimes(triggerTimes);
		}
		return buffsInfo;
	}
	
	/**
	 * 添加buff并返回冲突的buff列表
	 * @param buffDo
	 * @return
	 */
	public List<BuffDo> addBuffAndRtnRemoveBuffs(BuffDo buffDo){
		List<BuffDo> removeBuffs = this.buffs.stream().filter(buffDo::isConflict).collect(Collectors.toList());
        BuffDo overflowBuff = getNumberLayersExceeded(buffDo);
        if(overflowBuff != null){
            removeBuffs.add(overflowBuff);
        }
		this.buffs.add(buffDo);
		return removeBuffs;
	}

	/**
	 * 获取添加该buff造成的溢出buff
	 * @param buffDo
	 * @return
	 */
	private BuffDo getNumberLayersExceeded(BuffDo buffDo){
        List<BuffDo> buffDos = buffDo.getType().isAttributeBuff() ? getBuffersByType(buffDo.getBuff().getIdx(), buffDo.getSourceId()) :
				getBuffersByType(buffDo.getType(), buffDo.getSourceId());
        if(buffDos.size() >= buffDo.getBuff().getStacking_max()){
            buffDos.sort(this.buffRoundComparator);
            return buffDos.get(0);
        }
        return null;
	}
	
	/**
	 * 移除buff，并让buff过期
	 * @param buffDo
	 */
	public void removeBuff(BuffDo buffDo){
		this.buffs.remove(buffDo);
		this.lastExpiredBuff = buffDo;
	}
	
	/**
	 * 是否有指定的buff
	 * @param buffType
	 * @return
	 */
	public boolean haveBuff(BuffType buffType){
		return buffs.stream().anyMatch(buff -> buff.getType() == buffType);
	}
	
	/**
	 * 是否有buff列表中的其中一种buff类型
	 * @param types
	 * @return
	 */
	public boolean haveBuff(Set<BuffType> types){
		return buffs.stream().anyMatch(buff -> types.contains(buff.getType()));
	}
	
	/**
	 * 根据buff类型获取buff列表
	 * @param buffType
	 * @return
	 */
	public List<BuffDo> getBuffersByType(BuffType buffType){
		return buffs.stream().filter(buff-> buff.getType() == buffType).collect(Collectors.toList());
	}

	/**
	 * 获取护盾buff
	 * @return
	 */
	public List<BuffDo> getShieldBuffs(){
		return buffs.stream().filter(buff-> buff.getType().isShield()).collect(Collectors.toList());
	}

	/**
	 * 根据buff类型和来源英雄获取buff列表
	 * @param buffId
	 * @param sourceId
	 * @return
	 */
	public List<BuffDo> getBuffersByType(int buffId, int sourceId){
		return buffs.stream().filter(buff-> buff.getBuff().getIdx() == buffId && buff.getSourceId() == sourceId).collect(Collectors.toList());
	}

    /**
     * 根据buff类型和来源英雄获取buff列表
     * @param buffType
     * @param sourceId
     * @return
     */
    public List<BuffDo> getBuffersByType(BuffType buffType, int sourceId){
        return buffs.stream().filter(buff-> buff.getType() == buffType && buff.getSourceId() == sourceId).collect(Collectors.toList());
    }

	/**
	 * 根据buff效果类型获取buff，且buff不能为被动或不可驱散
	 * @param effectType
	 * @return
	 */
	public List<BuffDo> getBuffersBy(EffectType effectType){
		return buffs.stream().filter(buff-> buff.getExpiredRound()< 999 && buff.getBuff().isDispelled() && buff.getBuff().getEffecttype() == effectType).collect(Collectors.toList());
	}
	
	/**
	 * 触发buff 
	 * @param buffId
	 * @param maxTriggerTimes
	 * @return 是否触发成功
	 */
	public boolean triggerBuff(int buffId, int maxTriggerTimes){
		int triggerTimes = this.triggerTimes.getOrDefault(buffId, 0);
		if(triggerTimes >= maxTriggerTimes){
			return false;
		}
		this.triggerTimes.put(buffId, ++triggerTimes);
		return true;
	}
}
