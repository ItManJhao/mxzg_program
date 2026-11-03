package com.ayjs.mxzg.config.struct;

import java.util.Map;

import org.springframework.util.CollectionUtils;

public class BattleAttr implements IBattleAttr {
	
	//治疗效果：%d 100
	private int cure;
	//速度：%d 101
	private int speed;
	//生命值：##p##%% 102
	private int hpBuff;
	//技能伤害：##p##%% 200
	private int skillDamage;
	//攻击：##p##%% 201
	private int attackBuff;
	//防御：##p##%% 202
	private int defendBuff;
	//无视防御：##p##%% 203
	private int defendIgnore;
	//速度：##p##%% 204
	private int speedBuff;
	//治疗效果：##p##%% 205
	private int cureBuff;
	//被治疗效果：##p##%% 206
	private int becureBuff;
	//暴击：##p##%% 207
	private int crit;
	//抗暴：##p##%% 208
	private int critResist;
	//格挡：##p##%% 210
	private int block;
	//精准：##p##%% 211
	private int blockResist;
	//免控：##p##%% 212
	private int ctrlResist;
	//沉默抵抗：##p##%% 213
	private int slientResist;
	//缴械抵抗：##p##%% 214
	private int disarmResist;
	//定身抵抗：##p##%% 215
	private int stayResist;
	//冰冻抵抗：##p##%% 216
	private int freezeResist;
	//眩晕抵抗：##p##%% 217
	private int dizzyResist;
	//石化抵抗：##p##%% 218
	private int stoneResist;
	//攻击：%d 220
	private int attack;
	//伤害：%d 221
	private int damage;
	//暴击伤害：##p##%% 222
	private int critDamageBuff;
	//血量：%d 223
	private long hp;
	//防御：%d 224
	private int defend;
	//神圣伤害：##p##%% 225
	private int holyBuff;
	//虚弱：##p##%% 230
	private int weakBuff;
	//对火的伤害：##p##%% 251
	private int vsFireBuff;
	//对木的伤害：##p##%% 252
	private int vsWoodBuff;
	//对水的伤害：##p##%% 253
	private int vsWaterBuff;
	//对光的伤害：##p##%% 254
	private int vsLightBuff;
	//对暗的伤害：##p##%% 255
	private int vsDarkBuff;
	//对沉默目标伤害：##p##%% 260
	private int vsSlientBuff;
	//对缴械目标伤害：##p##%% 261
	private int vsDisarmBuff;
	//对定身目标伤害：##p##%% 262
	private int vsStayBuff;
	//对冰冻目标伤害：##p##%% 263
	private int vsFreezeBuff;
	//对眩晕目标伤害：##p##%% 264
	private int vsDizzyBuff;
	//对石化目标伤害：##p##%% 265
	private int vsStoneBuff;
	//最终伤害结果增加：##p##%% 270
	private int damageBuff;
	//对战士伤害：##p##%% 281
	private int vsWarriorBuff;
	//对法师伤害：##p##%% 282
	private int vsWitchBuff;
	//对牧师伤害：##p##%% 283
	private int vsPastorBuff;
	//对刺客伤害：##p##%% 284
	private int vsAssassinBuff;
	//对游侠伤害：##p##%% 285
	private int vsRangerBuff;
	//伤害减免：##p##%% 291
	private int damageReduce;
	//对灼烧目标伤害：##p##%% 301
	private int vsFiringBuff;
	//对霜冻目标伤害：##p##%% 302
	private int vsFrostBuff;
	//对中毒目标伤害：##p##%% 303
	private int vsPoisonBuff;
	//对感电目标伤害：##p##%% 304
	private int vsElecBuff;
	//对流血目标伤害：##p##%% 305
	private int vsBleedBuf;
	//灼烧抵抗：##p##%% 321
	private int firingResist;
	//霜冻抵抗：##p##%% 322
	private int frostResists;
	//中毒抵抗：##p##%% 323
	private int poisonResist;
	//感电抵抗：##p##%% 324
	private int elecResist;
	//流血抵抗：##p##%% 325
	private int bleedResist;
	/**
	 * 治疗效果：%d
	 */
	public int getCure() {
		return this.cure;
	}
	public void setCure(int cure) {
		this.cure = cure;
	}
	/**
	 * 速度：%d
	 */
	public int getSpeed() {
		return this.speed;
	}
	public void setSpeed(int speed) {
		this.speed = speed;
	}
	/**
	 * 生命值：##p##%%
	 */
	public int getHpBuff() {
		return this.hpBuff;
	}
	public void setHpBuff(int hpBuff) {
		this.hpBuff = hpBuff;
	}
	/**
	 * 技能伤害：##p##%%
	 */
	public int getSkillDamage() {
		return this.skillDamage;
	}
	public void setSkillDamage(int skillDamage) {
		this.skillDamage = skillDamage;
	}
	/**
	 * 攻击：##p##%%
	 */
	public int getAttackBuff() {
		return this.attackBuff;
	}
	public void setAttackBuff(int attackBuff) {
		this.attackBuff = attackBuff;
	}
	/**
	 * 防御：##p##%%
	 */
	public int getDefendBuff() {
		return this.defendBuff;
	}
	public void setDefendBuff(int defendBuff) {
		this.defendBuff = defendBuff;
	}
	/**
	 * 无视防御：##p##%%
	 */
	public int getDefendIgnore() {
		return this.defendIgnore;
	}
	public void setDefendIgnore(int defendIgnore) {
		this.defendIgnore = defendIgnore;
	}
	/**
	 * 速度：##p##%%
	 */
	public int getSpeedBuff() {
		return this.speedBuff;
	}
	public void setSpeedBuff(int speedBuff) {
		this.speedBuff = speedBuff;
	}
	/**
	 * 治疗效果：##p##%%
	 */
	public int getCureBuff() {
		return this.cureBuff;
	}
	public void setCureBuff(int cureBuff) {
		this.cureBuff = cureBuff;
	}
	/**
	 * 被治疗效果：##p##%%
	 */
	public int getBecureBuff() {
		return this.becureBuff;
	}
	public void setBecureBuff(int becureBuff) {
		this.becureBuff = becureBuff;
	}
	/**
	 * 暴击：##p##%%
	 */
	public int getCrit() {
		return this.crit;
	}
	public void setCrit(int crit) {
		this.crit = crit;
	}
	/**
	 * 抗暴：##p##%%
	 */
	public int getCritResist() {
		return this.critResist;
	}
	public void setCritResist(int critResist) {
		this.critResist = critResist;
	}
	/**
	 * 格挡：##p##%%
	 */
	public int getBlock() {
		return this.block;
	}
	public void setBlock(int block) {
		this.block = block;
	}
	/**
	 * 精准：##p##%%
	 */
	public int getBlockResist() {
		return this.blockResist;
	}
	public void setBlockResist(int blockResist) {
		this.blockResist = blockResist;
	}
	/**
	 * 免控：##p##%%
	 */
	public int getCtrlResist() {
		return this.ctrlResist;
	}
	public void setCtrlResist(int ctrlResist) {
		this.ctrlResist = ctrlResist;
	}
	/**
	 * 沉默抵抗：##p##%%
	 */
	public int getSlientResist() {
		return this.slientResist;
	}
	public void setSlientResist(int slientResist) {
		this.slientResist = slientResist;
	}
	/**
	 * 缴械抵抗：##p##%%
	 */
	public int getDisarmResist() {
		return this.disarmResist;
	}
	public void setDisarmResist(int disarmResist) {
		this.disarmResist = disarmResist;
	}
	/**
	 * 定身抵抗：##p##%%
	 */
	public int getStayResist() {
		return this.stayResist;
	}
	public void setStayResist(int stayResist) {
		this.stayResist = stayResist;
	}
	/**
	 * 冰冻抵抗：##p##%%
	 */
	public int getFreezeResist() {
		return this.freezeResist;
	}
	public void setFreezeResist(int freezeResist) {
		this.freezeResist = freezeResist;
	}
	/**
	 * 眩晕抵抗：##p##%%
	 */
	public int getDizzyResist() {
		return this.dizzyResist;
	}
	public void setDizzyResist(int dizzyResist) {
		this.dizzyResist = dizzyResist;
	}
	/**
	 * 石化抵抗：##p##%%
	 */
	public int getStoneResist() {
		return this.stoneResist;
	}
	public void setStoneResist(int stoneResist) {
		this.stoneResist = stoneResist;
	}
	/**
	 * 攻击：%d
	 */
	public int getAttack() {
		return this.attack;
	}
	public void setAttack(int attack) {
		this.attack = attack;
	}
	/**
	 * 伤害：%d
	 */
	public int getDamage() {
		return this.damage;
	}
	public void setDamage(int damage) {
		this.damage = damage;
	}
	/**
	 * 暴击伤害：##p##%%
	 */
	public int getCritDamageBuff() {
		return this.critDamageBuff;
	}
	public void setCritDamageBuff(int critDamageBuff) {
		this.critDamageBuff = critDamageBuff;
	}
	/**
	 * 血量：%d
	 */
	public long getHp() {
		return this.hp;
	}
	public void setHp(long hp) {
		this.hp = hp;
	}
	/**
	 * 防御：%d
	 */
	public int getDefend() {
		return this.defend;
	}
	public void setDefend(int defend) {
		this.defend = defend;
	}
	/**
	 * 神圣伤害：##p##%%
	 */
	public int getHolyBuff() {
		return this.holyBuff;
	}
	public void setHolyBuff(int holyBuff) {
		this.holyBuff = holyBuff;
	}
	/**
	 * 虚弱：##p##%%
	 */
	public int getWeakBuff() {
		return this.weakBuff;
	}
	public void setWeakBuff(int weakBuff) {
		this.weakBuff = weakBuff;
	}
	/**
	 * 对火的伤害：##p##%%
	 */
	public int getVsFireBuff() {
		return this.vsFireBuff;
	}
	public void setVsFireBuff(int vsFireBuff) {
		this.vsFireBuff = vsFireBuff;
	}
	/**
	 * 对木的伤害：##p##%%
	 */
	public int getVsWoodBuff() {
		return this.vsWoodBuff;
	}
	public void setVsWoodBuff(int vsWoodBuff) {
		this.vsWoodBuff = vsWoodBuff;
	}
	/**
	 * 对水的伤害：##p##%%
	 */
	public int getVsWaterBuff() {
		return this.vsWaterBuff;
	}
	public void setVsWaterBuff(int vsWaterBuff) {
		this.vsWaterBuff = vsWaterBuff;
	}
	/**
	 * 对光的伤害：##p##%%
	 */
	public int getVsLightBuff() {
		return this.vsLightBuff;
	}
	public void setVsLightBuff(int vsLightBuff) {
		this.vsLightBuff = vsLightBuff;
	}
	/**
	 * 对暗的伤害：##p##%%
	 */
	public int getVsDarkBuff() {
		return this.vsDarkBuff;
	}
	public void setVsDarkBuff(int vsDarkBuff) {
		this.vsDarkBuff = vsDarkBuff;
	}
	/**
	 * 对沉默目标伤害：##p##%%
	 */
	public int getVsSlientBuff() {
		return this.vsSlientBuff;
	}
	public void setVsSlientBuff(int vsSlientBuff) {
		this.vsSlientBuff = vsSlientBuff;
	}
	/**
	 * 对缴械目标伤害：##p##%%
	 */
	public int getVsDisarmBuff() {
		return this.vsDisarmBuff;
	}
	public void setVsDisarmBuff(int vsDisarmBuff) {
		this.vsDisarmBuff = vsDisarmBuff;
	}
	/**
	 * 对定身目标伤害：##p##%%
	 */
	public int getVsStayBuff() {
		return this.vsStayBuff;
	}
	public void setVsStayBuff(int vsStayBuff) {
		this.vsStayBuff = vsStayBuff;
	}
	/**
	 * 对冰冻目标伤害：##p##%%
	 */
	public int getVsFreezeBuff() {
		return this.vsFreezeBuff;
	}
	public void setVsFreezeBuff(int vsFreezeBuff) {
		this.vsFreezeBuff = vsFreezeBuff;
	}
	/**
	 * 对眩晕目标伤害：##p##%%
	 */
	public int getVsDizzyBuff() {
		return this.vsDizzyBuff;
	}
	public void setVsDizzyBuff(int vsDizzyBuff) {
		this.vsDizzyBuff = vsDizzyBuff;
	}
	/**
	 * 对石化目标伤害：##p##%%
	 */
	public int getVsStoneBuff() {
		return this.vsStoneBuff;
	}
	public void setVsStoneBuff(int vsStoneBuff) {
		this.vsStoneBuff = vsStoneBuff;
	}
	/**
	 * 最终伤害结果增加：##p##%%
	 */
	public int getDamageBuff() {
		return this.damageBuff;
	}
	public void setDamageBuff(int damageBuff) {
		this.damageBuff = damageBuff;
	}
	/**
	 * 对战士伤害：##p##%%
	 */
	public int getVsWarriorBuff() {
		return this.vsWarriorBuff;
	}
	public void setVsWarriorBuff(int vsWarriorBuff) {
		this.vsWarriorBuff = vsWarriorBuff;
	}
	/**
	 * 对法师伤害：##p##%%
	 */
	public int getVsWitchBuff() {
		return this.vsWitchBuff;
	}
	public void setVsWitchBuff(int vsWitchBuff) {
		this.vsWitchBuff = vsWitchBuff;
	}
	/**
	 * 对牧师伤害：##p##%%
	 */
	public int getVsPastorBuff() {
		return this.vsPastorBuff;
	}
	public void setVsPastorBuff(int vsPastorBuff) {
		this.vsPastorBuff = vsPastorBuff;
	}
	/**
	 * 对刺客伤害：##p##%%
	 */
	public int getVsAssassinBuff() {
		return this.vsAssassinBuff;
	}
	public void setVsAssassinBuff(int vsAssassinBuff) {
		this.vsAssassinBuff = vsAssassinBuff;
	}
	/**
	 * 对游侠伤害：##p##%%
	 */
	public int getVsRangerBuff() {
		return this.vsRangerBuff;
	}
	public void setVsRangerBuff(int vsRangerBuff) {
		this.vsRangerBuff = vsRangerBuff;
	}
	/**
	 * 伤害减免：##p##%%
	 */
	public int getDamageReduce() {
		return this.damageReduce;
	}
	public void setDamageReduce(int damageReduce) {
		this.damageReduce = damageReduce;
	}
	/**
	 * 对灼烧目标伤害：##p##%%
	 */
	public int getVsFiringBuff() {
		return this.vsFiringBuff;
	}
	public void setVsFiringBuff(int vsFiringBuff) {
		this.vsFiringBuff = vsFiringBuff;
	}
	/**
	 * 对霜冻目标伤害：##p##%%
	 */
	public int getVsFrostBuff() {
		return this.vsFrostBuff;
	}
	public void setVsFrostBuff(int vsFrostBuff) {
		this.vsFrostBuff = vsFrostBuff;
	}
	/**
	 * 对中毒目标伤害：##p##%%
	 */
	public int getVsPoisonBuff() {
		return this.vsPoisonBuff;
	}
	public void setVsPoisonBuff(int vsPoisonBuff) {
		this.vsPoisonBuff = vsPoisonBuff;
	}
	/**
	 * 对感电目标伤害：##p##%%
	 */
	public int getVsElecBuff() {
		return this.vsElecBuff;
	}
	public void setVsElecBuff(int vsElecBuff) {
		this.vsElecBuff = vsElecBuff;
	}
	/**
	 * 对流血目标伤害：##p##%%
	 */
	public int getVsBleedBuf() {
		return this.vsBleedBuf;
	}
	public void setVsBleedBuf(int vsBleedBuf) {
		this.vsBleedBuf = vsBleedBuf;
	}
	/**
	 * 灼烧抵抗：##p##%%
	 */
	public int getFiringResist() {
		return this.firingResist;
	}
	public void setFiringResist(int firingResist) {
		this.firingResist = firingResist;
	}
	/**
	 * 霜冻抵抗：##p##%%
	 */
	public int getFrostResists() {
		return this.frostResists;
	}
	public void setFrostResists(int frostResists) {
		this.frostResists = frostResists;
	}
	/**
	 * 中毒抵抗：##p##%%
	 */
	public int getPoisonResist() {
		return this.poisonResist;
	}
	public void setPoisonResist(int poisonResist) {
		this.poisonResist = poisonResist;
	}
	/**
	 * 感电抵抗：##p##%%
	 */
	public int getElecResist() {
		return this.elecResist;
	}
	public void setElecResist(int elecResist) {
		this.elecResist = elecResist;
	}
	/**
	 * 流血抵抗：##p##%%
	 */
	public int getBleedResist() {
		return this.bleedResist;
	}
	public void setBleedResist(int bleedResist) {
		this.bleedResist = bleedResist;
	}
	public void resetAttr() {
		this.cure = 0;
		this.speed = 0;
		this.hpBuff = 0;
		this.skillDamage = 0;
		this.attackBuff = 0;
		this.defendBuff = 0;
		this.defendIgnore = 0;
		this.speedBuff = 0;
		this.cureBuff = 0;
		this.becureBuff = 0;
		this.crit = 0;
		this.critResist = 0;
		this.block = 0;
		this.blockResist = 0;
		this.ctrlResist = 0;
		this.slientResist = 0;
		this.disarmResist = 0;
		this.stayResist = 0;
		this.freezeResist = 0;
		this.dizzyResist = 0;
		this.stoneResist = 0;
		this.attack = 0;
		this.damage = 0;
		this.critDamageBuff = 0;
		this.hp = 0;
		this.defend = 0;
		this.holyBuff = 0;
		this.weakBuff = 0;
		this.vsFireBuff = 0;
		this.vsWoodBuff = 0;
		this.vsWaterBuff = 0;
		this.vsLightBuff = 0;
		this.vsDarkBuff = 0;
		this.vsSlientBuff = 0;
		this.vsDisarmBuff = 0;
		this.vsStayBuff = 0;
		this.vsFreezeBuff = 0;
		this.vsDizzyBuff = 0;
		this.vsStoneBuff = 0;
		this.damageBuff = 0;
		this.vsWarriorBuff = 0;
		this.vsWitchBuff = 0;
		this.vsPastorBuff = 0;
		this.vsAssassinBuff = 0;
		this.vsRangerBuff = 0;
		this.damageReduce = 0;
		this.vsFiringBuff = 0;
		this.vsFrostBuff = 0;
		this.vsPoisonBuff = 0;
		this.vsElecBuff = 0;
		this.vsBleedBuf = 0;
		this.firingResist = 0;
		this.frostResists = 0;
		this.poisonResist = 0;
		this.elecResist = 0;
		this.bleedResist = 0;
	}
	public static void mergeFightAttr(IBattleAttr fightAttr, Attr attr) {
		mergeFightAttr(fightAttr, attr.getKey(), attr.getValue());
	}
	
	public static IBattleAttr mergeFightAttr(IBattleAttr fightAttr, Map<AttributeType, Integer> attrList) {
		if(!CollectionUtils.isEmpty(attrList)){
			attrList.forEach((type, value)-> mergeFightAttr(fightAttr, type.getValue(), value));
		}
		return fightAttr;
	}
	
	public static IBattleAttr mergeFightAttr(IBattleAttr fightAttr, java.util.List<Attr> attrList) {
		for(int i = 0; i < attrList.size();i++) {
			mergeFightAttr(fightAttr, attrList.get(i));
		}
		return fightAttr;
	}
	public static void mergeFightAttr(IBattleAttr main, IBattleAttr copy) {
		main.setCure(main.getCure() + copy.getCure());
		main.setSpeed(main.getSpeed() + copy.getSpeed());
		main.setHpBuff(main.getHpBuff() + copy.getHpBuff());
		main.setSkillDamage(main.getSkillDamage() + copy.getSkillDamage());
		main.setAttackBuff(main.getAttackBuff() + copy.getAttackBuff());
		main.setDefendBuff(main.getDefendBuff() + copy.getDefendBuff());
		main.setDefendIgnore(main.getDefendIgnore() + copy.getDefendIgnore());
		main.setSpeedBuff(main.getSpeedBuff() + copy.getSpeedBuff());
		main.setCureBuff(main.getCureBuff() + copy.getCureBuff());
		main.setBecureBuff(main.getBecureBuff() + copy.getBecureBuff());
		main.setCrit(main.getCrit() + copy.getCrit());
		main.setCritResist(main.getCritResist() + copy.getCritResist());
		main.setBlock(main.getBlock() + copy.getBlock());
		main.setBlockResist(main.getBlockResist() + copy.getBlockResist());
		main.setCtrlResist(main.getCtrlResist() + copy.getCtrlResist());
		main.setSlientResist(main.getSlientResist() + copy.getSlientResist());
		main.setDisarmResist(main.getDisarmResist() + copy.getDisarmResist());
		main.setStayResist(main.getStayResist() + copy.getStayResist());
		main.setFreezeResist(main.getFreezeResist() + copy.getFreezeResist());
		main.setDizzyResist(main.getDizzyResist() + copy.getDizzyResist());
		main.setStoneResist(main.getStoneResist() + copy.getStoneResist());
		main.setAttack(main.getAttack() + copy.getAttack());
		main.setDamage(main.getDamage() + copy.getDamage());
		main.setCritDamageBuff(main.getCritDamageBuff() + copy.getCritDamageBuff());
		main.setHp(main.getHp() + copy.getHp());
		main.setDefend(main.getDefend() + copy.getDefend());
		main.setHolyBuff(main.getHolyBuff() + copy.getHolyBuff());
		main.setWeakBuff(main.getWeakBuff() + copy.getWeakBuff());
		main.setVsFireBuff(main.getVsFireBuff() + copy.getVsFireBuff());
		main.setVsWoodBuff(main.getVsWoodBuff() + copy.getVsWoodBuff());
		main.setVsWaterBuff(main.getVsWaterBuff() + copy.getVsWaterBuff());
		main.setVsLightBuff(main.getVsLightBuff() + copy.getVsLightBuff());
		main.setVsDarkBuff(main.getVsDarkBuff() + copy.getVsDarkBuff());
		main.setVsSlientBuff(main.getVsSlientBuff() + copy.getVsSlientBuff());
		main.setVsDisarmBuff(main.getVsDisarmBuff() + copy.getVsDisarmBuff());
		main.setVsStayBuff(main.getVsStayBuff() + copy.getVsStayBuff());
		main.setVsFreezeBuff(main.getVsFreezeBuff() + copy.getVsFreezeBuff());
		main.setVsDizzyBuff(main.getVsDizzyBuff() + copy.getVsDizzyBuff());
		main.setVsStoneBuff(main.getVsStoneBuff() + copy.getVsStoneBuff());
		main.setDamageBuff(main.getDamageBuff() + copy.getDamageBuff());
		main.setVsWarriorBuff(main.getVsWarriorBuff() + copy.getVsWarriorBuff());
		main.setVsWitchBuff(main.getVsWitchBuff() + copy.getVsWitchBuff());
		main.setVsPastorBuff(main.getVsPastorBuff() + copy.getVsPastorBuff());
		main.setVsAssassinBuff(main.getVsAssassinBuff() + copy.getVsAssassinBuff());
		main.setVsRangerBuff(main.getVsRangerBuff() + copy.getVsRangerBuff());
		main.setDamageReduce(main.getDamageReduce() + copy.getDamageReduce());
		main.setVsFiringBuff(main.getVsFiringBuff() + copy.getVsFiringBuff());
		main.setVsFrostBuff(main.getVsFrostBuff() + copy.getVsFrostBuff());
		main.setVsPoisonBuff(main.getVsPoisonBuff() + copy.getVsPoisonBuff());
		main.setVsElecBuff(main.getVsElecBuff() + copy.getVsElecBuff());
		main.setVsBleedBuf(main.getVsBleedBuf() + copy.getVsBleedBuf());
		main.setFiringResist(main.getFiringResist() + copy.getFiringResist());
		main.setFrostResists(main.getFrostResists() + copy.getFrostResists());
		main.setPoisonResist(main.getPoisonResist() + copy.getPoisonResist());
		main.setElecResist(main.getElecResist() + copy.getElecResist());
		main.setBleedResist(main.getBleedResist() + copy.getBleedResist());
	}
	public void mergeAttr(IBattleAttr copy) {
		this.setCure(this.getCure() + copy.getCure());
		this.setSpeed(this.getSpeed() + copy.getSpeed());
		this.setHpBuff(this.getHpBuff() + copy.getHpBuff());
		this.setSkillDamage(this.getSkillDamage() + copy.getSkillDamage());
		this.setAttackBuff(this.getAttackBuff() + copy.getAttackBuff());
		this.setDefendBuff(this.getDefendBuff() + copy.getDefendBuff());
		this.setDefendIgnore(this.getDefendIgnore() + copy.getDefendIgnore());
		this.setSpeedBuff(this.getSpeedBuff() + copy.getSpeedBuff());
		this.setCureBuff(this.getCureBuff() + copy.getCureBuff());
		this.setBecureBuff(this.getBecureBuff() + copy.getBecureBuff());
		this.setCrit(this.getCrit() + copy.getCrit());
		this.setCritResist(this.getCritResist() + copy.getCritResist());
		this.setBlock(this.getBlock() + copy.getBlock());
		this.setBlockResist(this.getBlockResist() + copy.getBlockResist());
		this.setCtrlResist(this.getCtrlResist() + copy.getCtrlResist());
		this.setSlientResist(this.getSlientResist() + copy.getSlientResist());
		this.setDisarmResist(this.getDisarmResist() + copy.getDisarmResist());
		this.setStayResist(this.getStayResist() + copy.getStayResist());
		this.setFreezeResist(this.getFreezeResist() + copy.getFreezeResist());
		this.setDizzyResist(this.getDizzyResist() + copy.getDizzyResist());
		this.setStoneResist(this.getStoneResist() + copy.getStoneResist());
		this.setAttack(this.getAttack() + copy.getAttack());
		this.setDamage(this.getDamage() + copy.getDamage());
		this.setCritDamageBuff(this.getCritDamageBuff() + copy.getCritDamageBuff());
		this.setHp(this.getHp() + copy.getHp());
		this.setDefend(this.getDefend() + copy.getDefend());
		this.setHolyBuff(this.getHolyBuff() + copy.getHolyBuff());
		this.setWeakBuff(this.getWeakBuff() + copy.getWeakBuff());
		this.setVsFireBuff(this.getVsFireBuff() + copy.getVsFireBuff());
		this.setVsWoodBuff(this.getVsWoodBuff() + copy.getVsWoodBuff());
		this.setVsWaterBuff(this.getVsWaterBuff() + copy.getVsWaterBuff());
		this.setVsLightBuff(this.getVsLightBuff() + copy.getVsLightBuff());
		this.setVsDarkBuff(this.getVsDarkBuff() + copy.getVsDarkBuff());
		this.setVsSlientBuff(this.getVsSlientBuff() + copy.getVsSlientBuff());
		this.setVsDisarmBuff(this.getVsDisarmBuff() + copy.getVsDisarmBuff());
		this.setVsStayBuff(this.getVsStayBuff() + copy.getVsStayBuff());
		this.setVsFreezeBuff(this.getVsFreezeBuff() + copy.getVsFreezeBuff());
		this.setVsDizzyBuff(this.getVsDizzyBuff() + copy.getVsDizzyBuff());
		this.setVsStoneBuff(this.getVsStoneBuff() + copy.getVsStoneBuff());
		this.setDamageBuff(this.getDamageBuff() + copy.getDamageBuff());
		this.setVsWarriorBuff(this.getVsWarriorBuff() + copy.getVsWarriorBuff());
		this.setVsWitchBuff(this.getVsWitchBuff() + copy.getVsWitchBuff());
		this.setVsPastorBuff(this.getVsPastorBuff() + copy.getVsPastorBuff());
		this.setVsAssassinBuff(this.getVsAssassinBuff() + copy.getVsAssassinBuff());
		this.setVsRangerBuff(this.getVsRangerBuff() + copy.getVsRangerBuff());
		this.setDamageReduce(this.getDamageReduce() + copy.getDamageReduce());
		this.setVsFiringBuff(this.getVsFiringBuff() + copy.getVsFiringBuff());
		this.setVsFrostBuff(this.getVsFrostBuff() + copy.getVsFrostBuff());
		this.setVsPoisonBuff(this.getVsPoisonBuff() + copy.getVsPoisonBuff());
		this.setVsElecBuff(this.getVsElecBuff() + copy.getVsElecBuff());
		this.setVsBleedBuf(this.getVsBleedBuf() + copy.getVsBleedBuf());
		this.setFiringResist(this.getFiringResist() + copy.getFiringResist());
		this.setFrostResists(this.getFrostResists() + copy.getFrostResists());
		this.setPoisonResist(this.getPoisonResist() + copy.getPoisonResist());
		this.setElecResist(this.getElecResist() + copy.getElecResist());
		this.setBleedResist(this.getBleedResist() + copy.getBleedResist());
	}
	public static void mergeFightAttr(IBattleAttr fightAttr, int type, int value) {
		switch (type) {
		case 100:
			fightAttr.setCure(fightAttr.getCure() + value);
			break;
		case 101:
			fightAttr.setSpeed(fightAttr.getSpeed() + value);
			break;
		case 102:
			fightAttr.setHpBuff(fightAttr.getHpBuff() + value);
			break;
		case 200:
			fightAttr.setSkillDamage(fightAttr.getSkillDamage() + value);
			break;
		case 201:
			fightAttr.setAttackBuff(fightAttr.getAttackBuff() + value);
			break;
		case 202:
			fightAttr.setDefendBuff(fightAttr.getDefendBuff() + value);
			break;
		case 203:
			fightAttr.setDefendIgnore(fightAttr.getDefendIgnore() + value);
			break;
		case 204:
			fightAttr.setSpeedBuff(fightAttr.getSpeedBuff() + value);
			break;
		case 205:
			fightAttr.setCureBuff(fightAttr.getCureBuff() + value);
			break;
		case 206:
			fightAttr.setBecureBuff(fightAttr.getBecureBuff() + value);
			break;
		case 207:
			fightAttr.setCrit(fightAttr.getCrit() + value);
			break;
		case 208:
			fightAttr.setCritResist(fightAttr.getCritResist() + value);
			break;
		case 210:
			fightAttr.setBlock(fightAttr.getBlock() + value);
			break;
		case 211:
			fightAttr.setBlockResist(fightAttr.getBlockResist() + value);
			break;
		case 212:
			fightAttr.setCtrlResist(fightAttr.getCtrlResist() + value);
			break;
		case 213:
			fightAttr.setSlientResist(fightAttr.getSlientResist() + value);
			break;
		case 214:
			fightAttr.setDisarmResist(fightAttr.getDisarmResist() + value);
			break;
		case 215:
			fightAttr.setStayResist(fightAttr.getStayResist() + value);
			break;
		case 216:
			fightAttr.setFreezeResist(fightAttr.getFreezeResist() + value);
			break;
		case 217:
			fightAttr.setDizzyResist(fightAttr.getDizzyResist() + value);
			break;
		case 218:
			fightAttr.setStoneResist(fightAttr.getStoneResist() + value);
			break;
		case 220:
			fightAttr.setAttack(fightAttr.getAttack() + value);
			break;
		case 221:
			fightAttr.setDamage(fightAttr.getDamage() + value);
			break;
		case 222:
			fightAttr.setCritDamageBuff(fightAttr.getCritDamageBuff() + value);
			break;
		case 223:
			fightAttr.setHp(fightAttr.getHp() + value);
			break;
		case 224:
			fightAttr.setDefend(fightAttr.getDefend() + value);
			break;
		case 225:
			fightAttr.setHolyBuff(fightAttr.getHolyBuff() + value);
			break;
		case 230:
			fightAttr.setWeakBuff(fightAttr.getWeakBuff() + value);
			break;
		case 251:
			fightAttr.setVsFireBuff(fightAttr.getVsFireBuff() + value);
			break;
		case 252:
			fightAttr.setVsWoodBuff(fightAttr.getVsWoodBuff() + value);
			break;
		case 253:
			fightAttr.setVsWaterBuff(fightAttr.getVsWaterBuff() + value);
			break;
		case 254:
			fightAttr.setVsLightBuff(fightAttr.getVsLightBuff() + value);
			break;
		case 255:
			fightAttr.setVsDarkBuff(fightAttr.getVsDarkBuff() + value);
			break;
		case 260:
			fightAttr.setVsSlientBuff(fightAttr.getVsSlientBuff() + value);
			break;
		case 261:
			fightAttr.setVsDisarmBuff(fightAttr.getVsDisarmBuff() + value);
			break;
		case 262:
			fightAttr.setVsStayBuff(fightAttr.getVsStayBuff() + value);
			break;
		case 263:
			fightAttr.setVsFreezeBuff(fightAttr.getVsFreezeBuff() + value);
			break;
		case 264:
			fightAttr.setVsDizzyBuff(fightAttr.getVsDizzyBuff() + value);
			break;
		case 265:
			fightAttr.setVsStoneBuff(fightAttr.getVsStoneBuff() + value);
			break;
		case 270:
			fightAttr.setDamageBuff(fightAttr.getDamageBuff() + value);
			break;
		case 281:
			fightAttr.setVsWarriorBuff(fightAttr.getVsWarriorBuff() + value);
			break;
		case 282:
			fightAttr.setVsWitchBuff(fightAttr.getVsWitchBuff() + value);
			break;
		case 283:
			fightAttr.setVsPastorBuff(fightAttr.getVsPastorBuff() + value);
			break;
		case 284:
			fightAttr.setVsAssassinBuff(fightAttr.getVsAssassinBuff() + value);
			break;
		case 285:
			fightAttr.setVsRangerBuff(fightAttr.getVsRangerBuff() + value);
			break;
		case 291:
			fightAttr.setDamageReduce(fightAttr.getDamageReduce() + value);
			break;
		case 301:
			fightAttr.setVsFiringBuff(fightAttr.getVsFiringBuff() + value);
			break;
		case 302:
			fightAttr.setVsFrostBuff(fightAttr.getVsFrostBuff() + value);
			break;
		case 303:
			fightAttr.setVsPoisonBuff(fightAttr.getVsPoisonBuff() + value);
			break;
		case 304:
			fightAttr.setVsElecBuff(fightAttr.getVsElecBuff() + value);
			break;
		case 305:
			fightAttr.setVsBleedBuf(fightAttr.getVsBleedBuf() + value);
			break;
		case 321:
			fightAttr.setFiringResist(fightAttr.getFiringResist() + value);
			break;
		case 322:
			fightAttr.setFrostResists(fightAttr.getFrostResists() + value);
			break;
		case 323:
			fightAttr.setPoisonResist(fightAttr.getPoisonResist() + value);
			break;
		case 324:
			fightAttr.setElecResist(fightAttr.getElecResist() + value);
			break;
		case 325:
			fightAttr.setBleedResist(fightAttr.getBleedResist() + value);
			break;
		default:
			break;
		}
	}
	public void copyAttr(IBattleAttr oriAttr, int multiple) {
		this.cure = oriAttr.getCure() * multiple;
		this.speed = oriAttr.getSpeed() * multiple;
		this.hpBuff = oriAttr.getHpBuff() * multiple;
		this.skillDamage = oriAttr.getSkillDamage() * multiple;
		this.attackBuff = oriAttr.getAttackBuff() * multiple;
		this.defendBuff = oriAttr.getDefendBuff() * multiple;
		this.defendIgnore = oriAttr.getDefendIgnore() * multiple;
		this.speedBuff = oriAttr.getSpeedBuff() * multiple;
		this.cureBuff = oriAttr.getCureBuff() * multiple;
		this.becureBuff = oriAttr.getBecureBuff() * multiple;
		this.crit = oriAttr.getCrit() * multiple;
		this.critResist = oriAttr.getCritResist() * multiple;
		this.block = oriAttr.getBlock() * multiple;
		this.blockResist = oriAttr.getBlockResist() * multiple;
		this.ctrlResist = oriAttr.getCtrlResist() * multiple;
		this.slientResist = oriAttr.getSlientResist() * multiple;
		this.disarmResist = oriAttr.getDisarmResist() * multiple;
		this.stayResist = oriAttr.getStayResist() * multiple;
		this.freezeResist = oriAttr.getFreezeResist() * multiple;
		this.dizzyResist = oriAttr.getDizzyResist() * multiple;
		this.stoneResist = oriAttr.getStoneResist() * multiple;
		this.attack = oriAttr.getAttack() * multiple;
		this.damage = oriAttr.getDamage() * multiple;
		this.critDamageBuff = oriAttr.getCritDamageBuff() * multiple;
		this.hp = oriAttr.getHp() * multiple;
		this.defend = oriAttr.getDefend() * multiple;
		this.holyBuff = oriAttr.getHolyBuff() * multiple;
		this.weakBuff = oriAttr.getWeakBuff() * multiple;
		this.vsFireBuff = oriAttr.getVsFireBuff() * multiple;
		this.vsWoodBuff = oriAttr.getVsWoodBuff() * multiple;
		this.vsWaterBuff = oriAttr.getVsWaterBuff() * multiple;
		this.vsLightBuff = oriAttr.getVsLightBuff() * multiple;
		this.vsDarkBuff = oriAttr.getVsDarkBuff() * multiple;
		this.vsSlientBuff = oriAttr.getVsSlientBuff() * multiple;
		this.vsDisarmBuff = oriAttr.getVsDisarmBuff() * multiple;
		this.vsStayBuff = oriAttr.getVsStayBuff() * multiple;
		this.vsFreezeBuff = oriAttr.getVsFreezeBuff() * multiple;
		this.vsDizzyBuff = oriAttr.getVsDizzyBuff() * multiple;
		this.vsStoneBuff = oriAttr.getVsStoneBuff() * multiple;
		this.damageBuff = oriAttr.getDamageBuff() * multiple;
		this.vsWarriorBuff = oriAttr.getVsWarriorBuff() * multiple;
		this.vsWitchBuff = oriAttr.getVsWitchBuff() * multiple;
		this.vsPastorBuff = oriAttr.getVsPastorBuff() * multiple;
		this.vsAssassinBuff = oriAttr.getVsAssassinBuff() * multiple;
		this.vsRangerBuff = oriAttr.getVsRangerBuff() * multiple;
		this.damageReduce = oriAttr.getDamageReduce() * multiple;
		this.vsFiringBuff = oriAttr.getVsFiringBuff() * multiple;
		this.vsFrostBuff = oriAttr.getVsFrostBuff() * multiple;
		this.vsPoisonBuff = oriAttr.getVsPoisonBuff() * multiple;
		this.vsElecBuff = oriAttr.getVsElecBuff() * multiple;
		this.vsBleedBuf = oriAttr.getVsBleedBuf() * multiple;
		this.firingResist = oriAttr.getFiringResist() * multiple;
		this.frostResists = oriAttr.getFrostResists() * multiple;
		this.poisonResist = oriAttr.getPoisonResist() * multiple;
		this.elecResist = oriAttr.getElecResist() * multiple;
		this.bleedResist = oriAttr.getBleedResist() * multiple;
	}
	public void copyAttr(IBattleAttr oriAttr) {
		copyAttr(oriAttr, 1);
	}
}