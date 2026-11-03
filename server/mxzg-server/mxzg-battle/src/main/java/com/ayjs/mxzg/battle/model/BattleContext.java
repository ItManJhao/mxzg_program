package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.protocol.BattleGMsg.AttackInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleLog;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.CombatRound;
import com.ayjs.mxzg.protocol.BattleGMsg.EffectInfo;
import lombok.Getter;
import lombok.Setter;
import org.apache.commons.collections4.MapUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * 战场上下文
 * @author meiyc
 *
 */
@Getter
@Setter
public class BattleContext {

	/** 战场id */
	private String battleId;
	
	/** 战斗类型 */
	private BattleType battleType;
	
	/** 攻方 */
	private BattlerDo attacker;
	
	/** 守方 */
	private BattlerDo defender;
	
	/** 胜利方的单位id */
	private long winId;		
	
	/** 战斗开始时间 */
	private long startTime;	
	
	/** 战场是否结束 */
	private boolean isOver;
	
	/** 最大回合数 */
	private int maxRoundNum;

	/** 战斗时长*/
	private int battleDuration;
	
	/** 战斗回合信息 */
	private List<CombatRound> rounds = new ArrayList<>();	
	
	/** 攻击队列 */
	private List<HeroDo> attackHeros = new ArrayList<>();

	/** 反击队列 */
	private List<HeroDo> counterattackHeroes = new ArrayList<>();
	
	/** 回合队列 */
	private List<HeroDo> roundHeros = new ArrayList<>();
	
	/** 英雄列表 */
	private Map<Integer, HeroDo> allHeros = new HashMap<>();
	
	/** 当前回合造成的额外buff更新列表 */
	private List<BuffInfo> updateBuffInfos = new ArrayList<>();
	
	/** 回合反击信息列表 */
	private List<AttackInfo> counterattacks = new ArrayList<>();
	
	/** 回合效果信息 */
	private List<EffectInfo> roundEffects = new ArrayList<>();

	/** 回合加成 */
	private Map<Integer, Map<AttributeType, Long>> roundAddition = new HashMap<>();
	
	/** 当前的回合数 */
	private AtomicInteger round = new AtomicInteger(1);
	
	/** 单位id生成器 */
	private AtomicInteger unitIdBuilder = new AtomicInteger(1000);
	
	/** 战报构造器 */
	private BattleReport.Builder reportBuilder = BattleReport.newBuilder();
	
	/** 战报 */
	private BattleReport report;

	/** 战场条件列表 */
	private List<BattleCondition> conditions;

	
	public static BattleContext createOf(String battleId, BattleType battleType, BattlerDo attacker, BattlerDo defender, int maxRoundNum, List<BattleCondition> conditions){
		BattleContext context = new BattleContext();
		context.setBattleId(battleId);
		context.setBattleType(battleType);
		context.setAttacker(attacker);
		context.setDefender(defender);
		context.setMaxRoundNum(maxRoundNum);
		context.setConditions(conditions);
		return context;
	}
	
	/**
	 * 战场初始化
	 */
	public void initialize(){
		this.startTime = TimeDateUtil.getCurrentTime();
		initBattler(this.attacker);
		initBattler(this.defender);
		checkOver();
	}

	/**
	 * 初始化对战对象
	 * @param battler
	 */
	private void initBattler(BattlerDo battler){
		battler.initialize(this.unitIdBuilder);
		battler.getAllHeros().forEach(hero-> this.allHeros.put(hero.getUnitId(), hero));
		if(battler.getGoddess() != null){
			this.allHeros.put(battler.getGoddess().getUnitId(), battler.getGoddess().getCamouflage());
		}
		if(battler.getDragonInfo() != null){
			this.allHeros.put(battler.getDragonInfo().getUnitId(), battler.getDragonInfo().getCamouflage());
		}
	}
	
	/**
	 * 获取所有存活的英雄
	 * @return
	 */
	public List<HeroDo> getAllSurviveHeros(){
		return this.allHeros.values().stream().filter(hero-> !hero.isDead()).collect(Collectors.toList());
	}

	/**
	 * 获取所有死亡的英雄
	 * @return
	 */
	public List<HeroDo> getAllDeathHeroes(){
		return this.allHeros.values().stream().filter(hero-> hero.isDead()).collect(Collectors.toList());
	}

	/**
	 * 获取所有援助英雄
	 * @return
	 */
	public List<HeroDo> getAllHelpers(){
		List<HeroDo> heroDos = new ArrayList<>();
		if(this.attacker.getHelper() != null && !this.attacker.getHelper().isDead()){
			heroDos.add(this.attacker.getHelper());
		}
		if(this.defender.getHelper() != null && !this.defender.getHelper().isDead()){
			heroDos.add(this.defender.getHelper());
		}
		return heroDos;
	}
	
	/**
	 * 获取下一个unitId
	 * @return
	 */
	public int nextUnitId(){
		return this.unitIdBuilder.getAndIncrement();
	}
	
	/**
	 * 获取当前的回合数
	 * @return
	 */
	public int currentRound(){
		return this.round.get();
	}
	
	/**
	 * 增加回合数据
	 * @param round
	 */
	public void addRound(CombatRound round){
		this.rounds.add(round);
		this.round.incrementAndGet();
	}

	/**
	 * 增加回合属性
	 * @param round
	 */
	public void addRoundAddition(int round){
		Map<AttributeType, Long> attributeMap = this.roundAddition.get(round);
		if(MapUtils.isNotEmpty(attributeMap)){
			for (HeroDo surviveHero : getAllSurviveHeros()) {
				surviveHero.getAttributeInfo().updateAttributes(attributeMap);
			}
		}
	}

	/**
	 * 添加战斗持续时长 .
	 *
	 * @param time
	 */
	public void addBattleDuration(int time){
		this.battleDuration += time;
	}

	/**
	 * 清空反击信息
	 */
	public void cleanCounterattackAttack(){
		this.counterattacks.clear();
	}

	/**
	 * 添加效果信息列表
	 * @param effectInfos
	 */
	public void addAllEffectInfo(List<EffectInfo> effectInfos){
		this.roundEffects.addAll(effectInfos);
	}

	/**
	 * 根据buff添加一个效果
	 * @param buffInfo
	 */
	public void addEffectInfoBy(BuffInfo buffInfo){
		this.roundEffects.add(EffectInfo.newBuilder().setBuffId(buffInfo.getBuffId()).addBuffInfo(buffInfo).build());
	}

	/**
	 * 获取回合buff列表
	 * @return
	 */
	public List<BuffInfo> getRoundEffectBuffs(){
		return this.roundEffects.stream().flatMap(effectInfo -> effectInfo.getBuffInfoList().stream()).collect(Collectors.toList());
	}
	
	/**
	 * 清空效果信息
	 */
	public void cleanRoundEffects(){
		this.roundEffects.clear();
	}

	/**
	 * 转换buff效果到回合buff
	 */
	public void transferEffectToBuff(){
		this.updateBuffInfos.addAll(getRoundEffectBuffs());
		cleanRoundEffects();
	}

	/**
	 * 添加修改的buff
	 * @param buffInfo
	 */
	public void addUpdateBuff(BuffInfo buffInfo){
		this.updateBuffInfos.add(buffInfo);
	}

	/**
	 * 清空当前回合产生的buff记录
	 */
	public void cleanUpdateBuffs(){
		this.updateBuffInfos.clear();
	}
	
	/**
	 * 战场是否结束
	 * @return
	 */
	public boolean notOver(){
		return !isOver && round.get() <= this.maxRoundNum;
	}

	/**
	 * 释放技能后看战场是否结束
	 * @return
	 */
	public boolean checkOver(){
		if(this.attacker.isDead()){
			this.winId = this.defender.getPlayerId();
			this.isOver = true;
		} else if(this.defender.isDead()){
			this.winId = this.attacker.getPlayerId();
			this.isOver = true;
		}		
		return this.isOver;
	}

	/**
	 * 攻方失败
	 */
	public void attackerFailure(){
		this.winId = this.defender.getPlayerId();
		this.isOver = true;
	}

	/**
	 * 排序出手英雄并返回先手玩家
	 * @return
	 */
	public void orderAttack(){
		this.attackHeros = Stream.of(attacker.getHeros(), defender.getHeros()).flatMap(Collection::stream).sorted().collect(Collectors.toList());
	}

	/**
	 * 特殊情况排序，例如无双假面必定先手
	 */
	public void specialOrder(int round){
		List<HeroDo> firstHeroes = Stream.of(defender.getFirsts(round), attacker.getFirsts(round)).flatMap(Collection::stream).sorted().collect(Collectors.toList());
		this.attackHeros.removeAll(firstHeroes);
		firstHeroes.forEach(heroDo -> this.attackHeros.add(0, heroDo));
	}
	
	/**
	 * 获取先手
	 * @return
	 */
	public BattlerDo getFirst(){
		return getSelf(this.attackHeros.get(0).getFaction());
	}
	
	/**
	 * 获取下一个出手的英雄
	 * @return
	 */
	public HeroDo pollAttack(){
		if(!this.counterattackHeroes.isEmpty()){
			return this.counterattackHeroes.remove(0);
		}
		return this.attackHeros.remove(0);
	}
	
	/**
	 * 添加一次反击，插在队尾
	 * @param counterattackHero
	 */
	public void addCounterattack(HeroDo counterattackHero){
		this.counterattackHeroes.add(counterattackHero);
	}

	/**
	 * 添加连击，插在队首
	 * @param counterattackHero
	 */
	public void addContinuousAttack(HeroDo counterattackHero){
		this.counterattackHeroes.add(0,counterattackHero);
	}
	
	/**
	 * 是否还有下一个攻击者
	 * @return
	 */
	public boolean nextAttack(){
		return this.notOver() && (!this.attackHeros.isEmpty() || !this.counterattackHeroes.isEmpty());
	}

	/**
	 * 英雄受伤
	 * @param defender
	 * @param attacker
	 * @param result
	 * @param shieldValue
	 */
	public void heroHurt(HeroDo defender, HeroDo attacker, DamageResult result, long shieldValue){
        long damage = defender.hurt(result.getDamage() - shieldValue);
		attacker.addDamageResult(result);
        attacker.addDamageLog(damage + shieldValue);
		if(defender.isDead()){
			heroDeath(defender);
			checkOver();
		}
	}
	
	/**
	 * 英雄死亡
	 * @param deathHero
	 */
	private void heroDeath(HeroDo deathHero){
		BattlerDo battlerDo = getSelf(deathHero.getFaction());
		battlerDo.heroDeath(deathHero);
	}
	
	/**
	 * 复活
	 * @param resurrectionHero
	 */
	public void heroResurrection(HeroDo resurrectionHero){
		BattlerDo battlerDo = getSelf(resurrectionHero.getFaction());
		battlerDo.resurrection(resurrectionHero);
		if(this.isOver){
			this.isOver = false;
			checkOver();
		}
	}
	
	/**
	 * 恢复血量
	 * @param defender
	 * @param attacker
     * @param replenishHp
	 */
	public long replenish(HeroDo defender, HeroDo attacker, long replenishHp){
		long  treatmentValue = attacker.getAttribute(AttributeType.TREATMENT);
		replenishHp += treatmentValue;
		long treatmentPercent = attacker.getAttribute(AttributeType.TREATMENT_PERCENT);
		replenishHp += AttributeUtil.addPercent(replenishHp, treatmentPercent);
		long betreatmentPercent = defender.getAttribute(AttributeType.BEING_TREATMENT_PERCENT);
		replenishHp += AttributeUtil.addPercent(replenishHp, betreatmentPercent);
		
		defender.replenish(replenishHp);
		attacker.addRecoveryLog(replenishHp);
		return replenishHp;
	}
	
	/**
	 * 根据单位id获取英雄
	 * @param unitId
	 * @return
	 */
	public HeroDo getHero(int unitId){
		return this.allHeros.get(unitId);
	}
	
	/**
	 * 获取英雄角色 
	 * @param faction
	 * @return
	 */
	public BattlerDo getSelf(Faction faction){
		return faction == Faction.ATTACKER ? this.attacker : this.defender;
	}
	
	/**
	 * 获取目标英雄的敌人
     * @param faction
	 * @return
	 */
	public BattlerDo getEnemy(Faction faction){
		return faction == Faction.ATTACKER ? this.defender : this.attacker;
	}

	
	/**
	 * 初始化战报
	 */
	public void initReport(){
		this.reportBuilder.setBattleId(this.battleId).setBattleType(this.getBattleType().getValue()).setStartTime(this.startTime);
		this.reportBuilder.setAttacker(this.attacker.toBattleUnit()).setDefender(this.defender.toBattleUnit());
	}

	/**
	 * 生成战报
	 * @return
	 */
	public void buildReport(){
		this.winId = this.winId == 0 ? this.defender.getPlayerId() : this.winId;
        this.report = this.reportBuilder.addAllRounds(this.rounds).setWinId(this.winId).setLog(buildBattleLog()).build();
    }

    /**
     * 构建战场日志
     *
     * @return
     */
    public BattleLog buildBattleLog() {
		BattleLog.Builder builder = BattleLog.newBuilder().setBattleId(this.battleId).setWinId(this.winId);
        builder.setAttackerLog(this.attacker.buildHeroLog()).setDefenderLog(this.defender.buildHeroLog());
        return builder.setBattleDuration(this.battleDuration).build();
	}
}
