package com.ayjs.mxzg.config.struct;

/**
 * 伤害类型
 */
public enum DamageType {

    /** 物理伤害 */
    PHYSICAL(1) {
        @Override
        public AttributeType getAdversarialAttributes() {
            return AttributeType.PHYSICAL_RESISTANCE;
        }

        @Override
        public AttributeType getDamageAddPercent() {
            return AttributeType.PHYSICAL_DAMAGE_ADD_PERCENT;
        }

        @Override
        public AttributeType getSpellType() {
            return AttributeType.DRIVE;
        }

        @Override
        public BuffType triggerSkillType() {
            return BuffType.BT_USE_PHYSICAL_SKILL;
        }
    },

    /** 魔法伤害 */
    MAGIC(2) {
        @Override
        public AttributeType getAdversarialAttributes() {
            return AttributeType.MAGIC_RESISTANCE;
        }

        @Override
        public AttributeType getDamageAddPercent() {
            return AttributeType.MAGIC_DAMAGE_ADD_PERCENT;
        }

        @Override
        public AttributeType getSpellType() {
            return AttributeType.INCANTATION;
        }

        @Override
        public BuffType triggerSkillType() {
            return BuffType.BT_USE_MAGIC_SKILL;
        }
    };

	private final int value;
	private DamageType(int value) {
		this.value = value;
	}
	
    /**
     * 获取抗性属性
     * @return
     */
    public abstract AttributeType getAdversarialAttributes();

    /**
     * 获取伤害加深属性
     * @return
     */
    public abstract AttributeType getDamageAddPercent();

    /**
     * 根据伤害类型获取咒语/驱使加成类型
     * @return
     */
    public abstract  AttributeType getSpellType();

    /**
     * 触发技能类型，物理还是法术
     * @return
     */
    public abstract BuffType triggerSkillType();

	public int getValue() {
		return value;
	}
}
