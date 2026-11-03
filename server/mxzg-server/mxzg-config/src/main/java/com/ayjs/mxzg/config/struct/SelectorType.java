package com.ayjs.mxzg.config.struct;

import lombok.Getter;

/**
 * 目标类型
 * @author meiyc
 *
 */
@Getter
public enum SelectorType {

    /** 移除自己（筛选）*/
    REMOVE_SELF(0),
    /** 自己（筛选） */    
    SELF(1),               
    /** 友方（加法） */	
    FRIEND(2),
    /** 敌人（加法) */
    ENEMY(3),
    /**
     * 存活（筛选）(target_num)
     */
    SURVIVE(4),
    /** 死亡（筛选)(target_num)*/
    DEAD(5),                
    /** 前排（筛选）（只选择存活目标） */
    FRONT(6),               
    /** 后排（筛选）（只选择存活目标） */ 
    REAR(7),                
    /** 随机（筛选）(target_num) */
    RAND(8),                
    /** 血量正序（多）(target_num) */
    HP_POSITIVE(9),
    /**
     * 默认位置（筛选）(target_num)
     */
    POS(10),                  
    /** 血量倒序（少）(target_num)*/
    HP_REVERSE(11),
    /** 攻击最高 (target_num)*/
    HIGHEST_ATTACK(12),
    /** 攻击最低  (target_num)*/
    LOWEST_ATTACK(13),
    /** 速度最高  (target_num)*/
    HIGHEST_SPEED(14),
    /** 速度最低 (target_num)*/
    LOWEST_SPEED(15),
    /** 防御最高 (target_num)*/
    HIGHEST_DEFENSE(16),
    /** 防御最低 (target_num)*/
    LOWEST_DEFENSE(17),
    /**
     * 前方一列(target_num)
     */
    FORWARD_COLUMN(18),
    /**
     * 最多的一列
     */
    MAX_COLUMN(19),
    /** 最多的行(排) */
    MAX_ROW(20),
    /** 职业选择器 (target_num)*/
    JOB_SELECTOR(21),
    /** Buff选择器(target_num) */
    BUFF_SELECTOR(22),
    /**
     * 前后排选择器，随机, 1前排，2后排(target_num)
     */
    FRONT_BACK_SELECTOR(23),
    /** 元素选择器优先选择指定元素 (target_num)*/
    ELEMENT_SELECTOR(24),

    /** 元素选择器 只选择指定元素 (target_num)*/
    ONLY_ELEMENT_SELECTOR(25),

    /** 排除技能目标 */
    SKILL_GOAL(101),
    
    
    /** 混乱选择器，占用配置序号，但不在配置中直接填写*/
    CONFUSION_SELECTOR(1001),
    /** 离间选择器，占用配置序号，但不在配置中直接填写*/
    BETRAY_SELECTOR(1002),
    /** 挑衅选择器，占用配置序号，但不在配置中直接填写*/
    PROVOCATIVE(1003),
    ;
	
	/**  */
	private int value;
	
	private SelectorType(int value){
		this.value = value;
	}
	
}
