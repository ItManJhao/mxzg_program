package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;
import com.ayjs.mxzg.config.struct.AttributeType;

import lombok.Getter;

/**
 * 职业
 * @author meiyc
 *
 */
@Getter
@EnumMode(ValueMode.VALUE)
public enum Job {

	
	/** 战士 */
	WARRIOR(1) {
		@Override
		public AttributeType getRestraintAttribute() {
			return AttributeType.WARRIOR_DAMAGE_ADD_PERCENT;
		}
	},
	
	/** 法师 */
	MAGE(2){
		@Override
		public AttributeType getRestraintAttribute() {
			return AttributeType.MAGE_DAMAGE_ADD_PERCENT;
		}
	},
	
	/** 牧师 */
	PRIEST(3) {
		@Override
		public AttributeType getRestraintAttribute() {
			return AttributeType.PRIEST_DAMAGE_ADD_PERCENT;
		}
	},
	
	/** 刺客 */
	ASSASSIN(4){
		@Override
		public AttributeType getRestraintAttribute() {
			return AttributeType.ASSASSIN_DAMAGE_ADD_PERCENT;
		}
	},
	
	/** 游侠 */
	RANGER(5){
		@Override
		public AttributeType getRestraintAttribute() {
			return AttributeType.RANGER_DAMAGE_ADD_PERCENT;
		}
	};
	
	
	private int value; 
	
	private Job(int value){
		this.value = value;
	}
	
	/**
	 * 获取克制的属性
	 * @return
	 */
	public abstract AttributeType getRestraintAttribute();

	public static Job valueOf(int value) {
        for (Job job : Job.values()) {
            if (job.value == value) {
                return job;
            }
        }
        throw new RuntimeException("不存在该job:" + value);
    }
}
