package com.ayjs.mxzg.config.struct;

import java.util.Set;


public enum ActiveType {

	/** 被动 */
	PASSIVE {
		@Override
		public BuffType getUseTriggerType() {
			throw new RuntimeException("错误的调用");
		}

		@Override
		public BuffType getDamageTriggerType() {
			throw new RuntimeException("错误的调用");
		}

		@Override
		public Set<BuffType> prohibitBuffs() {
			throw new RuntimeException("错误的调用");
		}

		@Override
		public BuffType getBeattackTriggerType() {
			throw new RuntimeException("错误的调用");
		}
	} ,
	
	/** 技能 */
	SKILL {
		@Override
		public Set<BuffType> prohibitBuffs() {
			return BuffType.PROHIBIT_SKILL_BUFFS;
		}

		@Override
		public BuffType getUseTriggerType() {
			return BuffType.BT_USE_SKILL;
		}
		@Override
		public BuffType getDamageTriggerType() {
			return BuffType.BT_ATTACK_SKILL_SELF;
		}
		
		@Override
		public BuffType getBeattackTriggerType() {
			return BuffType.BT_BEATTACK_SKILL;
		}
	},
	
	/** 普攻 */
	ORDINARY {
		@Override
		public Set<BuffType> prohibitBuffs() {
			return BuffType.PROHIBIT_ATTACK_BUFFS;
		}

		@Override
		public BuffType getUseTriggerType() {
			return BuffType.BT_USE_ATTACK;
		}

		@Override
		public BuffType getDamageTriggerType() {
			return BuffType.BT_ATTACK_SELF;
		}

		@Override
		public BuffType getBeattackTriggerType() {
			return BuffType.BT_BEATTACK_ATTACK;
		}
	},

	/** 光环 */
	HALO {
		@Override
		public BuffType getUseTriggerType() {
			throw new RuntimeException("错误的调用");
		}

		@Override
		public BuffType getDamageTriggerType() {
			throw new RuntimeException("错误的调用");
		}

		@Override
		public Set<BuffType> prohibitBuffs() {
			throw new RuntimeException("错误的调用");
		}

		@Override
		public BuffType getBeattackTriggerType() {
			throw new RuntimeException("错误的调用");
		}
	} ,;

	
	/**
	 * 获取禁止的技能
	 * @return
	 */
	public abstract Set<BuffType> prohibitBuffs();
	
	/**
	 * 获取使用该技能类型触发的buff
	 * @return
	 */
	public abstract BuffType getUseTriggerType();
	
	/**
	 * 获取使用该技能类型造成伤害触发的buff
	 * @return
	 */
	public abstract BuffType getDamageTriggerType();
	
	/**
	 * 获取被攻击触发的buff
	 * @return
	 */
	public abstract BuffType getBeattackTriggerType();
	
}
