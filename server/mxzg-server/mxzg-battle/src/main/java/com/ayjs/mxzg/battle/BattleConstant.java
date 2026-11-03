package com.ayjs.mxzg.battle;

import com.google.common.collect.Sets;

import java.util.Set;

/**
 * 战斗常量配置
 * @author meiyc
 *
 */
public interface BattleConstant {

    /**
     * 一排(行)数量
     */
    int ROW_NUMBER = 4;
	/** 前排 */
	Set<Integer> FRONT_POSITION = Sets.newHashSet(1, 2, 3, 4);

    /**
     * 后排
     */
    Set<Integer> REAR_POSITION = Sets.newHashSet( 5, 6, 7, 8);
	
	/** 英雄满能量值，不是上限，满值后释放技能 */
	int HERO_FULL_ENERGY = 100;
	
	/** 英雄初始能量 */
	long HERO_INIT_ENERGY = 50;
	
	/** 普通攻击增加能量 */
	int ATTACK_ENERGY = 50;
	
	/** 被攻击增加能量 */
	int BE_ATTACKED_ENERGY = 10;
	
	/** 被暴击增加能力 */
	int BE_CRIT_ENERGY = 20;
	
	/** 羁绊女神最大能量 */
	int GODDESS_MAX_ENERGY = 3;
	
	/** 羁绊女神每回合恢复能量 */
	int GODDESS_ROUND_RESTORE_ENERGY = 1;
	
	/** 战斗最大回合数 */
	int BATTLE_MAX_ROUND = 15;
	
	/** 先手速度 */
	long FIRST_SPEED = 999999L;
	
	/** 万分比 */
	double PERCENTAGE_RATIO = 10000D;

	/** 万分比 */
	long LONG_PERCENTAGE_RATIO = 10000;
	
	/** 格挡减伤比例 */
	double BLOOK_REDUCE_RATE = 0.3;
	
	/** 如暴击格挡额外减伤0.2 */
	double CRIT_BLOOK_REDUCE_RATE = 0.2;
	
	/** 精准最大伤害加成比例 0.45 */
	double PRECISION_DAMAGE_MAX_ADD_PERCENT = 0.45;
	
	/** 最大目标个数 */
	int MAX_TARGET_NUM = 99;
	
	/** 最大星级 */
	int MAX_STAR = 13;
	
	/** 被动技能的回合数 */
	int PASSIVE_ROUND_NUMBER = 999;

	/** 能量伤害加成上限 2.0 */
	double ENERGY_DAMAGE_UP_LIMIT = 2.0;

	/** 技能动作时间（ms） */
	int SKILL_ACTION_TIME = 1500;

	/** 技能必杀播放时间（ms） */
	int SKILL_KILL_TIME = 2000;

	/** 羁绊技能动作时间（ms） */
	int GODDESS_SKILL_ACTION_TIME = 1000;

	/** 羁绊空闲动作时间（ms） */
	int GODDESS_FREE_ACTION_TIME = 100;

	/** buff飘字间隔时间*/
	int BUFF_INTERVAL_TIME = 100;

	/** 羁绊技能动作时间（ms） */
	int DRAGON_SKILL_ACTION_TIME = 1000;

	/** 援助buffId */
	int HELPER_BUFF_ID = 13000001;

	/** 擒贼擒王skillId*/
	int CAPTURE_KING_SKILL_ID = 2000000001;
}
