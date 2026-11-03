package com.ayjs.mxzg.config.struct;


import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import lombok.Getter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Buff类型
 * @author meiyc
 *
 */
@Getter
@EnumMode(ValueMode.VALUE)
public enum BuffType {


	/**动画*/
	BT_AMIN(1, false),
	/**近身攻击*/
	BT_ATTACK_NEAR(2, false),
	/**远程攻击*/
	BT_ATTACK_RANGE(3, false),
	/**原地动画*/
	BT_SITU(4, false),
	/**投掷动画*/
	BT_THREW(5, false),
	/**在英雄位置播放特效*/
	BT_ATTACK_EFFECT1(6, false),
	/**在目标位置播放特效*/
	BT_ATTACK_EFFECT2(7, false),
	/**移动到地图任意位置停留一段时间并执行攻击动作*/
	BT_ATTACK_EFFECT3(8, false),
	/**在指定位置释放特效*/
	BT_ATTACK_EFFECT4(9, false),
	/**投掷到指定位置*/
	BT_ATTACK_EFFECT5(10, false),
	/**移动到目标前面。执行多次攻击动画*/
	BT_ATTACK_EFFECT6(11, false),
	/**神龙额外特效 */
	BT_DRAGON_EFFECTS(12, false),
	/**
	 * 变身动作
	 */
    BT_TRANSFIGURATION(13, false),


	/**造成自身攻击力的伤害   value0: 攻击力百分比  value1: 攻击类型， 是否触发反击，反伤等效果。0:触发。1:不触发反击/反伤*/
	BT_DAMAGE(100, true) {
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},
	/**造成目标攻击力的伤害  value0: 攻击力百分比  value1: 攻击类型 （触发效果跟BT_DAMAGE一样）*/
	BT_DAMAGE_TARGET(101, true) {
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},
	/**造成目标血量最大值的伤害   value0: 血量百分比  value1: 攻击类型（触发效果跟BT_DAMAGE一样）  value2: 最多不超过攻击的多少血量*/
	BT_DAMAGE_HP_MAX(102, true) {
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**造成自己血量最大值的伤害   value0: 血量百分比  value1: 攻击类型（触发效果跟BT_DAMAGE一样） */
	BT_SELF_HP_MAX(103, true) {
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**
	 * 造成无视防御的攻击
	 * value0: 攻击力百分比
	 * value1: 攻击类型（触发效果跟BT_DAMAGE一样）
	 */
	BT_DAMAGE_IGNORE(104, true) {
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**
	 * 真实伤害的攻击
	 * value0: 攻击力百分比
	 */
	BT_DAMAGE_REAL_ATTACH(105, true){
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**
	 * 引爆
	 * value0:伤害加成比例
	 * value1:伤害的攻击上限
	 * value2:引爆的buff类型列表
	 */
	BT_DETONATE(106, true) {
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**
	 * 暴击伤害
	 *  value0: 攻击力百分比
	 * 	value1: 攻击类型（触发效果跟BT_DAMAGE一样）
	 */
	BT_CRI_DAMAGE(107, true){
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**
	 * 根据debuff的层数来加成伤害
	 *  value0: 攻击力百分比
	 * 	value1: 攻击类型（触发效果跟BT_DAMAGE一样）
	 * 	value2: 每层debuff加成的伤害比例
	 * 	value3: buff加成后的伤害最大上限，不能超过的攻击倍数
	 */
	BT_DEBUFF_DAMAGE(108, true){
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**
	 * 随机1-5次攻击敌方单位造成伤害，并概率添加buff
	 *  value: 概率1，单位个数，伤害比例，buff命中概率，概率2，单位个数...
	 */
	BT_RANDOM_DAMAGE(109, true){
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**
	 * 斩杀，当前生命值百分比低于value2，则执行斩杀，最大斩杀伤害不超过value3的攻击百分比
	 * 否则走公式计算技能伤害系数为攻击百分比 + 被攻击方剩余血量百分比 * value1
	 * value0:攻击百分比
	 * value1:被攻击方损失血量的修正系数
	 * value2:血量斩杀线
	 * value3:最大斩杀攻击百分比
	 */
	BT_BEHEADED(110, true){
		@Override
		public boolean isDamageBuff() {
			return true;
		}
	},

	/**
	 * 均摊伤害
	 * value0: 攻击百分比
	 * value1: 攻击类型（触发效果跟BT_DAMAGE一样）
	 * value2:单个目标承受的伤害上限
	 * value3:0全体 1 前排 2 后排
	 */
	BT_AVERAGE_DAMAGE(111, true),

	/**
	 * 根据速度来加成伤害
	 * value0: 攻击力百分比
	 * value1: 攻击类型（触发效果跟BT_DAMAGE一样）
	 * value2：速度上限值 速度加成伤害 = 速度 / (速度 + 速度上限值)
	 */
	BT_SPEED_DAMAGE(112, true),

	/**
	 * 附加生命值百分比伤害
	 *  value0: 攻击力百分比
	 * 	value1: 攻击类型（触发效果跟BT_DAMAGE一样）
	 * 	value2:目标生命百分比
	 * 	value3:本次总伤害不超过攻击的最高比例
	 */
	BT_ADDITIONAL_HP_MAX_DAMAGE(113, true),

	/**
	 * 擒贼擒王
	 */
	BT_CAPTURE_KING(114, true),

	/**
	 * 不包含任何逻辑的概率随机类型
	 */
	BT_RANDOM(120, true),

	/**
	 * 恢复生命值自身攻击力的百分比
	 * value0:攻击的百分比
	 */
	BT_REPLENISH_HP(130, true),
	/**
	 * 恢复最大生命值
	 * value0:最大生命值的百分比
	 */
	BT_REPLENISH_HP_MAXIMUM(131, true),
	/**
	 * 恢复伤害值的百分比
	 * value0:伤害的百分比
	 * value1:伤害类型，0全部类型，1物理类型，2魔法类型
	 */
	BT_REPLENISH_HP_DAMAGE(132, true),

	/**
	 * 恢复已损失生命值的百分比
	 * value0:已损失生命的百分比
	 */
	BT_REPLENISH_LOSS_HP(133, true),

	/**
	 * 天佑，根据自己和目标生命值上限恢复指定比例的生命值
	 * value0: 自己的生命值百分比
	 * value1: 目标生命值百分比
	 */
	BT_BLESS(134, true),

	/**
	 * 死亡印记
	 * value0:属性类型
	 * value0:修改的属性百分比
	 */
	BT_IMPRINT_DEATH(140, true),

	/**
	 * 咒印
	 * value0:属性类型
	 * value1:属性修改的百分比
	 */
	BT_MANTRA(141, true),

	/**
	 * 灵魂印记
	 * value0: 免伤增加比例
	 * value1: 治疗增加比例
	 * value2: 抗控效果比例
	 */
	BT_SOUL_MARK(142, true),

	/**
	 * 灵魂结界，分担伤害
	 * value0:结界消失的时候执行artID
	 */
	BT_SOUL_ENCHANTMENT(143, true){
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 狼魂
	 * value0:暴击增加的比例
	 * value1:免伤增加的比例
	 */
	BT_WOLF_SOUL(144, true),

	/**
	 * 森林印记，添加buff时给buff施加者执行artId1叠加到指定层数的后在个buff携带者触发art2
	 * value0:artId1
	 * value1:触发需要达到的层数
	 * value2:buff携带者触发的art2
	 */
	BT_FOREST_MARKING(145, true),

	/**
	 * 火灵印记，攻击目标时如果目标携带该印记则恢复血量
	 * value0:恢复伤害百分比
	 */
	BT_FIRE_MARK(146, true) {
		@Override
		public BuffType listenType() {
			return BT_BEATTACK;
		}
	},

	/**
	 * 生命伤害印记，携带该印记攻击目标时则目标损失一定生命上限百分比的伤害
	 * value0:生命伤害百分比
	 * value1:伤害不超过攻击的最高比例
	 */
	BT_MARK_HP_DAMAGE(147, true) {
		@Override
		public BuffType listenType() {
			return BT_ATTACK;
		}
	},

	/**
	 * 附加生命值百分比伤害
	 * 	value0:目标生命百分比
	 * 	value1:本次总伤害不超过攻击的最高比例
	 */
	BT_ADD_HP_MAX_DAMAGE(148, true) {
		@Override
		public BuffType listenType() {
			return BT_AFTER_DAMAGE;
		}
	},

	/**
	 * 重生
	 * value[0]: 恢复生命值上限的百分比
	 */
	BT_REBORN(150, true){
		@Override
		public boolean isDeathExecute() {
			return true;
		}
	},

	/**
	 * 怒气
	 * value0:怒气提升的属性
	 * value0:属性提升的值
	 */
	BT_ANGER(151, true) {
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DAMAGE;
		}
	},

	/**
	 * 免疫所有debuff
	 */
	BT_IMMUNITY_DEBUFF(152, true),

	/**
	 * 免疫所有控制
	 */
	BT_IMMUNITY_CONTROL(153, true),

	/**
	 * 复活，并回复指定攻击比例的生命值上限
	 * value[0]: 恢复攻击力比例的百分比
	 * value1: 目标没死执行的artId,如果重生的玩家是存活状态则走另外的art
	 */
	BT_RESURRECTION(154, true){
		@Override
		public boolean isDeathExecute() {
			return true;
		}
	},

	/**
	 * 增加下次攻击的目标数量
	 * value0:增加的目标个数
	 */
	BT_INCREASE_TARGETS(155, true),

	/**
	 * 神佑，死亡后有一定的概率复活，复活后恢复指定生命值上限的血量
	 * value0:复活的概率
	 * value1:重生的artId
	 * value2:触发的次数
	 */
	BT_GOD_BLESS(156, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_DEATH;
		}
	},

	/**
	 * 保命，死亡有12%几率复活，复活时恢复少量生命值
	 * value0:复活的概率
	 * value1: 重生的artId
	 * value2:触发的次数
	 */
	BT_LIFE_SAVING(157, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_DEATH;
		}
	},

	/**
	 * 速度偷取
	 * value0:偷取的速度百分比
	 */
	BT_SPEED_STEAL(159, true),

	/**
	 * 修改玩家属性值,增加数值
	 * value0：需要修改的类型
	 * value1：增加的数值
	 */
	BT_ABILITY_ADD(160, true){
		@Override
		public boolean isAttributeBuff() {
			return true;
		}
	},

	/**
	 * 根据自己属性百分比修改目标属性
	 * value0:需要修改的类型
	 * value1:修改的万分比
	 */
	BT_ATTRIBUTE_PROPORTION(161, true) {
		@Override
		public boolean isAttributeBuff() {
			return true;
		}
	},

	/**
	 * 修改普通技能
	 * value[0]:新的技能id
	 */
	BT_COMMON_CHANGE(162, true),
	/**
	 * 更新角色的最大生命值
	 * value[0]:增加的最大生命百分比
	 */
	BT_HP_MAX_CHANGE(163, true),

	/**修改能量  value0:修改的能量数值*/
	BT_ANGER_ADD(164, true),

	/**
	 * 根据元素加成属性 总加成属性 = value0基础加成比例 + value2元素类型个数 * value3
	 * value0:基础加成比例
	 * value1:加成的属性类型
	 * value2:元素类型
	 * value3每个元素加成的比例
	 */
	BT_ELEMENT_ADD(165, true),

	/**攻击力偷取 value0: 偷取的百分比*/
	BT_ATTACK_STEAL(166, true),

	/**
	 * 一次性属性修改该属性修改只生效一次
	 *  value0：需要修改的类型
	 * 	value1：增加的数值
	 */
	BT_ONCE_ATTRIBUTE(167, true) {
		@Override
		public boolean isAttributeBuff() {
			return true;
		}
	},

	/**
	 * 根据自身和目标提升属性
	 *  value0: 属性类型
	 *  value1：自己属性百分比
	 * 	value2：目标属性百分比
	 */
	BT_COMB_ATTRIBUTE(168, true),

	/**
	 * 一次出手的属性修改，出手完属性清除
	 */
	BT_ONCE_ATTACK_ATTRIBUTE(169, true),

	/**
	 * 攻击时触发
	 */
	BT_ATTACK(170, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 被攻击时触发art,目标为攻击者
	 * value0:拥有的该状态才能被触发
	 */
	BT_BEATTACK(171, true) {
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**使用普通攻击时触发art*/
	BT_USE_ATTACK(172, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**
	 * 使用技能时触发art
	 * value0:限定触发的技能id，不填则使用所有技能都触发，
	 * value1:0所有伤害类型都触发，1是物理技能触发，2法术技能触发
	 */
	BT_USE_SKILL(173, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**
	 * 暴击时触发 art
	 *  value0:限制的回合
	 */
	BT_CRITICAL(174, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**
	 * 被暴击时触发
	 * value0:0可以被所有人触发 1 则只能是buff施加者触发
	 * value1:被触发的次数
	 */
	BT_BECRITICAL(175, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**按照伤害百分比触发多少层buff value0：触发的比例 value1：最大触发次数  */
	BT_BEDAMAGE_HP_STAGE(176, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**
	 * 被攻击时。生命值低于%时触发
	 *  value0：触发的比例
	 *  value1: 触发的次数，达到次数后移除buff
	 */
	BT_BEDAMAGE_HP_MAXIMUM(177, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**被普通攻击了*/
	BT_BEATTACK_ATTACK(178, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**被技能攻击了*/
	BT_BEATTACK_SKILL(179, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**死亡时触发*/
	BT_DEATH(180, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**普通攻击造成伤害了*/
	BT_ATTACK_SELF(181, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**技能攻击造成伤害了触发art*/
	BT_ATTACK_SKILL_SELF(182, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/**
	 * 回合debuff造成伤害时触发
	 */
	BT_ROUND_DEBUFF(183, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},
	/** 触发格挡时触发art    */
	BT_BLOCK_TRIGGER(184, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 被施加控制buff时触发
	 * value0:被施加的buffType,该处可以填buffType列表
	 */
	BT_CONTROL_DEBUFF(185, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 治疗时触发
	 */
	BT_TREATMENT(186, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 计算伤害之前触发
	 */
	BT_BEFORE_DAMAGE(187, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 计算伤害之后触发，触发者是攻方
	 */
	BT_AFTER_DAMAGE(188, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 扣减伤害之前触发，触发者是守方
	 */
	BT_BEFORE_DEDUCTION_DAMAGE(189, true),

	/**
	 * 击杀时触发
	 */
	BT_KILLED(190, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 重生时触发
	 */
	BT_REBIRTH(191, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 使用物理技能时触发
	 */
	BT_USE_PHYSICAL_SKILL(192, true),

	/**
	 * 使用法术技能时触发
	 */
	BT_USE_MAGIC_SKILL(193, true),

	/**
	 * 对目标造成伤害时触发，会对每一个目标触发
	 */
	BT_DEALING_DAMAGE(194, true),

	/**
	 * 诅咒之后触发
	 */
	BT_CURE_DAMAGE_AFTER(195, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 解控，被施加控制类buff时触发，解除自身控制和debuff,每场战斗触发一次
	 * 该buff的art列表在此buff触发时调用
	 */
	BT_UN_CONTROL(196, true){
		@Override
		public BuffType listenType() {
			return BT_CONTROL_DEBUFF;
		}
	},

	/**
	 * 出手之前触发
	 */
	BT_BEFORE_ACTION(197, true) {
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 强壮，受到伤害超过生命值上限value0：百分比时，伤害降低百分比value1
	 * value0:目标超过的百分比
	 * value1:超过部分伤害降低的百分比
	 */
	BT_STRONG (198, true) {
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 灵魂契约，受到伤害时转移伤害到契约者身上
	 * value0：转移伤害百分比
	 * value1:转移伤害不能超过施法者的攻击百分比
	 * value2:建立反向契约的buffId
	 */
	BT_SOUL_CONTRACT(199, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 反向契约，被治疗时，转移治疗量到契约者身上
	 * value0：治疗转移百分比
	 */
	BT_REVERSE_CONTRACT(200, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_BE_TREATED;
		}
	},



	/**目标回合开始的时候触发art*/
	BT_ROUND_START(201, true){
		@Override
		public boolean isRoundBuff() {
			return true;
		}

		@Override
		public boolean triggerArt(){
			return true;
		}

		@Override
		public boolean isFixedRound() {
			return true;
		}
	},
	/**目标回合结束的时候触发art*/
	BT_ROUND_END(202, true){
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 固定回合执行
	 * value0:
	 */
	BT_FIXED_ROUND(203, true) {
		@Override
		public boolean triggerArt() {
			return true;
		}
	},

	/**
	 * 触发指定的事件执行
	 */
	BT_EVENT(204, true){
		@Override
		public boolean triggerArt() {
			return true;
		}
	},

	/**
	 * 献祭，
	 * value0:受到伤害触发的百分比
	 * value1:复活执行的artId
	 * value2:治疗执行的artId
	 */
	BT_SACRIFICE(205, true) {
		@Override
		public BuffType listenType() {
			return BuffType.BT_DEATH;
		}

		@Override
		public BuffType listenType2() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 被治疗时触发
	 */
	BT_BE_TREATED(206, true){
		@Override
		public boolean triggerArt() {
			return true;
		}
	},

	/**
	 * 给敌方造成控制时触发
	 * value0:控制的buff类型 这里可以填控制buff类型列表
	 */
	BT_CONTROLLING(207, true){
		@Override
		public boolean triggerArt() {
			return true;
		}
	},

	/**
	 * 破冰，攻击解除敌方冰冻效果时触发，触发者为攻方
	 */
	BT_BREAK_ICE(208, true){
		@Override
		public boolean triggerArt() {
			return true;
		}
	},

	/**
	 * buff过期时触发，
	 * value0:能触发的buffId列表
	 */
	BT_BUFF_EXPIRED(209, true){
		@Override
		public boolean triggerArt() {
			return true;
		}
	},

	/**
	 * 限定使用次数buff
	 * value0:本次战斗最大触发次数
	 */
	BT_USE_LIMIT(210, true),
	/**
	 * 指定职业才会生效的buff
	 * value0：target职业相符时，才会触发art
	 */
	BT_JOB_SELECT(212, true),

	/**
	 * 指定位置才会生效的buf
	 * value0：位置相符时，才会触发art
	 */
	BT_POS_SELECT(213, true),

	/**
	 * 自己中了指定debuff时触发
	 * value0:指定的buffType才会触发art
	 */
	BT_SELF_DEBUFF_SELECT(214, true),

	/**
	 * 目标是否中了指定debuff时触发 这里是中断自己，
	 * value0:指定的buffType才会触发art
	 */
	BT_TARGET_DEBUFF_SELECT(215, true),

	/**
	 * 目标是否中了指定buff的指定层数
	 * value0:指定的buffType
	 * value1:指定buff的层数
	 */
	BT_TARGET_BUFF_COUNT(216, true),

	/**
	 * 目标是否中了指定层数的debuff
	 * value0:deuff的层数
	 */
	BT_DEBUFF_CHECKER(217, true),

	/**
	 * 检查value2血量是否低大于或小于指定的百分比
	 * value0: 血量百分比
	 * value1: 0则判定小于  1判断大于
	 * value2: 0检测目标  1检测自己 2、友方全体
	 */
	BT_HP_CHECKER(218, true),

	/**
	 * 目标是否中了指定的debuff中的一个
	 * value0: 指定的buffType1
	 * value1: 指定的buffType2
	 */
	BT_TARGET_BUFF_CHECKER(219, true),

	/**
	 * 根据血量附加buff，血量大于自身，血量小于自身
	 *  value0：血量低于目标时触发
	 *  value1：血量高于或等于目标时触发
	 */
	BT_SELECT_HP_COMP(220, true),


	/**
	 * 根据概率选择执行的art
	 *  value0：概率
	 *  value1：概率命中执行artId
	 *  value2：概率未命中执行的artId
	 */
	BT_RANDOM_ART(221, true),

	/** 目标是否死亡 */
	BT_DEA(222, true){
		@Override
		public boolean isDeathExecute() {
			return true;
		}
	},

	/**
	 * 属性比较，目标指定的属性是否比自己大或小
	 * value0: 检测的目标属性类型
	 * value1: 0 比自己小，1比自己大
	 */
	BT_ATTRIBUTE_CHECKER(223, true),

	/** 本次伤害是否暴击 */
	BT_CRIT(224, true),

	/**
	 * 光之力，达到叠加层数后触发art
	 * value0: 触发层数
	 */
	BT_POWER_OF_LIGHT(230, true) {
		@Override
		public boolean isOverlay() {
			return true;
		}
		@Override
		public boolean triggerArt(){
			return true;
		}
	},

	/**
	 * 庇护 伤害转移到buff添加者身上
	 * value0: 庇护的伤害分担百分比
	 * value1:承担后的扣除血量百分比，0和10000都为百分比
	 * value2:暴击承伤比例，有暴击才生效
	 *
	 */
	BT_SHELTER(231, true){
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 烈焰护盾
	 * value0:反弹伤害的百分比
	 */
	BT_FLAME_SHIELD(232, true){
		@Override
		public BuffType listenType() {
			return BT_BEATTACK;
		}
	},

    /**
	 * 格挡盾
     * 格挡一定次数的攻击后消失，固定伤害不能触发
     * value0: 格挡次数
     */
    BT_BLOCK_SHIELD(234, true) {
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 火灵守护，受到攻击时给攻击者附加buff
	 * value0:附加buff的概率
	 * value1:附加buff的artId
	 */
	BT_FIRE_SPIRIT(235, true){
		@Override
		public BuffType listenType() {
			return BT_BEATTACK;
		}
	},

	/**
	 * 均衡音符，减免和反弹一定比例的伤害，不能减免和反弹buff和斩杀伤害
	 * value0:减免的伤害比例
	 * value1:反弹的伤害比例
	 */
	BT_BALANCED_NOTE(236, true){
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 治疗溢出的值转换为护盾
	 * value0:治疗的生命的攻击百分比	跟value2互斥
	 * value1:指定显示护盾的buffId
	 * value2:治疗生命上限百分比，跟value0互斥，
	 */
	BT_TREATMENT_OVERFLOW_SHIELD(237, true),

	/**
	 * 伤害不能超过目标生命值上限
	 * value0:占位用的生命值上限属性类型
	 * value1:生命值上限比例
	 */
	BT_DAMAGE_LIMIT(240, true){
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 随机art选择
	 * value0:随机的个数
	 * value1-n:随机的art列表，同等概率
	 */
	BT_ART_SELECTOR(241, true),

	/**
	 * 负面buff伤害加成
     * value0:一个debuff加成的伤害比例
	 */
	BT_DEBUFF_DAMAGE_ADD(242, true){
        @Override
        public BuffType listenType() {
            return BT_BEFORE_DAMAGE;
        }
    },

	/**
	 * 怒气强化，根据自己有多少层怒气Buff来执行art次数，最后在溅射随机几个目标
	 * value0:多少层执行一次后续的art
	 * value1:溅射目标的个数
	 * value2:溅射的伤害比例
	 * value3:第一层执行的art
	 * vlaue4:第二层执行的art
	 */
	BT_ANGER_STRENGTHEN(243, true),

	/**
	 * 检测目标是否是先手是先手则执行artId1否则执行artId2
	 * value0:artId1
	 * value1:artId2
     * value2: 0是否是我方速度最高的，1是否比对方速度最高的更高
	 */
	BT_CHECK_FIRST(244, true),

	/**
	 * 该buff，所在的技能为全场最先出手
	 */
	BT_FIRST_SKILL(260, true),

	/**
	 *偷取敌方增益 buff，不能偷取不可驱散的buff和被动
	 * value0:偷取的目标个数
	 * value1:偷取的buff个数
	 */
	BT_STEAL_BUFF(301, true),

	/**
	 * 嫁祸为己方全体指定单位数各驱散1层非控制类的负面状态，并全部嫁祸到随机敌方后排单体上
	 * value0:驱散的buff层数
	 * value1:己方单位个数
	 */
	BT_MARRY(302, true),

	/**
	 * 根据buff统计的伤害治疗全体跟BT_STATISTICS_BUFF_DAMAGE联合使用，添加给自己
	 * value0:伤害转换治疗的比例
	 * value1:治疗不超过施法者的攻击比例
	 */
	BT_ACCORDING_TREATMENT(303, true),

	/**
	 *统计buff伤害，添加给敌方
	 */
	BT_STATISTICS_BUFF_DAMAGE(304, true){
		@Override
		public BuffType listenType() {
			return BT_ROUND_DEBUFF;
		}
	},

	/**
	 * 神赦 攻击提高2%；受到单次伤害超过生命上限40%时，有20%几率使伤害减少30%
	 * value0: 触发的伤害百分比
	 * value1: 赦免的概率
	 * value2: 减少的比例
	 */
	BT_PARDON(306, true) {
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
		@Override
		public int getPriority() {
			//当前吸伤盾优先级是0，神赦优先级是1
			return 1;
		}
	},

	/**
	 * 圣灵，死亡后每回合有一定的概率复活
	 * value0:死亡后第一回合复活的概率
	 * value1:每回合复活累加的概率
	 * value2:第几回合必定复活
	 * value3:重生的artId
	 */
	BT_HOLY_SPIRIT(307, true){
		@Override
		public boolean isRoundBuff() {
			return true;
		}

		@Override
		public boolean isDeathExecute() {
			return true;
		}

		@Override
		public boolean deathBuff(){
			return true;
		}

		@Override
		public boolean triggerArt(){
			return true;
		}

		@Override
		public BuffType listenType() {
			return BuffType.BT_DEATH;
		}
	},

	/**
	 * 驱灵,对圣灵携带者伤害加成，并且击杀后对方圣灵技能失效（后半部分在圣灵buff中实现）
	 * value0:对圣灵携带者的伤害加成比例
	 */
	BT_EXORCISM(308, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_AFTER_DAMAGE;
		}

		@Override
		public boolean isDeathExecute() {
			return true;
		}
	},

	/**
	 * 神体，受到指定buff携带者攻击时伤害降低
	 * value0:伤害降低的比例
	 * value1:buffType1
	 * value2:buffType2
	 * value3:buffType3
	 * valueN:...
	 */
	BT_GODHEAD(309, true){
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 波动,造成魔法伤害时，最终伤害效果会在90%-110%之间随机波动
	 * value0:波动下限值
	 * value1:波动上限值
	 */
	BT_FLUCTUATION(310, true){
		@Override
		public BuffType listenType() {
			return BT_AFTER_DAMAGE;
		}
	},

	/**
	 * 清心，使用治疗或复活时有概率随机清除一个英雄的负面状态
	 * value0:触发的概率
	 * value1:清除的英雄的个数
	 */
	BT_PURE_HEART(311, true),

    /**
     * 反伤，受到攻击时有一定概率反弹伤害
     * value0:反伤概率
     * value1:反伤比例
     */
    BT_COUNTER_INJURY(312, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_BEATTACK;
		}
	},

	/**
	 * 精准, 命中提高则额外配置
	 * value0:对闪避/迅捷目标提高的比例
	 */
	BT_PRECISE(313, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_AFTER_DAMAGE;
		}
	},

	/**
	 * 爆追,使用物理攻击造成暴击时，40%概率再进行1次普攻
	 * value0:再次触发普攻的概率
	 */
	BT_EXPLOSIVE_CHASE(314, true) {
		@Override
		public BuffType listenType() {
			return BuffType.BT_CRITICAL;
		}
	},

	/**
	 * 战意 生命值每降低1%，伤害提高0.1%
	 * value0:生命值降低的比例
	 * value1:生命值每降低一个百分比增加的伤害比例
	 */
	BT_WAR_INTENT(315, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_AFTER_DAMAGE;
		}
	},

	/**
	 * 追击，物理攻击击杀目标后有概率追击一次普攻
	 * value0:追击的概率
	 */
	BT_CHASE(316, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_KILLED;
		}
	},

	/**
	 * 物连
	 * value0:触发的概率
	 * value1:原技能效果变动的比例
	 */
	BT_PHYSICAL_BATTER(319, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_ATTACK;
		}
	},

	/**
	 * 法连
	 * value0:触发的概率
	 * value1:原技能效果变动的比例
	 */
	BT_MAGIC_BATTER(320, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_ATTACK;
		}
	},

	/**
	 * 闪避,闪避提高；受带强攻的单位攻击时，伤害降低5%
	 * value0:受到指定强攻buff时，伤害降低比例
	 */
	BT_DODGE(321, true){
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 镇压,对携带生机和再生buff的敌方伤害提升
	 *
	 * value0: 伤害提升的比例
	 */
	BT_SUPPRESS(322, true){
		@Override
		public BuffType listenType() {
			return BT_AFTER_DAMAGE;
		}
	},

	/**
	 * 狂暴
	 * value0:加成的属性类型
	 * value1:加成的数值
	 */
	BT_VIOLENT(323, true){
		@Override
		public boolean stateAttributeBuff() {
			return true;
		}
	},

	/**
	 * 强攻
	 *  value0:加成的属性类型
	 * 	value1:加成的数值
	 */
	BT_STORM(324, true){
		@Override
		public boolean stateAttributeBuff() {
			return true;
		}
	},

	/**
	 * 冲击，伤害超过目标生命百分比，有概率眩晕目标2回合
	 * value0:生命百分比
	 * value1:眩晕概率
	 * value2:眩晕的artId
	 */
	BT_SHOCK(325, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_DEALING_DAMAGE;
		}
	},

	/**
	 * 灭魂，受击方10%概率4回合无法复活；对有神佑/保命的伤害+5%
	 * value0:对神佑/保命单位的伤害加成比例
	 * value1:封魂的概率
	 * value2:封魂artId
	 */
	BT_EXTERMINATION(327, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_AFTER_DAMAGE;
		}
	},

	/**
	 * 封魂，被封魂的单位不能复活
	 */
	BT_SEAL_SOUL(328, true){
		@Override
		public boolean deathBuff() {
			return true;
		}

		@Override
		public boolean isDeathExecute() {
			return true;
		}
	},

	/**
	 * 刚性，提升生命上限，受到持续伤害时将减免受到的伤害,生命提升走163
	 * value0:持续伤害的减免比例
	 */
	BT_RIGIDITY(329, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_ROUND_DEBUFF;
		}
	},

	/**
	 * 生机，提升治疗和被治疗效果
	 * value0:属性类型
	 * value1:属性值
	 */
	BT_VITALITY(330, true){
		@Override
		public boolean stateAttributeBuff() {
			return true;
		}
	},

	/**
	 * 再生，每回合开始恢复一定生命百分比上限
	 * value0:
	 */
	BT_REGENERATION(331, true){
		@Override
		public boolean isRoundBuff() {
			return true;
		}
	},

	/**
	 * 迅捷，提升速度比例和数值，提升的比例走160属性
	 * value0:提升的数值类型
	 * value1:提升的数值
	 */
	BT_SWIFT(332, true){
		@Override
		public boolean stateAttributeBuff() {
			return true;
		}
	},

	/**
	 * 不屈，每损失一定的血量value0就增加一定的免伤value1
	 * value0:损失的一个单位血量
	 * value1:免伤百分比
	 */
	BT_UNYIELDING(350, true) {
		@Override
		public BuffType listenType() {
			return BuffType.BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

    /**
     * 单纯给客户端播放特效用的护盾特效
     */
	BT_NO_LOGIC_SHIELD(351, true),

	/**
	 * 背水一战
	 * value0:损失的一个单位血量
	 * value1:增加的属性值
	 * value2:增加的属性类型
	 */
	BT_LAST_STAND(352, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_BEFORE_DAMAGE;
		}
	},

	/**
	 * 魔法伤害加深
	 * value0:魔法伤害加深的属性类型
	 * value1:伤害加深比例
	 */
	BT_MAGIC_DAMAGE_EXACERBATION(501, true),

	/**
	 * 物理伤害加深
	 * value0:物理伤害加深的属性类型
	 * value1:伤害加深比例
	 */
	BT_PHYSICAL_DAMAGE_EXACERBATION(502, true),

	/**
	 * 对指定buff伤害加深，加深值为buff施加者的攻击百分比
	 * value0:buffType
	 * value1:增加伤害的攻击力比例
	 */
	BT_BUFF_DAMAGE_ADD(510, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_CURE_DAMAGE_AFTER;
		}
	},

	/**
	 * 统计场上的元素英雄个数，每个元素value0增加value1比例的属性value2
	 * value0：统计的元素类型
	 * value1:每个元素增加的属性百分比
	 * value2:增加的属性类型
	 */
	BT_HALO(601, true) {
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DAMAGE;
		}
	},

	/**
	 * 将后排拉到前排补全
	 */
	BT_UPDATE_POS(650, true),

    /**
     * 召唤小熊
     * value0: 血量百分比
	 * value1: 死亡后冷却回合
     */
    BT_LITTLE_BEAR(651, true) {
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},

	/**
	 * 小熊庇护 伤害转移到buff添加者身上
	 * value0: 庇护的伤害分担百分比
	 * value1:承担后的扣除血量百分比，0和10000都为百分比
	 * value2:暴击承伤比例，有暴击才生效
	 *
	 */
	BT_BEAR_SHELTER(652, true){
		@Override
		public BuffType listenType() {
			return BT_BEFORE_DEDUCTION_DAMAGE;
		}
	},


	/** 沉默，无法使用技能 */
	BT_SILENCE(1001, true) {

		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.SILENCE_RESISTANCE_PERCENT;
		}
	},
	/**缴械，无法普通攻击*/
	BT_DISARM(1002, true) {

		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.DISARM_RESISTANCE_PERCENT;
		}
	},
	/**定身，无法使用攻击和技能*/
	BT_IMMOBILIZ(1003, true) {

		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.DISARM_RESISTANCE_PERCENT;
		}
	},
	/**
	 * 冰冻，无法使用攻击和技能
	 * value0:被英雄攻击多少回合后解除
	 */
	BT_FROZEN(1004, true) {
		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.FROZEN_RESISTANCE_PERCENT;
		}

		@Override
		public BuffType listenType() {
			return BT_BEATTACK;
		}
	},
	/**眩晕，无法使用攻击和技能*/
	BT_DIZZY(1005, true) {

		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.DIZZINESS_RESISTANCE_PERCENT;
		}
	},
	/**石化，无法使用攻击和技能*/
	BT_PETRIFY(1006, true) {
		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.PETROCHEMICAL_RESISTANCE_PERCENT;
		}
	},

	/** 封印，被封印的目标不能触发被动 */
	BT_SEAL(1007, true),

	/**
	 * 护盾
	 * value0:治疗转换的护盾万分比，如果是伤害则填0
	 * value1:伤害转换护盾的万分比，如果是治疗则填0
	 * value2:自身生命上限转换为护盾，
	 * value3:根据自身攻击力转换为护盾
	 */
	BT_SHIELD(1008, true){
		@Override
		public boolean triggerArt(){
			return true;
		}

		@Override
		public boolean isShield() {
			return true;
		}
	},

	/** 禁疗，不能被治疗 */
	BT_NO_RECOVERY(1009, true),


	/** 麻痹，麻痹的单位不能行动 */
	BT_PARALYSIS(1010, true),

	/** 混乱，随机使用普攻攻击一个玩家 */
	BT_CONFUSION(1011, true) {
		@Override
		public SelectorType reSelectTargetType() {
			return SelectorType.CONFUSION_SELECTOR;
		}
	},

	/** 虚弱，不能使用技能和普攻 */
	BT_WEAK(1012, true),

	/**
	 * 倒戈，对己方使用普攻
	 */
	BT_BETRAY(1013, true) {
		@Override
		public SelectorType reSelectTargetType() {
			return SelectorType.BETRAY_SELECTOR;
		}
	},

	/**
     * 沉睡，
     * value0:受到第一次攻击解除的概率
     * value1:受到第二次攻击解除的概率
     */
	DEEP_SLEEP(1014, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_BEATTACK;
		}
	},

	/**
	 * 挑衅，强制使用普攻攻击buff施加者
	 */
	BT_PROVOCATIVE(1015, true){
		@Override
		public SelectorType reSelectTargetType() {
			return SelectorType.PROVOCATIVE;
		}
	},

	/**移除所有对目标生效的buff*/
	BT_REMOVE_ALL(1100, true),
	/**	移除所有控制技能*/
	BT_REMOVE_CONTROL(1101, true),
	/**
	 * 移除debuff
	 */
	BT_REMOVE_DEBUFF(1102, true),
	/**
	 * 移除增益
	 * value0:移除的buff个数
	 * value1:是否移除成功才触发art
	 */
	BT_REMOVE_BUFF(1103, true),
	/**
	 * 移除增益buff每一个增益buff额外造成生命上限百分比伤害
	 * value0:每个buff额外造成的生命上限比例
	 * value1:伤害不超过攻击的上限
	 */
	BT_DISPERSE_DAMAGE(1104, true),

	// 特殊标记
	/** 灼烧 */
	BT_BURN(1201, true) {
		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.BURNING_RESISTANCE_PERCENT;
		}

		@Override
		public boolean isRoundBuff() {
			return true;
		}
	},
	/**
	 * 减速
	 * value0:速度降低比例
	 */
	BT_FROST(1202, true){
		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.FROST_RESISTANCE_PERCENT;
		}
	},
	/**中毒*/
	BT_POISONE(1203, true){
		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.POISONING_RESISTANCE_PERCENT;
		}

		@Override
		public boolean isRoundBuff() {
			return true;
		}
	},
	/**
	 * 感电，被攻击时损失施法者攻击百分比的伤害
	 * value0:施法者攻击百分比
	 * value1:用来飘伤害的buffId
	 */
	BT_ELECTRICITY(1204, true){
		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.FELECTRIC_SHOCK_RESISTANCE_PERCENT;
		}

		@Override
		public BuffType listenType() {
			return BT_BEATTACK;
		}
	},
	/**
	 * 流血 每回合损失施法者攻击百分比的伤害
	 * value0: 攻击百分比
	 */
	BT_BLEED(1205, true){
		@Override
		public AttributeType buffResistanceAttribute() {
			return AttributeType.BLEED_RESISTANCE_PERCENT;
		}

		@Override
		public boolean isRoundBuff() {
			return true;
		}
	},

	/**
	 * 烈火
	 * value0:每回合损失的生命上限百分比
	 */
	BT_FIRE(1206, true){

		@Override
		public boolean isRoundBuff() {
			return true;
		}
	},

	/**
	 * 诅咒，固定回合执行攻击百分比掉血，可以被指定的技能立刻引爆
	 * value0:攻击百分比
	 */
	BT_CURSE(1207, true){
		@Override
		public BuffType listenType() {
			return BuffType.BT_BEATTACK;
		}

		@Override
		public boolean isFixedRound() {
			return true;
		}
	},

	/**
	 * 瘟疫，每回合损失目标生命值上限
	 * value0:生命上限比例
	 * value1:施法者攻击上限比例
	 */
	BT_PLAGUE(1208, true),

	/**
	 * 对抗暴击，存在改buff时不会被暴击，该buff生效一次，触发暴击后移除
	 */
	BT_COUNTER_CRIT(1251,true),

	// 反击之类的东西
	/** 使用一次普通攻击 */
	BT_ATTACK_ACTION(1301, true),
	/**使用一次技能攻击*/
	BT_SKILL_ACTION(1302, true),
	/**
	 * 释放指定技能
	 * value0:释放的技能id
	 * value1:指定的技能等级
	 */
	BT_ASSIGNED_SKILL_ACTION(1303, true),

	/**
	 * 雷暴
	 */
	BT_THUNDERSTORM(1401, true),

    /**
     * 变形
     * value0:变身的技能id
     * value1:变身的技能等级
     */
    BT_FORMATION(1451, true),

	/**
	 * 切换技能
	 * value0:旧技能id
     * value1:新技能id	 *
	 */
	BT_SWITCH_SKILLS(1452, true),

	/**
	 * 助手上场
	 */
	BT_HELPER(1501, true),

	;

	private static Map<Integer, BuffType> buffTypeMap = new HashMap<>();
	static {
		for(BuffType buff : BuffType.values()) {
			buffTypeMap.put(buff.value, buff);
		}
	}

	private int value;

	/** 是否是逻辑buff */
	private boolean isLogic;

	private BuffType(int value, boolean isLogic){
		this.value = value;
		this.isLogic = isLogic;
	}

	/**
	 * 获取buff的对抗属性
	 * @return
	 */
	public AttributeType buffResistanceAttribute(){
		return null;
	}

	/**
	 * 是否是回合开始执行的buff，这里只算回合前buff
	 * @return
	 */
	public boolean isRoundBuff(){
		return false;
	}

	/**
	 * 是否是固定回合
	 * @return
	 */
	public boolean isFixedRound(){
		return false;
	}

	/**
	 * 是否是触发art类型
	 * @return
	 */
	public boolean triggerArt(){
		return false;
	}

	/**
	 * 是否能在目标死亡后继续执行
	 * @return
	 */
	public boolean isDeathExecute(){
		return false;
	}

	/**
	 * 是否是伤害buff
	 * @return
	 */
	public boolean isDamageBuff(){
		return false;
	}

	/**
	 * 是否是属性buff
	 * @return
	 */
	public boolean isAttributeBuff(){
		return false;
	}

	/**
	 * 是否是护盾
	 * @return
	 */
	public boolean isShield(){
		return false;
	}

	/**
	 * 是否是叠加buff
	 * @return
	 */
	public boolean isOverlay(){
		return false;
	}

	/**
	 * 监听的触发器
	 * @return
	 */
	public BuffType listenType(){
		return null;
	}

	/**
	 * 监听的触发器2,座位对listenType的补充存在
	 * @return
	 */
	public BuffType listenType2(){
		return null;
	}
	
	/**
	 * 重新选择目标的类型
	 * @return
	 */
	public SelectorType reSelectTargetType() {
		return null;
	}

	/**
	 * 死亡buff
	 * @return
	 */
	public boolean deathBuff(){
		return false;
	}
	
	/**
	 * buff排序的优先级，数值越大，优先级越高
	 * 例子，当英雄同时拥有神赦和吸伤盾时，应该先触发神赦，后触发吸伤盾
	 * 其它例子，后续补充
	 * @return
	 */
	public int getPriority() {
		return 0;
	}

	/**
	 * 是否是属性状态类buff类型，该类型的buff有属性在战斗外加成但是在战斗内也会被当做状态使用
	 * @return
	 */
	public boolean stateAttributeBuff(){
		return false;
	}
	

	/** 禁止攻击的buff列表 */
	public final static Set<BuffType> PROHIBIT_ATTACK_BUFFS = Sets.newHashSet(BT_DISARM, BT_IMMOBILIZ, BT_FROZEN, BT_DIZZY, BT_PETRIFY, BT_PARALYSIS, BT_WEAK, DEEP_SLEEP);

	/** 禁止使用技能 */
	public final static Set<BuffType> PROHIBIT_SKILL_BUFFS = Sets.newHashSet(BT_IMMOBILIZ, BT_FROZEN, BT_DIZZY, BT_PETRIFY, BT_PARALYSIS, BT_WEAK, DEEP_SLEEP);
	/** 只能使用普攻 */
	public final static Set<BuffType> ONLY_ATTACK_BUFFS = Sets.newHashSet(BT_CONFUSION, BT_SILENCE, BT_BETRAY, BT_PROVOCATIVE);
	/** 携带该buff后重新选择目标，有序列表 */
	public final static List<BuffType> TARGET_RESELECT_BUFFS = Lists.newArrayList(BT_CONFUSION, BT_BETRAY, BT_PROVOCATIVE);
	
	public static BuffType valueOf(int value) {
		return buffTypeMap.get(value);
	}
}
