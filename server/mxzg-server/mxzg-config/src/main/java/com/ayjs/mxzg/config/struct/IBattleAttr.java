package com.ayjs.mxzg.config.struct;

public interface IBattleAttr {
	/**
	 * 治疗效果：%d
	 */
	public int getCure();
	public void setCure(int cure);
	/**
	 * 速度：%d
	 */
	public int getSpeed();
	public void setSpeed(int speed);
	/**
	 * 生命值：##p##%%
	 */
	public int getHpBuff();
	public void setHpBuff(int hpBuff);
	/**
	 * 技能伤害：##p##%%
	 */
	public int getSkillDamage();
	public void setSkillDamage(int skillDamage);
	/**
	 * 攻击：##p##%%
	 */
	public int getAttackBuff();
	public void setAttackBuff(int attackBuff);
	/**
	 * 防御：##p##%%
	 */
	public int getDefendBuff();
	public void setDefendBuff(int defendBuff);
	/**
	 * 无视防御：##p##%%
	 */
	public int getDefendIgnore();
	public void setDefendIgnore(int defendIgnore);
	/**
	 * 速度：##p##%%
	 */
	public int getSpeedBuff();
	public void setSpeedBuff(int speedBuff);
	/**
	 * 治疗效果：##p##%%
	 */
	public int getCureBuff();
	public void setCureBuff(int cureBuff);
	/**
	 * 被治疗效果：##p##%%
	 */
	public int getBecureBuff();
	public void setBecureBuff(int becureBuff);
	/**
	 * 暴击：##p##%%
	 */
	public int getCrit();
	public void setCrit(int crit);
	/**
	 * 抗暴：##p##%%
	 */
	public int getCritResist();
	public void setCritResist(int critResist);
	/**
	 * 格挡：##p##%%
	 */
	public int getBlock();
	public void setBlock(int block);
	/**
	 * 精准：##p##%%
	 */
	public int getBlockResist();
	public void setBlockResist(int blockResist);
	/**
	 * 免控：##p##%%
	 */
	public int getCtrlResist();
	public void setCtrlResist(int ctrlResist);
	/**
	 * 沉默抵抗：##p##%%
	 */
	public int getSlientResist();
	public void setSlientResist(int slientResist);
	/**
	 * 缴械抵抗：##p##%%
	 */
	public int getDisarmResist();
	public void setDisarmResist(int disarmResist);
	/**
	 * 定身抵抗：##p##%%
	 */
	public int getStayResist();
	public void setStayResist(int stayResist);
	/**
	 * 冰冻抵抗：##p##%%
	 */
	public int getFreezeResist();
	public void setFreezeResist(int freezeResist);
	/**
	 * 眩晕抵抗：##p##%%
	 */
	public int getDizzyResist();
	public void setDizzyResist(int dizzyResist);
	/**
	 * 石化抵抗：##p##%%
	 */
	public int getStoneResist();
	public void setStoneResist(int stoneResist);
	/**
	 * 攻击：%d
	 */
	public int getAttack();
	public void setAttack(int attack);
	/**
	 * 伤害：%d
	 */
	public int getDamage();
	public void setDamage(int damage);
	/**
	 * 暴击伤害：##p##%%
	 */
	public int getCritDamageBuff();
	public void setCritDamageBuff(int critDamageBuff);
	/**
	 * 血量：%d
	 */
	public long getHp();
	public void setHp(long hp);
	/**
	 * 防御：%d
	 */
	public int getDefend();
	public void setDefend(int defend);
	/**
	 * 神圣伤害：##p##%%
	 */
	public int getHolyBuff();
	public void setHolyBuff(int holyBuff);
	/**
	 * 虚弱：##p##%%
	 */
	public int getWeakBuff();
	public void setWeakBuff(int weakBuff);
	/**
	 * 对火的伤害：##p##%%
	 */
	public int getVsFireBuff();
	public void setVsFireBuff(int vsFireBuff);
	/**
	 * 对木的伤害：##p##%%
	 */
	public int getVsWoodBuff();
	public void setVsWoodBuff(int vsWoodBuff);
	/**
	 * 对水的伤害：##p##%%
	 */
	public int getVsWaterBuff();
	public void setVsWaterBuff(int vsWaterBuff);
	/**
	 * 对光的伤害：##p##%%
	 */
	public int getVsLightBuff();
	public void setVsLightBuff(int vsLightBuff);
	/**
	 * 对暗的伤害：##p##%%
	 */
	public int getVsDarkBuff();
	public void setVsDarkBuff(int vsDarkBuff);
	/**
	 * 对沉默目标伤害：##p##%%
	 */
	public int getVsSlientBuff();
	public void setVsSlientBuff(int vsSlientBuff);
	/**
	 * 对缴械目标伤害：##p##%%
	 */
	public int getVsDisarmBuff();
	public void setVsDisarmBuff(int vsDisarmBuff);
	/**
	 * 对定身目标伤害：##p##%%
	 */
	public int getVsStayBuff();
	public void setVsStayBuff(int vsStayBuff);
	/**
	 * 对冰冻目标伤害：##p##%%
	 */
	public int getVsFreezeBuff();
	public void setVsFreezeBuff(int vsFreezeBuff);
	/**
	 * 对眩晕目标伤害：##p##%%
	 */
	public int getVsDizzyBuff();
	public void setVsDizzyBuff(int vsDizzyBuff);
	/**
	 * 对石化目标伤害：##p##%%
	 */
	public int getVsStoneBuff();
	public void setVsStoneBuff(int vsStoneBuff);
	/**
	 * 最终伤害结果增加：##p##%%
	 */
	public int getDamageBuff();
	public void setDamageBuff(int damageBuff);
	/**
	 * 对战士伤害：##p##%%
	 */
	public int getVsWarriorBuff();
	public void setVsWarriorBuff(int vsWarriorBuff);
	/**
	 * 对法师伤害：##p##%%
	 */
	public int getVsWitchBuff();
	public void setVsWitchBuff(int vsWitchBuff);
	/**
	 * 对牧师伤害：##p##%%
	 */
	public int getVsPastorBuff();
	public void setVsPastorBuff(int vsPastorBuff);
	/**
	 * 对刺客伤害：##p##%%
	 */
	public int getVsAssassinBuff();
	public void setVsAssassinBuff(int vsAssassinBuff);
	/**
	 * 对游侠伤害：##p##%%
	 */
	public int getVsRangerBuff();
	public void setVsRangerBuff(int vsRangerBuff);
	/**
	 * 伤害减免：##p##%%
	 */
	public int getDamageReduce();
	public void setDamageReduce(int damageReduce);
	/**
	 * 对灼烧目标伤害：##p##%%
	 */
	public int getVsFiringBuff();
	public void setVsFiringBuff(int vsFiringBuff);
	/**
	 * 对霜冻目标伤害：##p##%%
	 */
	public int getVsFrostBuff();
	public void setVsFrostBuff(int vsFrostBuff);
	/**
	 * 对中毒目标伤害：##p##%%
	 */
	public int getVsPoisonBuff();
	public void setVsPoisonBuff(int vsPoisonBuff);
	/**
	 * 对感电目标伤害：##p##%%
	 */
	public int getVsElecBuff();
	public void setVsElecBuff(int vsElecBuff);
	/**
	 * 对流血目标伤害：##p##%%
	 */
	public int getVsBleedBuf();
	public void setVsBleedBuf(int vsBleedBuf);
	/**
	 * 灼烧抵抗：##p##%%
	 */
	public int getFiringResist();
	public void setFiringResist(int firingResist);
	/**
	 * 霜冻抵抗：##p##%%
	 */
	public int getFrostResists();
	public void setFrostResists(int frostResists);
	/**
	 * 中毒抵抗：##p##%%
	 */
	public int getPoisonResist();
	public void setPoisonResist(int poisonResist);
	/**
	 * 感电抵抗：##p##%%
	 */
	public int getElecResist();
	public void setElecResist(int elecResist);
	/**
	 * 流血抵抗：##p##%%
	 */
	public int getBleedResist();
	public void setBleedResist(int bleedResist);
}