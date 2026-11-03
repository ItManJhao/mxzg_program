package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.KindType;
import lombok.Getter;
import lombok.Setter;
import org.apache.commons.collections4.MapUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * 属性信息
 * 
 * @author meiyc
 *
 */
@Getter
@Setter
public class AttributeInfo {

	/** 最大能量 */
	private int maxEnergy = BattleConstant.HERO_FULL_ENERGY;
	
	/** 属性是否初始化 */
	private boolean initialization;
	
	/** 固定血量 */
	private boolean fixedHp;
	
	/** 实时属性 */
	private Map<AttributeType, Long> attributeInfos = new HashMap<>();

	/** 基础属性属性 */
	private Map<AttributeType, Long> baseAttributes = new HashMap<>();

	/** 初始属性 */
	private Map<AttributeType, Long> initAttributes = new HashMap<>();

	/** 一次性属性 */
	private Map<AttributeType, Long> onceAttributes = new HashMap<>();
	
	/** 临时属性属性 */
	private Map<AttributeType, Long> temporaryAttributes = new HashMap<>();

	
	public static AttributeInfo valueOf(Map<AttributeType, Long> baseAttributes) {
		AttributeInfo attributeInfo = new AttributeInfo();
		attributeInfo.getBaseAttributes().putAll(baseAttributes);
		attributeInfo.getInitAttributes().putAll(baseAttributes);
		return attributeInfo;
	}

	public static AttributeInfo createOf(Map<Integer, Long> attributeInfos) {
		Map<AttributeType, Long> attributeMap = new HashMap<>();
		attributeInfos.entrySet().stream().forEach(entry -> {
			attributeMap.put(ConvertUtils.toEnum(entry.getKey(), AttributeType.class), entry.getValue());
		});
		AttributeInfo attributeInfo = new AttributeInfo();
		attributeInfo.getInitAttributes().putAll(attributeMap);
		attributeInfo.getAttributeInfos().putAll(attributeMap);
		attributeInfo.setInitialization(true);
		attributeInfo.setFixedHp(true);
		return attributeInfo;
	}

	/**
	 * 获取攻击
	 * 
	 * @return
	 */
	public long getAttack() {
		long attack = getAttribute(AttributeType.ATTACK);
		double attackRate = getRate(AttributeType.ATTACK_PERCENT);
		return (long) (attack * (1 + attackRate));
	}
	
	/**
	 * 初始化最大血量，血量上限只能增加不能降低
	 */
	private long initMaxHp(){		
		if(this.attributeInfos.containsKey(AttributeType.MAX_HP)){
			return getAttribute(AttributeType.MAX_HP);
		}
		long value = this.initAttributes.getOrDefault(AttributeType.HP, 0L);
		double hpPercent = AttributeUtil.calPercent(this.initAttributes.getOrDefault(AttributeType.HP_PERCENT, 0L));
		long maxHp = (long)(value * (hpPercent + 1.0));
		this.initAttributes.put(AttributeType.MAX_HP, maxHp);
		this.attributeInfos.put(AttributeType.MAX_HP, maxHp);
		this.attributeInfos.put(AttributeType.HP, maxHp);
		return maxHp;
	}
	
	/**
	 * 获取最大血量
	 * @return
	 */
	public long getMaxHp(){
		return getAttribute(AttributeType.MAX_HP);
	}
	
	/**
	 * 获取属性百分比
	 * 
	 * @param type
	 * @return
	 */
	public double getRate(AttributeType type) {
		long value = getAttribute(type);
        value = Math.min(value, 50000);
		return AttributeUtil.calPercent(value);
	}
	
	/**
	 * 获取属性有叠加百分比属性
	 * 
	 * @param type
	 * @return
	 */
	public long getAttribute(AttributeType type) {
		Long temporaryValue = onceAttributes.remove(type);
		if (temporaryValue != null) {
			return temporaryValue;
		}

		long value = _getAttribute(type);
		double basePercent = 1;
		AttributeType percentType = type.getPercent();
		if (percentType != null) {
			basePercent += getRate(percentType);
		}

		value *= basePercent;

		if(type.effectImpact()){
			double effectImpactRate = getRate(AttributeType.EFFECT_PERCENT);
			value += value * effectImpactRate;
		}

		return value;
	}

	/**
	 * 修改最大血量
	 * 
	 * @param updateValue
	 */
	public void updateMaxHp(long updateValue) {
		if(this.initialization){
			long extraHpPercent = this.attributeInfos.getOrDefault(AttributeType.EXTRA_HP_PERCENT, 0L);
			long hpPercent = this.attributeInfos.getOrDefault(AttributeType.HP_PERCENT, 0L);
			hpPercent += updateValue;
			if(extraHpPercent > 0){
				long remainingPercent = updateValue - extraHpPercent;
				updateValue = remainingPercent > 0 ? remainingPercent : 0;
				extraHpPercent = remainingPercent > 0 ? 0 : Math.abs(remainingPercent);
				this.attributeInfos.put(AttributeType.EXTRA_HP_PERCENT, extraHpPercent);
			}
			if(updateValue > 0){
				long initHp = calInitHp(hpPercent - updateValue);
				long maxHp = this.attributeInfos.getOrDefault(AttributeType.MAX_HP, 0L);
				long newMaxHp = (long)(initHp * (1 + AttributeUtil.calPercent(hpPercent)));
				this.attributeInfos.put(AttributeType.MAX_HP, newMaxHp);
				if(!this.fixedHp){
					long addHp = newMaxHp - maxHp;
					updateAttribute(AttributeType.HP, addHp);
				}
			}
			this.attributeInfos.put(AttributeType.HP_PERCENT, hpPercent);
		} else {
			addInitAttribute(AttributeType.HP_PERCENT, updateValue);
		}
	}
	
	/**
	 * 计算初始属性
	 * @param hpPercent
	 * @return
	 */
	private long calInitHp(long hpPercent){
		long maxHp = this.attributeInfos.getOrDefault(AttributeType.MAX_HP, 0L);
		return (long)Math.ceil(maxHp / (1 + (hpPercent  / BattleConstant.PERCENTAGE_RATIO)));
	}

	/**
	 * 设置一次性属性
	 * 
	 * @param type
	 * @param value
	 */
	public void setOnceAttribute(AttributeType type, long value) {
		this.onceAttributes.put(type, value);
	}

	/**
	 * 增加一次性属性
	 *
	 * @param type
	 * @param value
	 */
	public void addOnceAttribute(AttributeType type, long value) {
		long attribute = this.getAttribute(type);
		attribute += value;
		this.onceAttributes.put(type, attribute);
	}

	/**
	 * 获取属性
	 * 
	 * @param type
	 * @return
	 */
	private long _getAttribute(AttributeType type) {
		return attributeInfos.getOrDefault(type, 0L);
	}

	/**
	 * 批量修改属性
	 * @param attributes
	 */
	public void updateAttributes(Map<AttributeType, Long> attributes) {
		if(MapUtils.isEmpty(attributes)){
			return;
		}
		for (Map.Entry<AttributeType, Long> entry : attributes.entrySet()) {
			updateAttribute(entry.getKey(), entry.getValue());
		}
	}

	/**
	 * 增量修改属性
	 * @param type
	 * @param value
	 * @return 实际修改的属性
	 */
	public long updateAttribute(AttributeType type, long value) {
		if(type == AttributeType.HP_PERCENT){
			updateMaxHp(value);
			return value;
		}

		long currentValue = _getAttribute(type);
		currentValue += value;
		long updateValue = currentValue >= 0 ? value : value - currentValue;
		this.attributeInfos.put(type, currentValue);
		return updateValue;
	}
	
	/**
	 * 设置属性
	 * 
	 * @param type
	 * @param value
	 */
	public void setAttribute(AttributeType type, long value) {
		this.attributeInfos.put(type, value);
	}

	/**
	 * 添加效果属性
	 * @param effectPercent
	 */
	public void setEffect(long effectPercent){
		setAttribute(AttributeType.EFFECT_PERCENT, effectPercent);
	}

	/**
	 * 清空效果属性
	 */
	public void cleanEffect(){
		setAttribute(AttributeType.EFFECT_PERCENT, 0);
	}
	
	/**
	 * 添加属性
	 * @param kind
	 */
	public void addAttributeKind(AttributeKind kind){
		AttributeType attributeType = ConvertUtils.toEnum(kind.getType(), AttributeType.class);
		if(kind.getKind() == KindType.ADDITION){
			addInitAttributePercent(attributeType, kind.getValue());
		} else {
			this.initAttributes.put(attributeType, kind.getValue());
		}
	}
	
	/**
	 * 增加初始属性百分比
	 * @param type
	 * @param percent
	 */
	private void addInitAttributePercent(AttributeType type, long percent) {
		long attributeValue = this.initAttributes.getOrDefault(type, 0L);
		attributeValue = AttributeUtil.addPercent(attributeValue, percent);
		this.initAttributes.put(type, attributeValue);
	}
	
	/**
     * 批量增加初始属性 QueryBattleCommand 和QueryHeroCommand的接收者应该调用该方法添加属性;
	 * @param attributes
	 */
	public void addAllAttribute(Map<AttributeType, Long> attributes) {
		attributes.forEach(this::addInitAttribute);
	}
	
	/**
	 * 添加临时初始属性，该属性只对当场战斗有效，在返回HeroVo时不包含该属性
     * BattleCommand响应者增加的属性应该添加到这里
	 * @param attributes
	 */
	public void addTemporaryAttribute(Map<AttributeType, Long> attributes) {
		attributes.forEach(this::addTemporaryAttribute);
	}

	/**
	 * 增加初始属性
	 * @param type
	 * @param value
	 */
	public void addInitAttribute(AttributeType type, long value) {
		long attributeValue = this.initAttributes.getOrDefault(type, 0L);
		attributeValue += value;
        this.initAttributes.put(type, attributeValue);
		if(type == AttributeType.GROWTH_RATE){
			for (Map.Entry<AttributeType, Long> entry : this.getBaseAttributes().entrySet()) {
				long attribute = entry.getValue();
				addInitAttribute(entry.getKey(), AttributeUtil.addPercent(attribute, value));
			}
		}
	}

	public Map<AttributeType, Long> getTemporaryAttributes(){
		return this.temporaryAttributes;
	}
	
	/**
	 * 增加临时属性
	 * @param type
	 * @param value
	 */
	private void addTemporaryAttribute(AttributeType type, long value) {
		long attributeValue = this.temporaryAttributes.getOrDefault(type, 0L);
		attributeValue += value;
		this.temporaryAttributes.put(type, attributeValue);
	}
	
	/**
	 * 获取属性，如果初始化则获取实时属性否则获取初始化属性
	 * @return
	 */
	public Map<Integer, Long> getAttributeValues(){
		Map<Integer, Long> attributes = new HashMap<>();
		this.initAttributes.entrySet().forEach(entry->attributes.putIfAbsent(entry.getKey().getValue(), entry.getValue()));
		if(this.initialization){
			long initHpPercent = this.initAttributes.getOrDefault(AttributeType.HP_PERCENT, 0L);
			long hpPercent = this.attributeInfos.getOrDefault(AttributeType.HP_PERCENT, 0L);
			attributes.put(AttributeType.EXTRA_HP_PERCENT.getValue(), hpPercent - initHpPercent);
			long hp = this.attributeInfos.getOrDefault(AttributeType.HP, 0L);
			long maxHp = this.attributeInfos.getOrDefault(AttributeType.MAX_HP, 0L);
			attributes.put(AttributeType.HP.getValue(), hp);
			attributes.put(AttributeType.MAX_HP.getValue(), maxHp);
		} else {
			long maxHp = initMaxHp();
			attributes.put(AttributeType.MAX_HP.getValue(), maxHp);
			attributes.put(AttributeType.HP.getValue(), maxHp);
		}
		return attributes;
	}
	
	/**
	 * 初始化属性
	 */
	public void initAttribute() {
		if(!this.initialization){
			this.initMaxHp();
			this.initAttributes.forEach(this.attributeInfos::putIfAbsent);
			this.initialization = true;
		}

		this.temporaryAttributes.forEach(this::updateAttribute);
		this.temporaryAttributes.clear();
	}

}
