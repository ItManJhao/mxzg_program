package com.ayjs.mxzg.battle.service;

import cn.hutool.core.util.RandomUtil;
import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.buff.BattleTrigger;
import com.ayjs.mxzg.battle.buff.BuffHandler;
import com.ayjs.mxzg.battle.buff.BuffHandlerHolder;
import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.condition.ConditionChecker;
import com.ayjs.mxzg.battle.condition.ConditionHolder;
import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.targetselector.AbstractTargetSelector;
import com.ayjs.mxzg.battle.targetselector.TargetSelectorHolder;
import com.ayjs.mxzg.common.util.EnumUtils;
import com.ayjs.mxzg.config.excel.cache.BuffArtSysCache;
import com.ayjs.mxzg.config.excel.cache.BuffSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CBuffArt;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.ActiveType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.SelectorType;
import com.ayjs.mxzg.protocol.BattleGMsg.*;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Component
public class BattleService {


	@Autowired
	private BattleTrigger battleTrigger;
	@Autowired
	private BuffSysCache buffSysCache;
	@Autowired
	private BuffArtSysCache buffArtCache;
	@Autowired
	private HeroSkillSysCache heroSkillSysCache;
	@Autowired
	private HeroTypeSysCache heroTypeSysCache;
	@Autowired
	private BuffHelper buffHelper;
	@Autowired
	private BattleTimeHelper battleTimeHelper;
	@Autowired
	private BuffHandlerHolder buffHandlerHolder;
	@Autowired
	private TargetSelectorHolder selectorHolder;
	@Autowired
	private ConditionHolder conditionHolder;

	private static boolean debugBattle = false;

	/**
	 * 开始对战
	 * @param context
	 */
	public void battle(BattleContext context){
		initBattle(context);
		while(context.notOver()){
			CombatRound.Builder round = CombatRound.newBuilder().setRound(context.getRound().get());
			executeRound(round, context);
			context.addRound(round.build());
		}

		context.buildReport();

	}

	/**
	 * 初始化战场，添加被动技能
	 * @param context
	 */
	private void initBattle(BattleContext context){
		context.initialize();
		for(HeroDo hero : context.getAllHeros().values()){
			if(hero.isHangUpSeal()){continue;}

			if(hero.isHelper()){
				addHelperBuff(hero, context);
			} else {
				initPassiveSkills(hero, context);
			}
		}

		context.initReport();
	}

	/**
	 * 初始化被动技能
	 * @param hero
	 * @param context
	 */
	public void initPassiveSkills(HeroDo hero, BattleContext context){
		for(SkillDo skill : hero.getSkillInfo().getPassiveSkills()){
			hero.setCurrentSkill(skill);
			List<EffectInfo> effectInfos = executeSkill(skill, hero, context);
			List<BuffInfo> iconBuffs = filterIconBuff(effectInfos);
			iconBuffs.forEach(context::addUpdateBuff);
		}
	}

	/**
	 * 添加援助buff
	 * @param hero
	 * @param context
	 */
	private void addHelperBuff(HeroDo hero, BattleContext context){
		CBuff buff = buffSysCache.getOrThrow(BattleConstant.HELPER_BUFF_ID);
		BuffDo buffDo = BuffDo.createOf(context.nextUnitId(), 0, hero.getUnitId(), BattleConstant.PASSIVE_ROUND_NUMBER, buff, false);
		hero.addBuffAndRtnRemoveBuffs(buffDo);
	}

	/**
	 * 筛选带icon的buff
	 * @param effectInfos
	 * @return
	 */
	private List<BuffInfo> filterIconBuff(List<EffectInfo> effectInfos){
		return effectInfos.stream().flatMap(effectInfo -> effectInfo.getBuffInfoList().stream())
				.filter(buff-> buffSysCache.getOrThrow(buff.getBuffId()).isIconBuff()).collect(Collectors.toList());
	}

	/**
	 * 执行一回合
	 * @param round
	 * @param context
	 */
	private void executeRound(CombatRound.Builder round, BattleContext context){
		executeHelperBuff(round, context);
		round.addAllBuffInfo(context.getUpdateBuffInfos());
		context.cleanUpdateBuffs();
		context.addRoundAddition(round.getRound());
		executeRoundBuff(round, context, BuffType.BT_ROUND_START);
		executeRoundBuff(round, context, BuffType.BT_FIXED_ROUND);
		executeRoundBuff(round, context, BuffType.BT_ACCORDING_TREATMENT);
		executeDeadRound(round, context);
		roundRemoveBuff(round, context);
		executeGoddessAttack(round, context);
		executeDragonAttack(round, context);
		executeRoundAttack(round, context);
		executeRoundBuff(round, context, BuffType.BT_ROUND_END);
	}

	/**
	 * 执行援助类buff
	 * @param round
	 * @param context
	 */
	private void executeHelperBuff(CombatRound.Builder round, BattleContext context){
		List<HeroDo> heroDos = context.getAllHelpers();
		for(HeroDo heroDo : heroDos){
			CBuff buff = buffSysCache.getOrThrow(BattleConstant.HELPER_BUFF_ID);
			List<BuffInfo> buffDos = executeBuff(Sets.newHashSet(heroDo), buff, heroDo, context);
			round.addAllBuffInfo(buffDos);
		}
	}

	/**
	 * 执行女神攻击回合
	 * @param round
	 * @param context
	 */
	private void executeGoddessAttack(CombatRound.Builder round, BattleContext context){
		context.orderAttack();
		BattlerDo first = context.getFirst();
		Goddess firstGoddess = first.getGoddess();
		if(firstGoddess != null){
			GoddessAttack firstAttack = goddessAttack(firstGoddess, context);
			round.addGoddessAttack(firstAttack);
		}

		if(context.notOver()){
			BattlerDo second = context.getEnemy(first.getFaction());
			Goddess secondGoddess = second.getGoddess();
			if(secondGoddess != null){
				GoddessAttack secondAttack = goddessAttack(secondGoddess, context);
				round.addGoddessAttack(secondAttack);
			}
		}
	}

	/**
	 * 执行神龙攻击回合
	 * @param round
	 * @param context
	 */
	private void executeDragonAttack(CombatRound.Builder round, BattleContext context){
		context.orderAttack();
		BattlerDo first = context.getFirst();
		DragonInfo dragonInfo = first.getDragonInfo();
		if(dragonInfo != null){
			DragonAttack dragonAttack = dragonAttack(dragonInfo, context);
			round.addDragonAttack(dragonAttack);
		}

		if(context.notOver()){
			BattlerDo second = context.getEnemy(first.getFaction());
			DragonInfo secondDragon = second.getDragonInfo();
			if(secondDragon != null){
				DragonAttack dragonAttack = dragonAttack(secondDragon, context);
				round.addDragonAttack(dragonAttack);
			}
		}
	}

	/**
	 * 女神出手
	 * @param goddess
	 * @param context
	 * @return
	 */
	private GoddessAttack goddessAttack(Goddess goddess, BattleContext context){
		GoddessAttack.Builder builder = GoddessAttack.newBuilder().setUnitId(goddess.getUnitId());
		goddess.restoreEnergy();
		if(goddess.energyIsFull()){
			List<EffectInfo> effectInfos = executeSkill(goddess.getSkill(), goddess.getCamouflage(), context);
			AttackInfo.Builder attackInfo = AttackInfo.newBuilder();
			attackInfo.setSkill(Skill.newBuilder().addAllEffectInfo(effectInfos)).setUnitId(goddess.getUnitId());
			builder.setAttackInfo(attackInfo.build());
			builder.setEnergy(-goddess.getEnergy());
			goddess.cleanEnergy();
			context.addBattleDuration(BattleConstant.GODDESS_SKILL_ACTION_TIME);
		} else {
			builder.setEnergy(BattleConstant.GODDESS_ROUND_RESTORE_ENERGY);
			context.addBattleDuration(BattleConstant.GODDESS_FREE_ACTION_TIME);
		}
		return builder.build();
	}

	/**
	 * 神龙出手
	 * @param dragonInfo
	 * @param context
	 * @return
	 */
	private DragonAttack dragonAttack(DragonInfo dragonInfo, BattleContext context){
		DragonAttack.Builder builder = DragonAttack.newBuilder().setUnitId(dragonInfo.getUnitId());
		SkillDo skillDo = dragonInfo.getSkill(context.currentRound());
		if(skillDo != null){
			List<EffectInfo> effectInfos = executeSkill(skillDo, dragonInfo.getCamouflage(), context);
			AttackInfo.Builder attackInfo = AttackInfo.newBuilder().setSkillType(ActiveType.SKILL.ordinal());
			attackInfo.setSkill(Skill.newBuilder().setSkillId(skillDo.getSkillId()).addAllEffectInfo(effectInfos)).setUnitId(dragonInfo.getUnitId());
			builder.setAttackInfo(attackInfo.build());
			builder.setNextAttackRound(skillDo.nextRound(context.currentRound()));
			context.addBattleDuration(BattleConstant.DRAGON_SKILL_ACTION_TIME);
		}
		return builder.build();
	}


	/**
	 * 执行回合buff效果
	 * @param round
	 * @param context
	 */
	private void executeDeadRound(CombatRound.Builder round, BattleContext context){
		List<HeroDo> heroDos = context.getAllDeathHeroes();
		Collections.sort(heroDos);
		for(HeroDo heroDo : heroDos){
			for (BuffDo buff : heroDo.getDeadBuffs()) {
				executeBuffRound(round, BuffType.BT_ROUND_START, buff, heroDo, context);
			}
		}
	}

	/**
	 * 执行回合buff效果
	 * @param round
	 * @param context
	 * @param buffType
	 */
	private void executeRoundBuff(CombatRound.Builder round, BattleContext context, BuffType buffType){
		context.orderAttack();
		while(context.nextAttack()){
			HeroDo heroDo = context.pollAttack();
			if(heroDo.isHangUpSeal()){continue;	}
			for (BuffDo buff : heroDo.getRoundBuffs(buffType, round.getRound())) {
				if(heroDo.isDead()) break;
				if (CollectionUtils.isEmpty(buff.getBuff().getArt_list())) {
					executeBuffRound(round, buffType, buff, heroDo, context);
				} else {
					executeRoundArt(round, buffType, buff, heroDo, context);
				}
				checkExpiredBuff(heroDo, buff, round, context);
			}
		}

		int roundBuffTime = battleTimeHelper.calRoundBuffTime(round, buffType);
		context.addBattleDuration(roundBuffTime);
	}

	/**
	 * 回合移除所有过期buff
	 *
	 * @param round
	 * @param context
	 */
	private void roundRemoveBuff(CombatRound.Builder round, BattleContext context) {
		context.orderAttack();
		while (context.nextAttack()) {
			HeroDo heroDo = context.pollAttack();
			for (BuffDo buff : heroDo.getAllBuffs()) {
				checkExpiredBuff(heroDo, buff, round, context);
			}
		}
	}

	/**
	 * 检测buff是否过期
	 *
	 * @param heroDo
	 * @param buffDo
	 * @param round
	 * @param context
	 */
	private void checkExpiredBuff(HeroDo heroDo, BuffDo buffDo, CombatRound.Builder round, BattleContext context) {
		if (buffDo.isExpired(context.currentRound())) {
			buffHelper.removeBuff(buffDo, heroDo, context);
			round.addAllBuffInfo(context.getUpdateBuffInfos());
			context.cleanUpdateBuffs();
			HeroDo beTrigger = context.getHero(buffDo.getSourceId());
			battleTrigger.trigger(BuffType.BT_BUFF_EXPIRED, beTrigger, heroDo, context);
		}
	}

	/**
	 * 执行回合art
	 * @param round
	 * @param buffType
	 * @param buff
	 * @param target
	 * @param context
	 */
	private void executeRoundArt(CombatRound.Builder round, BuffType buffType, BuffDo buff, HeroDo target, BattleContext context){
		HeroDo sourceHero = context.getHero(buff.getSourceId());
		if(sourceHero == null){
			return;
		}
		for (int artId : buff.getBuff().getArt_list()) {
			LinkedHashSet<HeroDo> targetSet = Sets.newLinkedHashSet();
			targetSet.add(target);
			List<EffectInfo> effectInfos= executeBuffArt(artId, targetSet, sourceHero, context);
			for(EffectInfo effectInfo : effectInfos ){
				if (buffType == BuffType.BT_ROUND_END) {
					round.addAllAfterRoundBuffs(effectInfo.getBuffInfoList());
				} else {
					round.addAllBuffInfo(effectInfo.getBuffInfoList());
				}
			}
		}
	}

	/**
	 * 执行buff一回合
	 * @param round
	 * @param buffType
	 * @param buffDo
	 * @param target
	 * @param context
	 */
	private void executeBuffRound(CombatRound.Builder round, BuffType buffType, BuffDo buffDo, HeroDo target, BattleContext context){
		BuffInfo.Builder builder = BuffInfo.newBuilder();
		BuffHandler buffHandler = buffHandlerHolder.getBuffHandler(buffDo.getType());
		buffHandler.executeRound(buffDo, target, context, builder);

		if(builder.isInitialized()){
			List<BuffInfo> buffInfos = new ArrayList<>();
			buffInfos.add(builder.build());
			buffInfos.addAll(context.getUpdateBuffInfos());
			buffInfos.addAll(context.getRoundEffectBuffs());
			if (buffType == BuffType.BT_ROUND_END) {
				round.addAllAfterRoundBuffs(buffInfos);
			} else {
				round.addAllBuffInfo(buffInfos);
			}
		}
		context.cleanUpdateBuffs();
		context.cleanRoundEffects();
	}

	/**
	 * 执行回合攻击
	 * @param round
	 * @param context
	 */
	private void executeRoundAttack(CombatRound.Builder round, BattleContext context){
		context.orderAttack();
		context.specialOrder(round.getRound());
		while(context.nextAttack()){
			HeroDo heroDo = context.pollAttack();
			int type = context.getSelf(heroDo.getFaction()).getTestType();
			SkillDo skillDo = heroDo.getTestSkill(type, round.getRound());
			if(debugBattle) {
				CHeroType cHeroType = heroTypeSysCache.getOrThrow(heroDo.getHeroId());
				log.info("第{}回合，{}-{}将要使用技能{}", context.getRound().get(), heroDo.getFaction(), cHeroType.getNote(), skillDo.getSkill().getNote1());
			}

			battleTrigger.trigger(BuffType.BT_BEFORE_ACTION, heroDo, heroDo, context);

			if(heroDo.canAttack(skillDo)){
				heroDo.openCounterattack();
				Skill skill = useSkill(skillDo, heroDo, context);
				AttackInfo attackInfo = AttackInfo.newBuilder().setSkill(skill).setUnitId(heroDo.getUnitId()).setSkillType(skillDo.getSkillType()).build();
				round.addAttackInfo(attackInfo);
				round.addAllAttackInfo(context.getCounterattacks());
				context.addBattleDuration(BattleConstant.SKILL_ACTION_TIME);
				if(context.isOver() || checkCondition(context)){
					break;
				}
			}
			heroDo.cleanAttack();
			context.cleanCounterattackAttack();

			context.setAttackHeros(context.getAttackHeros().stream().sorted().collect(Collectors.toList()));
		}
	}

	/**
	 * 检测失败条件
	 * @return
	 */
	private boolean checkCondition(BattleContext context){
		for (BattleCondition condition : context.getConditions()) {
			ConditionChecker checker = conditionHolder.get(condition.getConditionType());
			if(!checker.checker(context, condition)){
				context.attackerFailure();
				return true;
			}
		}
		return false;
	}

	/**
	 * 使用技能
	 * @param skillDo
	 * @param attacker
	 * @param context
	 * @return
	 */
	public Skill useSkill(SkillDo skillDo, HeroDo attacker, BattleContext context){
		Skill.Builder skillBuilder = Skill.newBuilder().setSkillId(skillDo.getSkillId());
		List<EffectInfo> effectInfos = executeSkill(skillDo, attacker, context);
		skillBuilder.addAllEffectInfo(effectInfos);
		return skillBuilder.build();
	}

	/**
	 * 执行技能并返回技能效果列表
	 * @param skillDo
	 * @param attacker
	 * @param context
	 * @return
	 */
	private List<EffectInfo> executeSkill(SkillDo skillDo, HeroDo attacker, BattleContext context){
		attacker.getSkillInfo().cleanSkillGold();
		List<EffectInfo> skillEffectInfos = Lists.newArrayList();
		for(int artId : skillDo.getSkill().getArt_list()){
			List<EffectInfo> effectInfos = executeBuffArt(artId, attacker.getActionInfo().getActionTargets(), attacker, context);
			skillEffectInfos.addAll(effectInfos);
			attacker.restore();
		}

		if(skillDo.isAttackSkill() && !attacker.isCounterattack()){
			ActiveType activeType = skillDo.getSkill().getActive_type();
			battleTrigger.trigger(activeType.getUseTriggerType(), attacker, attacker, context);
			battleTrigger.trigger(BuffType.BT_ATTACK, attacker, attacker, context);
			if(activeType == ActiveType.SKILL && attacker.getDamageType() != null){
				battleTrigger.trigger(attacker.getDamageType().triggerSkillType(), attacker, attacker, context);
			}
			skillEffectInfos.addAll(context.getRoundEffects());
			context.cleanRoundEffects();
		}
		return skillEffectInfos;
	}

	/**
	 * 执行buffArt效果,并添加结果到效果列表
	 * @param artId
	 * @param target
	 * @param attacker
	 * @param context
	 * @return
	 */
	public void executeBuffArt(int artId, HeroDo target, HeroDo attacker, BattleContext context){
		Set<HeroDo> targets = Sets.newLinkedHashSet();
		if (Objects.nonNull(target)){
			targets.add(target);
		}
		List<EffectInfo> effectInfos = executeBuffArt(artId, targets, attacker, context);
		context.addAllEffectInfo(effectInfos);
	}

	/**
	 * 执行buffArt效果
	 * @param artId
	 * @param targets
	 * @param attacker
	 * @param context
	 * @return
	 */
	public List<EffectInfo> executeBuffArt(int artId, Set<HeroDo> targets, HeroDo attacker, BattleContext context){
		List<EffectInfo> effectInfos = new ArrayList<>();
		CBuffArt buffArt = buffArtCache.getOrThrow(artId);
		targets = selectTargets(buffArt, attacker, context, targets);

		for(CBuff buff : buffArt.getBuffs()){
			if(buff.isPassive()) continue;

			Set<HeroDo> buffTargets = attacker.getSkillTargets(targets, context);
			List<BuffInfo> buffInfos = executeBuff(buffTargets, buff, attacker, context);
			if(!buffInfos.isEmpty()){
				effectInfos.add(EffectInfo.newBuilder().setBuffId(buff.getIdx()).addAllBuffInfo(buffInfos).build());
			}

			if((buff.notRoundBuff() && buff.notTrigger() && !buffTargets.isEmpty())){
				for(int aId : buff.getArt_list()){
					context.addAllEffectInfo(executeBuffArt(aId, attacker.getSkillTargets(buffTargets, context), attacker, context));
				}
			}
			attacker.restore();
		}

		effectInfos.addAll(context.getRoundEffects());
		context.cleanRoundEffects();
		return effectInfos;
	}

	/**
	 * 选择目标列表
	 * @param buffArt
	 * @param attacker
	 * @param context
	 * @param targets
	 * @return
	 */
	private Set<HeroDo> selectTargets(CBuffArt buffArt, HeroDo attacker, BattleContext context, Set<HeroDo> targets){
		targets = Optional.ofNullable(targets).orElseGet(LinkedHashSet::new);
		if(attacker.isCounterattack() && attacker.isGeneralAction() && !targets.isEmpty()){
			return targets;
		}

		if(!CollectionUtils.isEmpty(buffArt.getTarget()) && !CollectionUtils.isEmpty(targets)){
			targets = Sets.newLinkedHashSet();
		}

		if(CollectionUtils.isEmpty(buffArt.getTarget()) && CollectionUtils.isEmpty(targets)){
			return Sets.newLinkedHashSet();
		}

		for(int typeValue : buffArt.getTarget()){
			SelectorType type = EnumUtils.getEnumByValue(SelectorType.class, typeValue);
			AbstractTargetSelector selector = selectorHolder.getOrThrow(type);
			int targetNum = buffArt.isLastType(typeValue) ? buffArt.getTarget_num() : BattleConstant.MAX_TARGET_NUM;
			targetNum = targetNum == 0 ? BattleConstant.MAX_TARGET_NUM : targetNum;
			if(attacker.getCurrentSkill() != null && buffArt.isLastType(typeValue)) {
				targetNum += attacker.getSkillInfo().getAndCleanTemporarilyTargetNum();
			}
			selector.selectingTarget(context, attacker, targets, targetNum, buffArt.getTarget_value());
		}
		List<Integer> skillGolds = targets.stream().map(HeroDo::getUnitId).collect(Collectors.toList());
		attacker.getSkillInfo().addSkillGold(skillGolds);
		return targets;
	}


	/**
	 * 执行buff效果
	 * @param targets
	 * @param buff
	 * @param attacker
	 * @param context
	 * @return
	 */
	public List<BuffInfo> executeBuff(Set<HeroDo> targets, CBuff buff, HeroDo attacker, BattleContext context) {
		List<BuffInfo> buffInfos = Lists.newArrayList();
		Set<HeroDo> missHero = Sets.newHashSet();
		for(HeroDo defender : targets){
			if(!buff.isHit() || attacker.isInterrupt(defender.getUnitId()) || defender.notHero() || (!buff.isDeathExecute() && (defender.notDeadTrigger()))){
				missHero.add(defender);
				continue;
			}

			BuffInfo.Builder buffInfo = BuffInfo.newBuilder();
			BuffHandler buffHandler = buffHandlerHolder.getBuffHandler(buff.getType());
			try {
				buffHandler.handle(buff, attacker, defender, context, buffInfo);
				if(buffInfo.isInitialized()){
					buffInfos.add(buffInfo.build());
				} else if(buff.isResistanceBuff() || attacker.isInterrupt(defender.getUnitId())){
					missHero.add(defender);
				}
			} catch (Exception ex){
				ex.printStackTrace();
			}

			buffInfos.addAll(context.getUpdateBuffInfos());
			context.cleanUpdateBuffs();
		}
		targets.removeAll(missHero);
		return buffInfos;
	}

}
