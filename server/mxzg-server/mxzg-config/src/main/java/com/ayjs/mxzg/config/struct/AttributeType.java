package com.ayjs.mxzg.config.struct;

import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;
import lombok.Getter;

import java.util.HashMap;
import java.util.Map;

/**
 * 战斗属性
 *
 * @author meiyc
 */
@Getter
@EnumMode(ValueMode.VALUE)
public enum AttributeType {



    /**
     * 属性占位符，针对被动计算属性的技能有buff也需要添加的情况
     */
    PLACEHOLDER(1),

    /**
     * 位置属性
     */
    POS(2),

    /**
     * 属性效果比例，针对物连法连，针对需要效果减半的属性
     */
    EFFECT_PERCENT(10),

    /**
     * 治疗效果
     */
    TREATMENT(100),

    /**
     * 速度百分比
     */
    SPEED_PERCENT(204) {
        @Override
        public AttributeType getShowType() {
            return AttributeType.SPEED;
        }
    },
    /**
     * 速度
     */
    SPEED(101) {
        @Override
        public AttributeType getPercent() {
            return AttributeType.SPEED_PERCENT;
        }
    },

    /**
     * 血量百分比
     */
    HP_PERCENT(102) {
        @Override
        public AttributeType getShowType() {
            return HP;
        }
    },

    /**
     * 血量上限
     */
    MAX_HP(103),

    /**
     * 额外的血量上限(该血量作为日志记录作用，不在战斗中使用)
     */
    EXTRA_HP_PERCENT(104),

    /**
     * 回复最大生命的百分比血量（该属性作为战斗前恢复血量使用，不能在战斗中使用）
     */
    RECOVER_HP(105),

    /**
     * 成长率
     */
    GROWTH_RATE(120),

    /**
     * 火
     */
    FIRE_GROWTH_RATE(121),

    /**
     * 水
     */
    WATER_GROWTH_RATE(122),

    /**
     * 木
     */
    WOOD_GROWTH_RATE(123),

    /**
     * 光
     */
    LIGHT_GROWTH_RATE(124),

    /**
     * 暗
     */
    DARK_GROWTH_RATE(125),

    /**
     * 额外战力
     */
    EXTRA_ABILITY(130),

    /**
     * 护盾值
     */
    SHIELD(140),

    /**
     * 防御系数
     */
    DEFEND_RAGE(150),

    /**
     * 技能伤害
     */
    SKILL_DAMAGE(200),

    /**
     * 攻击百分比
     */
    ATTACK_PERCENT(201) {
        @Override
        public AttributeType getShowType() {
            return AttributeType.ATTACK;
        }
    },

    /**
     * 防御百分比
     */
    DEFENSE_PERCENT(202) {
        @Override
        public AttributeType getShowType() {
            return AttributeType.DEFENSE;
        }
    },

    /**
     * 破甲百分比
     */
    ARMOR_PERCENT(203),

    /**
     * 治疗百分比
     */
    TREATMENT_PERCENT(205) {
        @Override
        public boolean effectImpact() {
            return true;
        }

        @Override
        public AttributeType getShowType() {
            return AttributeType.TREATMENT;
        }
    },


    /**
     * 被治疗百分比
     */
    BEING_TREATMENT_PERCENT(206),

    /**
     * 暴击比例
     */
    CRIT_PERCENT(207),

    /**
     * 抗暴比例
     */
    RESIST_CRIT_PERCENT(208),

    /**
     * 格挡比例
     */
    BLOCK_PERCENT(210),

    /**
     * 精准
     */
    PRECISION_PERCENT(211),

    /**
     * 免控
     */
    FREE_CONTROL_PERCENT(212),

    /**
     * 沉默抵抗
     */
    SILENCE_RESISTANCE_PERCENT(213),

    /**
     * 缴械抵抗
     */
    DISARM_RESISTANCE_PERCENT(214),

    /**
     * 定身抵抗
     */
    FIXED_RESISTANCE_PERCENT(215),

    /**
     * 冰冻抵抗
     */
    FROZEN_RESISTANCE_PERCENT(216),

    /**
     * 眩晕抵抗
     */
    DIZZINESS_RESISTANCE_PERCENT(217),

    /**
     * 石化抵抗
     */
    PETROCHEMICAL_RESISTANCE_PERCENT(218),

    /**
     * 控制率
     */
    CONTROL_PERCENT(219) {
        @Override
        public boolean effectImpact() {
            return true;
        }
    },

    /**
     * 攻击
     */
    ATTACK(220) {
        @Override
        public AttributeType getPercent() {
            return AttributeType.ATTACK_PERCENT;
        }
    },

    /**
     * 伤害
     */
    DAMAGE(221),

    /**
     * 暴击伤害加成百分比
     */
    CRIT_DAMAGE_PERCENT(222),

    /**
     * 血量
     */
    HP(223),

    /**
     * 防御
     */
    DEFENSE(224) {
        @Override
        public AttributeType getPercent() {
            return AttributeType.DEFENSE_PERCENT;
        }
    },

    /**
     * 神圣伤害
     */
    SACRED_DAMAGE_PERCENT(225),

    /**
     * 命中
     */
    HIT(226),

    /**
     * 闪避
     */
    DODGE(227),

    /**
     * 抵抗，对抗所有debuff的属性
     */
    RESISTANCE(228),

    /**
     * 虚弱
     */
    WEAK(230),

    /**
     * 魔法抗性
     */
    MAGIC_RESISTANCE(240),

    /**
     * 物理抗性
     */
    PHYSICAL_RESISTANCE(241),

    /**
     * 对火的伤害加成
     */
    FIRE_DAMAGE_ADD_PERCENT(251),

    /**
     * 对木的伤害加成
     */
    WOOD_DAMAGE_ADD_PERCENT(252),

    /**
     * 对水的伤害加成
     */
    WATER_DAMAGE_ADD_PERCENT(253),

    /**
     * 对光的伤害加成
     */
    LIGHT_DAMAGE_ADD_PERCENT(254),

    /**
     * 对暗的伤害加成
     */
    DARK_DAMAGE_ADD_PERCENT(255),

    /**
     * 对沉默的伤害加成
     */
    SILENCE_DAMAGE_ADD_PERCENT(260) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_SILENCE;
        }
    },

    /**
     * 对缴械的伤害加成
     */
    DISARM_DAMAGE_ADD_PERCENT(261) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_DISARM;
        }
    },

    /**
     * 对定身的伤害加成
     */
    FIXED_DAMAGE_ADD_PERCENT(262) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_IMMOBILIZ;
        }
    },

    /**
     * 对冰冻的伤害加成
     */
    FROZEN_DAMAGE_ADD_PERCENT(263) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_FROZEN;
        }
    },

    /**
     * 对眩晕的伤害加成
     */
    DIZZINESS_DAMAGE_ADD_PERCENT(264) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_DIZZY;
        }
    },

    /**
     * 对石化的伤害加成
     */
    PETROCHEMICAL_DAMAGE_ADD_PERCENT(265) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_PETRIFY;
        }
    },

    /**
     * 最终伤害加成
     */
    FINAL_DAMAGE_ADD_PERCENT(270),

    /**
     * 物理伤害加深
     */
    PHYSICAL_DAMAGE_ADD_PERCENT(271),

    /**
     * 魔法伤害加深
     */
    MAGIC_DAMAGE_ADD_PERCENT(272),

    /**
     * 最终伤害减免
     */
    FINAL_DAMAGE_REDUCE_PERCENT(291),

    /**
     * 对战士的伤害加成
     */
    WARRIOR_DAMAGE_ADD_PERCENT(281),

    /**
     * 对法师的伤害加成
     */
    MAGE_DAMAGE_ADD_PERCENT(282),

    /**
     * 对牧师的伤害加成
     */
    PRIEST_DAMAGE_ADD_PERCENT(283),

    /**
     * 对刺客的伤害加成
     */
    ASSASSIN_DAMAGE_ADD_PERCENT(284),

    /**
     * 对游侠的伤害加成
     */
    RANGER_DAMAGE_ADD_PERCENT(285),

    /**
     * 物理免伤
     */
    PHYSICAL_INJURY_FREE(292),

    /**
     * 法术免伤，
     */
    MAGIC_FREE(293),

    /**
     * 对灼烧的伤害加成
     */
    BURNING_DAMAGE_ADD_PERCENT(301) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_BURN;
        }
    },

    /**
     * 对霜冻的伤害加成
     */
    FROST_DAMAGE_ADD_PERCENT(302) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_FROST;
        }
    },

    /**
     * 对中毒的伤害加成
     */
    POISONING_DAMAGE_ADD_PERCENT(303) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_POISONE;
        }
    },

    /**
     * 对感电的伤害加成
     */
    ELECTRIC_SHOCK_DAMAGE_ADD_PERCENT(304) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_ELECTRICITY;
        }
    },

    /**
     * 对流血的伤害加成
     */
    BLEED_DAMAGE_ADD_PERCENT(305) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_BLEED;
        }
    },

    /**
     * 对烈火伤害加成
     */
    FIRE_BUFF_DAMAGE_ADD_PERCENT(306) {
        @Override
        public BuffType getActivationBuffType() {
            return BuffType.BT_FIRE;
        }
    },

    /**
     * 灼烧抵抗
     */
    BURNING_RESISTANCE_PERCENT(321),

    /**
     * 霜冻抵抗
     */
    FROST_RESISTANCE_PERCENT(322),

    /**
     * 中毒抵抗
     */
    POISONING_RESISTANCE_PERCENT(323),

    /**
     * 感电抵抗
     */
    FELECTRIC_SHOCK_RESISTANCE_PERCENT(324),

    /**
     * 流血抵抗
     */
    BLEED_RESISTANCE_PERCENT(325),

    /**
     * 烈火伤害加强
     */
    FIRE_DAMAGE_STRENGTHEN(331),
    /**
     * 驱使
     */
    DRIVE(340),

    /**
     * 咒术
     */
    INCANTATION(341),

    /**
     * 擒贼擒王触发概率
     */
    CAPTURE_KING(342),

    /**
     * 位置，（位置不在属性当中，在援助玩法中改变援助英雄的位置的属性）
     */
    POSITION(401),

    ;

    /**
     * 类型值
     */
    private int value;

    private AttributeType(int value) {
        this.value = value;
    }

    /**
     * 获取叠加的百分比属性类型
     *
     * @return
     */
    public AttributeType getPercent() {
        return null;
    }

    /**
     * 如果是受效果影响的属性则需要
     *
     * @return
     */
    public boolean effectImpact() {
        return false;
    }

    /**
     * 获取激活的buff
     *
     * @return
     */
    public BuffType getActivationBuffType() {
        return null;
    }


    private static Map<Integer, AttributeType> typeMap = new HashMap<>();

    static {
        for (AttributeType type : AttributeType.values()) {
            typeMap.put(type.getValue(), type);
        }
    }

    public static AttributeType valueOf(int id) {
        return typeMap.get(id);
    }

    /***
     * 属性变化时，展示给客户端的属性值
     * @return
     */
    public AttributeType getShowType() {
        return this;
    }

}
