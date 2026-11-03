package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.config.excel.entity.CHeroElemMul;
import com.ayjs.mxzg.config.struct.ActiveType;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.DamageType;
import com.ayjs.mxzg.config.struct.EffectType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.BattleGMsg.HeroUnit;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.google.common.collect.Lists;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Getter;
import lombok.Setter;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 英雄信息
 *
 * @author meiyc
 */
@Builder
@Getter
@Setter
public class HeroDo implements Comparable<HeroDo> {


	/** 数据库的主键id */
	private long id;
	/** 单位id */
	private int unitId;
	/** 英雄id */
	private int heroId;
	/** 英雄名字 */
	private String name;
	/** 位置 */
	private int position;
	/** 等级 */
	private int level;
	/** 星级 */
	private int star;
	/** 等阶 */
	private int stage;
	/** 皮肤id */
	private int fashionId;
	/** 元素克制倍率配置表 */
	private CHeroElemMul elementMul;
	/** 职业 */
	private Job job;
	/** 伤害类型 */
	@Default
	private DamageType damageType = DamageType.PHYSICAL;
	/** 阵营 */
	private Faction faction;
	/** 英雄状态 */
	@Default
	private HeroStatus status = HeroStatus.SURVIVE;
	/** Buff信息 */
	private BuffsInfo buffInfo;
	/** 技能信息 */
	private SkillInfo skillInfo;
	/** 属性信息 */
	private AttributeInfo attributeInfo;
	/** 反击/追击/连击相关信息 */
	private ActionInfo actionInfo;
	/** 死亡触发中 */
	private boolean deathTrigger;
	/** 本次攻击中断的unitId列表 */
	private List<Integer> interrupts;
	/** 反击过的单位id列表 */
	@Default
	private Set<Integer> counterattackIds = new HashSet<>();
	/** 战斗事件DO*/
	private FightEventDo eventDo;
	/** 最后被施加的控制buff */
	private BuffDo lastControlBuff;
	/** 当前回合的伤害结果 */
	private DamageResult result;
	/** 当前使用的技能 */
	private SkillDo currentSkill;
	/** 战斗日志 */
	private HeroFightLog fightLog;
	/** 上次治疗量 */
	private long lastTreatmentValue;
	/** 挂机封印 */
	private boolean hangUpSeal;
	/**进化信息*/
	@Default
	private EvolveData evolve = EvolveData.of(0,0);
	/**
	 * 上下文内容
	 */
	@Default
	private Map<ContextType, Long> contextContent = new HashMap<>();



	public static HeroDo createOf(HeroVo heroVo){
		HeroDo.HeroDoBuilder heroDo = HeroDo.builder();
		heroDo.heroId(heroVo.getHeroId()).stage(heroVo.getStage()).star(heroVo.getStar()).name(heroVo.getName());
		heroDo.level(heroVo.getLevel()).position(heroVo.getPos()).id(heroVo.getId()).fashionId(heroVo.getFashionId());
		AttributeInfo attributeInfo = AttributeInfo.createOf(heroVo.getAttributes());
		BuffsInfo buffsInfo = heroVo.isSaveTriggerTimes() ? BuffsInfo.createOf(heroVo.getTriggerTimes()) : BuffsInfo.getInstance();
		heroDo.attributeInfo(attributeInfo);
		heroDo.buffInfo(buffsInfo);
		heroDo.actionInfo(ActionInfo.getInstance());
		heroDo.evolve(EvolveData.of(heroVo.getEvolve()));
		return heroDo.build();
	}

	/**
	 * 获取速度
	 * @return
	 */
	public long getSpeed(){
		return getAttribute(AttributeType.SPEED);
	}

	/**
	 * 获取属性值
	 * @param type
	 * @return
	 */
	public long getAttribute(AttributeType type){
		return this.attributeInfo.getAttribute(type);
	}

	/**
	 * 获取当前血量
	 * @return
	 */
	public long getHp(){
		return getAttribute(AttributeType.HP);
	}

	/**
	 * 获取血量百分比
	 * @return
	 */
	public double getHpRate(){
		long hp = getHp();
		long maxHp = this.attributeInfo.getMaxHp();
		return hp * 1.0 / maxHp;
	}

	/**
	 * 获取百分比
	 * @param type
	 * @return
	 */
	public double getRate(AttributeType type){
		return this.attributeInfo.getRate(type);
	}

	/**
	 * 根据当前回合选择技能
	 * @param currentRound
	 * @return
	 */
	public SkillDo getSkill(int currentRound){
		if(this.actionInfo.hasNextAction()){
			Action action = this.actionInfo.getNextAction();
			this.actionInfo.setCounterattack();
			this.attributeInfo.setEffect(action.getEffectPercent());
			this.currentSkill = this.actionInfo.nextActionSkill();
		} else if(isOnlyAttack()){
			this.currentSkill = this.skillInfo.getGeneralAttack();
		} else {
			this.currentSkill = this.skillInfo.getSkillBy(currentRound);
		}
		return this.currentSkill;
	}



	/**
	 * 根据测试类型获取技能
	 * @param testType
	 * @param currentRound
	 * @return
	 */
	public SkillDo getTestSkill(int testType, int currentRound){
		if(this.actionInfo.hasNextAction()){
			return getSkill(currentRound);
		}
		if(testType == 3){
			this.currentSkill = this.skillInfo.getActiveSkills().get(0);
		} else if(testType == 4){
			if(this.skillInfo.getActiveSkills().size() >= 2){
				this.currentSkill =  this.skillInfo.getActiveSkills().get(1);
			} else {
				this.currentSkill =  this.skillInfo.getActiveSkills().get(0);
			}
		} else if(testType == 6){
			this.currentSkill = this.skillInfo.getGeneralAttack();
		} else {
			return getSkill(currentRound);
		}

		return this.currentSkill;
	}

	/**
	 * 当前技能类型是否是指定的技能类型
	 * @param type
	 * @return
	 */
	public boolean currentSkillIs(ActiveType type){
		return this.currentSkill != null && this.currentSkill.getSkill().getActive_type() == type;
	}

	/**
	 * 当前回合配置释放的技能是不是必定先手技能
	 * @param round
	 * @return
	 */
	public boolean currentSkillIsFirst(int round){
		return this.skillInfo.getSkillBy(round).getSkill().isFirst();
	}

	/**
	 * 根据buff类型获取buff列表
	 * @param buffType
	 * @return
	 */
	public List<BuffDo> getBuffsBy(BuffType buffType){
		return this.buffInfo.getBuffersByType(buffType);
	}

	/**
	 * 根据buff效果类型获取buff列表，且不包含被动和不可驱散类型
	 * @param type
	 * @return
	 */
	public List<BuffDo> getBuffsBy(EffectType type){
		return this.buffInfo.getBuffersBy(type);
	}

	/**
	 * 根据buff类型获取buff列表
	 * @param buffType
	 * @param sourceId
	 * @return
	 */
	public List<BuffDo> getBuffsBy(BuffType buffType, int sourceId){
		return this.buffInfo.getBuffersByType(buffType, sourceId);
	}

	/**
	 * 获取监听buff的类型
	 * @param buffType
	 * @return
	 */
	public List<BuffDo> getListenTrigger(BuffType buffType){
		return this.buffInfo.getBuffs().stream().filter(buff-> buff.isTriggerType(buffType)).collect(Collectors.toList());
	}

	/**
	 * 根据buffType和来源id获取buff
	 * @param buffType
	 * @param sourceId
	 * @return
	 */
	public Optional<BuffDo> getBuffBy(BuffType buffType, int sourceId){
		return this.buffInfo.getBuffs().stream().filter(buffDo -> buffDo.getType() == buffType && buffDo.getSourceId() == sourceId).findFirst();
	}

	/**
	 * 根据buff类型获取buff列表
	 * @return
	 */
	public List<BuffDo> getDeBuffs(){
        return this.getAllBuffs().stream().filter(buff -> buff.getBuff().getEffecttype() == EffectType.DEBUFF).collect(Collectors.toList());
	}

	/**
	 * 获取所有buff，不包含被动技能
	 * @return
	 */
	public List<BuffDo> getAllBuffs(){
		return this.buffInfo.getBuffs().stream().filter(buff-> !buff.isPassiveSkill()).collect(Collectors.toList());
	}

    /**
     * 获取死亡需要移除的buff
     * @return
     */
    public List<BuffDo> getDeadRemoveBuffs(){
        return getAllBuffs().stream().filter(buff-> !buff.getType().deathBuff()).collect(Collectors.toList());
    }

	/**
	 * 获取指定回合类型的回合buff列表
	 *
	 * @param buffType
	 * @param round
	 * @return
	 */
	public List<BuffDo> getRoundBuffs(BuffType buffType, int round) {
		return getAllBuffs().stream().filter(buff -> !buff.getType().deathBuff() && buff.isExecuteRoundBuff(buffType, round)).collect(Collectors.toList());
	}

	/**
	 * 获取指定回合类型的回合buff列表
	 *
	 * @return
	 */
	public List<BuffDo> getDeadBuffs() {
		return getAllBuffs().stream().filter(buff -> buff.getType().deathBuff()).collect(Collectors.toList());
	}

	/**
	 * 开启反击
	 */
	public void openCounterattack() {
		this.counterattackIds.clear();
	}

	/**
	 * 是否触发过反击
	 *
	 * @param unitId
	 * @return
	 */
	public boolean isTriggeredCounterattack(int unitId) {
		return this.counterattackIds.contains(unitId);
	}

	/**
	 * 关闭目标反击
	 *
	 * @return
	 */
	public void closeCounterattack(int unitId) {
		this.counterattackIds.add(unitId);
	}

	/**
	 * 是否是反击
	 * @return
	 */
	public boolean isCounterattack(){
		return this.actionInfo.isCounterattack();
	}

	/**
	 * 是否是普攻行动
	 * @return
	 */
	public boolean isGeneralAction(){
		return this.actionInfo.isGeneralCounterattack(this.skillInfo.getGeneralAttack());
	}

	/**
	 * 是否已经存在指定技能动作
	 * @param skillDo
	 * @return
	 */
	public boolean isExistActionSkill(SkillDo skillDo){
		return this.actionInfo.isExistActionSkill(skillDo);
	}

	/**
	 * 是否是前排玩家
	 * @return
	 */
	public boolean isFront(){
		return BattleConstant.FRONT_POSITION.contains(this.position);
	}

	/**
	 * 中断本次攻击
	 */
	public void interrupt(int targetId){
		this.interrupts.add(targetId);
	}

	/**
	 * 目标攻击是否已经中断
	 * @param targetId
	 * @return
	 */
	public boolean isInterrupt(int targetId){
        return this.interrupts.contains(targetId);
	}

	/**
	 * 是否是指定的元素
	 * @param elementType
	 * @return
	 */
	public boolean isElement(int elementType){
		return this.getElementMul().getIdx() == elementType;
	}

	/**
	 * 不是英雄
	 * @return
	 */
	public boolean notHero(){
		return this.elementMul == null;
	}

	/**
	 * 恢复出手状态，使用技能前和使用技能后都需要恢复一次
	 */
	public void restore(){
		this.interrupts.clear();
	}

	/**
	 * 当前技能是否是光环
	 * @return
	 */
	public boolean currentSkillIsHalo(){
		return this.currentSkill != null && this.currentSkill.isHalo();
	}

	/**
	 * 添加伤害结果，如果上次伤害是同一次伤害则累计伤害
	 * @param result
	 */
	public void addDamageResult(DamageResult result){
		if(this.result != null && this.result != result && result.getBuffId() != 0 && result.getBuffId() == result.getBuffId()){
			result.updateTotalDamage(this.result.getTotalDamage());
		}
		this.result = result;
	}

	/**
	 * 清理攻击信息
	 */
	public void cleanAttack(){
		this.currentSkill = null;
		this.result = null;
		this.actionInfo.cleanCounterattack(this.attributeInfo);
	}

	/**
	 * 受伤害
	 * @param damage
	 * @return 返回实际伤害的血量
	 */
	public long hurt(long damage) {
		long hp = -getHp();
		damage = damage < hp ? hp : damage;
		this.attributeInfo.updateAttribute(AttributeType.HP, damage);
		addTakeDamageLog(damage);
		if(getHp() <= 0){
			this.status = HeroStatus.DEAD;
		}
		return damage;
	}

	/**
	 * 回血
	 * @param replenishHp
	 * @return 实际恢复的血量
	 */
	public long replenish(long replenishHp){
		long maxHp = this.attributeInfo.getMaxHp();
		long currentHp = getHp();
		long maxReplenishHp = maxHp - currentHp;
		replenishHp = replenishHp > maxReplenishHp ? maxReplenishHp : replenishHp;
		this.attributeInfo.updateAttribute(AttributeType.HP, replenishHp);
		return replenishHp;
	}

	/**
	 * 修改血量上限，如果将死亡的目标血量修改到大于0则复活目标
	 * @param updateHpPercent
	 */
	public void updateMaxHp(long updateHpPercent){
		this.attributeInfo.updateMaxHp(updateHpPercent);
		if(isDead()){
			long hp = getHp();
			if(hp > 0){
				this.status = HeroStatus.SURVIVE;
			}
		}
	}

	/**
	 * 是否能攻击
	 * @param skillDo
	 * @return
	 */
	public boolean canAttack(SkillDo skillDo){
		if(isDead()){
			return false;
		}

        if (skillDo.getSkillEnergy() == 9999) {
            return true;
        }

		Set<BuffType> buffTypes = skillDo.getSkill().getActive_type().prohibitBuffs();
		return skillDo.getSkill().isFirst() || !this.buffInfo.haveBuff(buffTypes);
	}

	/**
	 * 是否死亡
	 * @return
	 */
	public boolean isDead(){
		return this.status == HeroStatus.DEAD;
	}

	/**
	 * 是否只能普攻
	 * @return
	 */
	public boolean isOnlyAttack(){
		return BuffType.ONLY_ATTACK_BUFFS.stream().anyMatch(type-> haveBuff(type));
	}

	/**
	 * 是否是死亡触发中
	 * @return
	 */
	public boolean notDeadTrigger(){
		return isDead() && !this.deathTrigger;
	}

	/**
	 * 是否拥有指定的buff
	 * @param buffType
	 * @return
	 */
	public boolean haveBuff(BuffType buffType){
		return this.buffInfo.haveBuff(buffType);
	}

	/**
	 * 是否拥有指定的buff列表中的buff
	 * @param buffTypes
	 * @return
	 */
	public boolean haveBuff(Set<BuffType> buffTypes){
		return buffTypes.stream().anyMatch(type -> this.buffInfo.haveBuff(type));
	}

	/**
	 * 是否封印
	 * @return
	 */
	public boolean isSeal(){
		return this.hangUpSeal || haveBuff(BuffType.BT_SEAL);
	}

	/**
	 * 是否是援助英雄
	 * @return
	 */
	public boolean isHelper(){
		return this.position == 9;
	}

	/**
	 * 添加反击目标
	 * @param counterattackTarget
	 * @param skillDo	反击使用的技能
	 */
	public void addCounterattackTarget(HeroDo counterattackTarget, SkillDo skillDo){
		this.actionInfo.addAction(counterattackTarget, skillDo, 0);
	}

	/**
	 * 添加连击目标
	 * @param skillDo	连击使用的技能
	 * @param effectPercent
	 */
	public void addContinuousTarget(SkillDo skillDo, long effectPercent){
		this.actionInfo.addAction(null, skillDo, effectPercent);
	}

	/**
	 * 目标有可能被修改
	 * @param targets
	 * @param context
	 * @return
	 */
	public Set<HeroDo> getSkillTargets(Set<HeroDo> targets, BattleContext context){
		if(this.skillInfo.isTargetUpdate()){
			return this.skillInfo.getSkillGoal().stream().map(context::getHero).collect(Collectors.toCollection(LinkedHashSet::new));
		}
		return new LinkedHashSet<>(targets);
	}

	/**
	 * 修改技能目标，只针对目标选择器无法选择出技能目标的技能才能修改
	 * @param targets
	 */
	public void updateSkillTargets(Collection<HeroDo> targets){
		this.skillInfo.cleanSkillGold();
		this.skillInfo.setTargetUpdate(true);
		targets.forEach(heroDo -> this.skillInfo.getSkillGoal().add(heroDo.getUnitId()));
	}

	/**
	 * 修改最后治疗量
	 * @param updateValue
	 */
	public void updateLastTreatmentValue(long updateValue){
		this.lastTreatmentValue += updateValue;
	}

	/**
	 * 根据来源id获取光环buff
	 * @param sourceId
	 * @return
	 */
	public List<BuffDo> getHaloBy(int sourceId){
		return this.buffInfo.getBuffs().stream().filter(buffDo -> buffDo.getSourceId() == sourceId).collect(Collectors.toList());
	}

	/**
	 * 添加buff
	 * @param buffDo
	 * @return
	 */
	public List<BuffDo> addBuffAndRtnRemoveBuffs(BuffDo buffDo){
		return this.buffInfo.addBuffAndRtnRemoveBuffs(buffDo);
	}

	/**
	 * 移除buff并让buff过期
	 * @param buffDo
	 */
	public void removeBuff(BuffDo buffDo){
		this.buffInfo.removeBuff(buffDo);
	}

	/**
	 * 增加伤害日志
	 * @param damage
	 */
	public void addDamageLog(long damage) {
		this.fightLog.addDamage(damage);
	}

	/**
	 * 增加承受伤害日志
	 *
	 * @param takeDamage
	 */
	public void addTakeDamageLog(long takeDamage){
		this.fightLog.addTakeDamage(takeDamage);
	}

	/**
	 * 增加回复量
	 * @param value
	 */
	public void addRecoveryLog(long value){
		this.fightLog.addRecovery(value);
	}

	/**
	 * 触发buff，并返回触发结果
	 * @param buffId
	 * @param maxTriggerTimes
	 * @return
	 */
	public boolean triggerBuff(int buffId, int maxTriggerTimes){
		return this.buffInfo.triggerBuff(buffId, maxTriggerTimes);
	}

	/**
	 * 获取上下文内容
	 * @param contextType
	 * @return
	 */
	public Long getContext(ContextType contextType){
		return this.contextContent.getOrDefault(contextType, 0L);
	}

	/**
	 * 设置上下文内容
	 * @param contextType
	 * @param value
	 */
	public void setContext(ContextType contextType, long value){
		this.contextContent.put(contextType, value);
	}

	/**
	 * 初始化属性
	 */
	public void initAttribute(){
		this.fightLog = HeroFightLog.instance();
		this.interrupts = Lists.newArrayList();
		this.eventDo = FightEventDo.instance();
		this.attributeInfo.initAttribute();
		this.buffInfo = this.buffInfo == null ? BuffsInfo.getInstance() : this.buffInfo;
		if(getHp() <= 0){
			this.status = HeroStatus.DEAD;
		}
	}


	/**
	 * 转换英雄协议对象
	 * @return
	 */
	public HeroUnit toHeroUnit(){
		HeroUnit.Builder builder = HeroUnit.newBuilder();
		builder.setHeroId(this.heroId).setLevel(this.level).setElement(this.elementMul.getIdx()).setId(this.id);
		builder.setUnitId(this.unitId).setPosition(this.position).setStar(this.star).setFashionId(this.fashionId);
		builder.setMaxHp(this.attributeInfo.getMaxHp()).setHp(this.attributeInfo.getAttribute(AttributeType.HP));
		builder.setMaxEnergy(this.attributeInfo.getMaxEnergy());

		HeroGMsg.PSHeroEvolve.Builder evolveBuilder= HeroGMsg.PSHeroEvolve.newBuilder();
		evolveBuilder.setType(getEvolve().getType()).setLevel(getEvolve().getLevel());
		builder.setEvolve(evolveBuilder);
		return builder.build();
	}

	/**
	 * 构造英雄日志
	 *
	 * @return
	 */
	public BattleGMsg.HeroLog buildHeroLog() {
		BattleGMsg.HeroLog.Builder builder = BattleGMsg.HeroLog.newBuilder();
		builder.setHeroId(this.id).setHeroType(this.heroId).setLevel(this.level).setStar(this.star).setPosition(this.position).setFashionId(this.fashionId);
		builder.setTotalDamage(this.fightLog.getTotalDamage()).setTotalTakeDamage(this.fightLog.getTotalTakeDamage()).setTotalRecovery(this.fightLog.getTotalRecovery());
		builder.setHp(this.attributeInfo.getAttribute(AttributeType.HP)).setMaxHp(this.attributeInfo.getMaxHp());
		HeroGMsg.PSHeroEvolve.Builder evolveBuilder = HeroGMsg.PSHeroEvolve.newBuilder();
		evolveBuilder.setType(getEvolve().getType()).setLevel(getEvolve().getLevel());
		builder.setEvolve(evolveBuilder);
		return builder.build();
	}

	@Override
	public int compareTo(HeroDo o) {
		return Long.compare( o.getSpeed(), getSpeed());
	}

	@Override
	public String toString() {
		return "HeroDo [" + name + ", " + faction + "]";
	}

}
