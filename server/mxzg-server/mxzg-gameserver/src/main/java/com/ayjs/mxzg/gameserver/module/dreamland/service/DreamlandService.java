package com.ayjs.mxzg.gameserver.module.dreamland.service;

import com.ayjs.mxzg.battle.command.HeroInitCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.DreamlandBuffSysCache;
import com.ayjs.mxzg.config.excel.cache.DreamlandDailyRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.DreamlandLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.constant.DreamLandConst;
import com.ayjs.mxzg.config.excel.entity.CDreamLandFirstReward;
import com.ayjs.mxzg.config.excel.entity.CDreamlandBuff;
import com.ayjs.mxzg.config.excel.entity.CDreamlandLevel;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.dreamland.constant.DreamlandBattleStatus;
import com.ayjs.mxzg.gameserver.module.dreamland.dao.DreamlandDao;
import com.ayjs.mxzg.gameserver.module.dreamland.domin.Dreamland;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandBattleEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandMaxLvEvent;
import com.ayjs.mxzg.gameserver.module.friend.service.RelationshipService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHerosCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.DreamlandGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Service
@Slf4j
public class DreamlandService implements Lifecycle {

    @Autowired
    private DreamlandDao dreamlandDao;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private RelationshipService relationshipService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private DreamlandBuffSysCache dreamlandBuffSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private DreamlandLevelSysCache dreamlandLevelSysCache;
    @Autowired
    private DreamlandDailyRewardSysCache dreamlandDailyRewardSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private DreamLandConst dreamLandConst;

    private CopyOnWriteArraySet<Long> battleIngRole = new CopyOnWriteArraySet<>();

    private ConcurrentMap<Long, DreamlandGMsg.GResDreamlandBattle> lastBattleData = new ConcurrentHashMap<>();

    private static final String DREAMLAND_ADD_LV_LOCK = "DREAMLAND_ADD_LV_LOCK";

    /***
     * 获取存储对象
     * @param rid
     * @return
     */
    public Dreamland load(long rid) {
        Dreamland dreamland = dreamlandDao.get(rid);
        if (dreamland == null) {
            dreamland = new Dreamland();
            dreamland.setRid(rid);
            dreamland.setRandomBuffIds(randomBuff());
            dreamland.setLastRefreshTime(TimeDateUtil.getCurrentTimeInt());
            //添加初始状态
            changeBattleStatus(dreamland, DreamlandBattleStatus.NORMAL);
            dreamlandDao.add(dreamland);
        }
        return dreamland;
    }

    /**
     * 查询所有
     *
     * @return
     */
    public List<Dreamland> loadAll() {
        return dreamlandDao.listAll();
    }

    /***
     * 获取并刷新
     * @param rid
     * @return
     */
    public Dreamland loadAndRefresh(long rid) {
        Dreamland dreamland = load(rid);
        if (!TimeDateUtil.isToday(dreamland.getLastRefreshTime())) {
            //发送奖励再重置数据
            if (dreamland.getBattleStatus() != DreamlandBattleStatus.NORMAL.getValue())
                this.battleMissionEnd(dreamland);
            //重置关卡数
            dreamland.setCurLv(Math.max(0, dreamland.getMaxLv() - DreamLandConst.RESET_LEVEL));
            dreamland.setTodayMinLv(dreamland.getCurLv());
            dreamland.setTodayRewardLv(dreamland.getCurLv());
            dreamland.setTodayChallengeCount(0);
            dreamland.setTodayMaxLv(dreamland.getCurLv());
            dreamland.setLastRefreshTime(TimeDateUtil.getCurrentTimeInt());
            //重置英雄
            //清除阵容信息
            if (dreamland.getAssistHero().getId() > 0) {
                this.clearDreamLandAssist(rid, dreamland.getAssistHero().getId());
            }
            dreamland.setAssistHero(new HeroVo());//清理掉上阵英雄
            dreamland.getSelectHero().clear();

            changeBattleStatus(dreamland, DreamlandBattleStatus.NORMAL);
            dreamland.setLastBattleResult(0);

            dreamlandDao.update(dreamland);
        }
        return dreamland;
    }

    public void update(Dreamland dreamland) {
        dreamlandDao.update(dreamland);
    }

    public DreamlandGMsg.GResDreamlandData sendData(long rid) {
        DreamlandGMsg.GResDreamlandData.Builder builder = DreamlandGMsg.GResDreamlandData.newBuilder();
        Dreamland dreamland = loadAndRefresh(rid);
        builder.setCurLv(dreamland.getCurLv());
        builder.setMaxLv(dreamland.getMaxLv());
        builder.setTodayChallengeCount(dreamland.getTodayChallengeCount());
        builder.setTodayMaxLv(dreamland.getTodayMaxLv() - dreamland.getTodayMinLv());
        builder.setTodayInitLv(dreamland.getTodayMinLv());
        builder.setRewardLv(dreamland.getRewardLv());
        builder.setCurrBuffId(dreamland.getCurrBuffId());
        builder.addAllNextBuffId(dreamland.getRandomBuffIds());
        return builder.build();
    }

    public List<DreamlandGMsg.PSDreamlandHeroData> buildLineUp(Dreamland dreamland) {
        List<DreamlandGMsg.PSDreamlandHeroData> result = new ArrayList<>();
        dreamland.getBattlerVo().getHeros().forEach(heroVo -> {
            DreamlandGMsg.PSDreamlandHeroData.Builder builder1 = DreamlandGMsg.PSDreamlandHeroData.newBuilder();
            CHeroType heroType = heroTypeSysCache.getOrThrow(heroVo.getHeroId());
            builder1.setElem(heroType.getElem());
            builder1.setLevel(heroVo.getLevel());
            builder1.setPos(heroVo.getPos());
            builder1.setStar(heroVo.getStar());
            builder1.setType(heroVo.getHeroId());
            builder1.setHp(heroVo.getHp());
            builder1.setMaxHp(heroVo.getMaxHp());
            builder1.setFashionId(heroVo.getFashionId());
            result.add(builder1.build());
        });
        return result;
    }

    public DreamlandGMsg.GResFriendAssistHeroList friendAssistList(long rid) {
        List<Long> friendIds = new ArrayList<>(relationshipService.getShipMap(rid).keySet());

        DreamlandGMsg.GResFriendAssistHeroList.Builder builder = DreamlandGMsg.GResFriendAssistHeroList.newBuilder();
        //派出助战英雄
        Dreamland dreamland = loadAndRefresh(rid);
        if (dreamland.getAssistHero().getId() > 0) {
            builder.setHeroData(heroService.serialize(dreamland.getAssistHero()));
        }

        //选择的好友英雄
        dreamland.getSelectHero().forEach((key, value) -> {
            DreamlandGMsg.PSFriendAssistData.Builder friendAssistBuilder = DreamlandGMsg.PSFriendAssistData.newBuilder();
            Role friend = roleService.getOrThrow(key);
            friendAssistBuilder.setFriendId(friend.getId());
            friendAssistBuilder.setFriendNick(friend.getNick());
            friendAssistBuilder.setHero(heroService.serialize(value));
            builder.setFriendHero(friendAssistBuilder);
        });

        //好友助战列表
        for (Long friendId : friendIds) {
            Dreamland friendDreamland = loadAndRefresh(friendId);
            if (friendDreamland.getAssistHero().getId() > 0) {
                Role friend = roleService.getOrThrow(friendId);
                DreamlandGMsg.PSFriendAssistData.Builder friendAssistBuilder = DreamlandGMsg.PSFriendAssistData.newBuilder();
                friendAssistBuilder.setFriendId(friend.getId());
                friendAssistBuilder.setFriendNick(friend.getNick());
                friendAssistBuilder.setHero(heroService.serialize(friendDreamland.getAssistHero()));
                builder.addAssistData(friendAssistBuilder);
            }
        }
        return builder.build();
    }

    public DreamlandGMsg.GResDreamlandSelectFriend selectFriend(Dreamland friendDreamland, Dreamland dreamland) {

        DreamlandGMsg.GResDreamlandSelectFriend.Builder builder = DreamlandGMsg.GResDreamlandSelectFriend.newBuilder();

        //创建英雄Vo,选择助战好友时，生成好友英雄的镜像数据
        //清除阵容信息
        HeroVo assistVo = getMySelectAssist(dreamland.getRid());
        if (assistVo != null)
            this.clearDreamLandAssist(dreamland.getRid(), assistVo.getId());
        dreamland.getSelectHero().clear();//清除好友助阵
        dreamland.getSelectHero().put(friendDreamland.getRid(), friendDreamland.getAssistHero());
        dreamlandDao.update(dreamland);

        builder.setRid(friendDreamland.getRid());
        return builder.build();
    }

    public DreamlandGMsg.GResDreamlandGetLevel dreamlandGetLevel(long rid, CDreamLandFirstReward config) {
        DreamlandGMsg.GResDreamlandGetLevel.Builder builder = DreamlandGMsg.GResDreamlandGetLevel.newBuilder();
        Dreamland dreamland = loadAndRefresh(rid);
        dreamland.setRewardLv(config.getIdx());
        dreamlandDao.update(dreamland);

        thingService.add(rid, config.getReward(), GameEvent.DREAMLAND);

        builder.setIdx(config.getIdx());
        return builder.build();
    }

    private List<Integer> randomBuff() {
        List<Integer> result = new ArrayList<>();
        dreamlandBuffSysCache.getBuffMap().values().forEach(configs -> {
            CDreamlandBuff config = RandomUtil.getRand(configs);
            result.add(config.getIdx());
        });
        return result;
    }

    public DreamlandGMsg.GResDreamlandSelectBuff selectBuffAndBattle(long rid, int idx) {
        Dreamland dreamland = loadAndRefresh(rid);
        dreamland.setCurrBuffId(idx);
        dreamland.setBuffValid(0);
        dreamland.setRandomBuffIds(randomBuff());
        changeBattleStatus(dreamland, DreamlandBattleStatus.BATTLE);
        dreamlandDao.update(dreamland);

        DreamlandGMsg.GResDreamlandSelectBuff.Builder builder = DreamlandGMsg.GResDreamlandSelectBuff.newBuilder();
        builder.setCurrBuffId(idx);
        builder.addAllNextBuffId(dreamland.getRandomBuffIds());

        builder.setBattle(battle(rid));

        return builder.build();
    }

    public DreamlandGMsg.GResDreamlandBattle battle(long rid) {
        //查找配置
        Dreamland dreamland = loadAndRefresh(rid);

        Asserts.isTrue(dreamlandLevelSysCache.getMaxLv() > dreamland.getCurLv(), ErrorCode.DREAMLAND_MAX_LV.getValue(),
                String.format("最大关卡，当前：{%s}，配置：{%s}", dreamlandLevelSysCache.getMaxLv(), dreamland.getCurLv()));

        Asserts.isTrue(dreamland.getBattleStatus() == DreamlandBattleStatus.BATTLE.getValue(), ErrorCode.DREAMLAND_NOT_IN_BATTLE.getValue(),
                String.format("状态不满足：{%s}", dreamland.getBattleStatus()));

        int battleLv = dreamland.getCurLv() + 1;
        List<CDreamlandLevel> heroConfigs = dreamlandLevelSysCache.getMissionMap().get(battleLv);

        Asserts.notNull(heroConfigs, String.format("下一关英雄配置不存在，当前：{%s}", dreamland.getCurLv()));

        BattlerDo monsterDo = battleTemplate.queryBattler(heroConfigs, String.format(languageHelper.getLanguageBy(
                languageSysCache.getByKey(dreamLandConst.LANGUAGE)), battleLv), Faction.DEFENDER, UnitType.MOSTER);

        BattlerDo playerDo = battleTemplate.queryBattler(dreamland.getBattlerVo(), roleService.getOrThrow(rid).getNick(), Faction.ATTACKER, UnitType.HERO);

        List<ImmutableThing> rewardShow = addUpReward(dreamland);
        BattleResult battleResult = battleHelper.invokeBattle(BattleType.DREAMLAND, playerDo, monsterDo);
        dreamland.setLastBattleResult(battleResult.isWin() ? 1 : 2);

        BattlerVo vo = battleResult.buildAttackerVo();

        vo.saveEnergy();
        vo.saveTriggerTimes();
        dreamland.setBattlerVo(vo);

        dreamland.setBuffValid(dreamland.getBuffValid() + 1);
        dreamlandDao.update(dreamland);

        DreamlandGMsg.GResDreamlandBattle.Builder builder = DreamlandGMsg.GResDreamlandBattle.newBuilder();
        builder.setCurLv(dreamland.getCurLv());
        builder.setMaxLv(dreamland.getMaxLv());
        builder.setCurrBattleLv(battleLv);
        builder.setTodayMaxLv(dreamland.getTodayMaxLv() - dreamland.getTodayMinLv());
        builder.addAllRewards(PbUtil.buildReward(rewardShow));
        builder.setReport(battleResult.getReport());

        DreamlandGMsg.GResDreamlandBattle data = builder.build();
        lastBattleData.put(rid, data);

        eventBus.post(DreamlandBattleEvent.of(dreamland.getRid()));
        return data;
    }

    /**
     * 派遣英雄
     *
     * @param rid
     * @param heroId
     * @return
     */
    public DreamlandGMsg.GResDreamlandDispatchHero dispatchHero(long rid, long heroId) {
        Dreamland dreamland = loadAndRefresh(rid);
        Asserts.isTrue(dreamland.getAssistHero().getId() == 0, ErrorCode.DREAMLAND_DISPATCH_HERO.getValue(), "助战英雄已派遣，不可更替。");

        //创建英雄Vo
        Hero hero = heroService.getHero(rid, heroId);
        Asserts.notNull(hero, ErrorCode.DREAMLAND_NOT_HERO.getValue(), "派遣的英雄不存在。");

        QueryHeroCommand command = QueryHeroCommand.createOf(hero);
        commandBus.invoke(command);
        HeroVo heroVo = HeroVo.valueOf(command.getHeroDo());

        dreamland.setAssistHero(heroVo);
        dreamlandDao.update(dreamland);

        thingService.add(rid, DreamLandConst.HELP_REWARD, GameEvent.DREAMLAND, NoticeType.TIPS);

        DreamlandGMsg.GResDreamlandDispatchHero.Builder builder = DreamlandGMsg.GResDreamlandDispatchHero.newBuilder();
        builder.setHero(heroService.buildHero(hero));
        return builder.build();
    }

    /**
     * 获取玩家最近的一次战报
     *
     * @param rid
     * @return
     */
    public DreamlandGMsg.GResDreamlandBattleReport battleReport(long rid) {
        DreamlandGMsg.GResDreamlandBattleReport.Builder builder = DreamlandGMsg.GResDreamlandBattleReport.newBuilder();
        Dreamland dreamland = loadAndRefresh(rid);
        DreamlandGMsg.GResDreamlandBattle battleData = lastBattleData.get(rid);
        if (battleData != null) {
            builder.setReport(battleData.getReport());
            builder.setCurrBattleLv(battleData.getCurrBattleLv());
            builder.addAllRewards(battleData.getRewardsList());
            builder.setCurrBuffId(dreamland.getCurrBuffId());
        }

        return builder.build();
    }

    /**
     * @param dreamland
     */
    public void addBattleRole(Dreamland dreamland) {

        HeroLineUp lineUpByType = heroLineUpService.getLineUpByType(dreamland.getRid(), LineUpType.DREAMLAND);

        List<Long> heroIds = new ArrayList<>(lineUpByType.getFormationMap().keySet());
        Asserts.isTrue(heroIds.size() > 0, ErrorCode.DREAMLAND_NOT_HERO_LINEUP.getValue(), "没有永恒梦境的布阵队伍。");
        List<Hero> heros = new ArrayList<>();
        boolean assist = false;
        HeroVo assistVo = null;
        for (HeroVo value : dreamland.getSelectHero().values()) {
            assistVo = value;
        }
        for (Long heroId : heroIds) {
            Hero hero = heroService.getHero(dreamland.getRid(), heroId);
            if (hero != null) {
                heros.add(hero);
            } else if (assistVo != null && assistVo.getId() == heroId) {
                assist = true;
            }
        }

        QueryHerosCommand command = QueryHerosCommand.createOfOnlyHero(heros);
        commandBus.invoke(command);
        List<HeroDo> heroDos = new ArrayList<>();
        heroDos.addAll(command.getHeroDos());
        if (assist) {
            HeroInitCommand initCommand = HeroInitCommand.createOf(Arrays.asList(assistVo));
            commandBus.invoke(initCommand);
            heroDos.addAll(initCommand.getHeroDos());
        }

        //设置位置
        heroDos.forEach(heroDo -> heroDo.setPosition(lineUpByType.getFormationMap().get(heroDo.getId()).getPos()));

        BattlerDo playerVO = battleHelper.queryPlayerBattler(BattleType.DREAMLAND, heroDos, dreamland.getRid(), Faction.ATTACKER);

        dreamland.setBattlerVo(playerVO.toBattlerVo());
        changeBattleStatus(dreamland, DreamlandBattleStatus.SELECT);
        dreamland.setLastBattleResult(0);
        dreamland.setTodayChallengeCount(dreamland.getTodayChallengeCount() + 1);
        dreamlandDao.update(dreamland);

        battleIngRole.add(dreamland.getRid());
    }

    /**
     * 挑战失败，结算发送奖励但不更新数据
     *
     * @param dreamland
     */
    private List<ImmutableThing> battleMissionEnd(Dreamland dreamland) {

        List<ImmutableThing> reward = addUpReward(dreamland);

        changeBattleStatus(dreamland, DreamlandBattleStatus.NORMAL);

        dreamland.setBattlerVo(new BattlerVo());
        dreamland.setCurrBuffId(0);
        dreamland.setThisPassLv(0);
        if (dreamland.getCurLv() > dreamland.getTodayRewardLv())
            dreamland.setTodayRewardLv(dreamland.getCurLv());
        dreamland.setCurLv(dreamland.getTodayMinLv());

        lastBattleData.remove(dreamland.getRid());

        dreamlandDao.update(dreamland);
        if (ImmutableThingUtil.getAllItemNums(reward) > 0) {
            thingService.add(dreamland.getRid(), reward, GameEvent.DREAMLAND);
        }
        return reward;
    }

    /***
     * 累计本次通关奖励
     * @param dreamland
     */
    private List<ImmutableThing> addUpReward(Dreamland dreamland) {
        List<ImmutableThing> reward = new ArrayList<>();

        for (int i = dreamland.getTodayRewardLv() + 1; i <= dreamland.getCurLv(); i++) {
            if (i > dreamlandDailyRewardSysCache.getMaxLv()) {
                break;
            }
            if (dreamland.getTodayMinLv() + DreamLandConst.STANDARD_REWARD_MAX >= i) {
                reward.addAll(dreamlandDailyRewardSysCache.getOrThrow(i).getStandard_reward());
            } else {
                reward.addAll(dreamlandDailyRewardSysCache.getOrThrow(i).getAfter_reward());
            }
        }
        reward = ImmutableThingUtil.mergeThing(reward);
        return reward;
    }

    private void sendBattleStatus(Dreamland dreamland) {
        DreamlandGMsg.GResDreamlandBattleStatus.Builder builder = DreamlandGMsg.GResDreamlandBattleStatus.newBuilder();
        builder.setStatus(DreamlandGMsg.PSBattleStatus.valueOf(dreamland.getBattleStatus()));
        contextManager.write(dreamland.getRid(), CmdCode._40010, builder.build());
    }

    public void autoBattle() {
        new ArrayList<>(battleIngRole).forEach(rid -> {
            try {

                Dreamland dreamland = loadAndRefresh(rid);
                if (dreamland.getBattleStatus() == DreamlandBattleStatus.NORMAL.getValue()) {
                    battleIngRole.remove(rid);
                    lastBattleData.remove(rid);
                    contextManager.write(rid, CmdCode._40010, updateStatus(rid));
                    this.sendBattleStatus(dreamland);
                } else {
                    int now = TimeDateUtil.getCurrentTimeInt();
                    //这里隔开是因为客户端要表现
                    if (dreamland.getLastBattleResult() == 0) {//当前关卡没有挑战，挑战下一关
                        if (dreamland.getBattleStatus() == DreamlandBattleStatus.BATTLE.getValue()) {
                            if (now - dreamland.getStatusChangeTime() >= DreamLandConst.BATTLE_FREQUENCY) {
                                battle(rid);
                                contextManager.write(rid, CmdCode._40011, battleReport(rid));
                            }
                        } else if (dreamland.getBattleStatus() == DreamlandBattleStatus.SELECT.getValue()) {
                            if (now - dreamland.getStatusChangeTime() >= DreamLandConst.BUFF_AUTO_TIME) {
                                selectBuffAndBattle(rid, RandomUtil.getRand(dreamland.getRandomBuffIds()));
                                contextManager.write(rid, CmdCode._40011, battleReport(rid));
                            }
                        }
                    } else {//上一次挑战之后，没有结算，结算一下
                        if (now - dreamland.getStatusChangeTime() >= DreamLandConst.BATTLE_FREQUENCY) {
                            winAddLv(dreamland);
                            contextManager.write(rid, CmdCode._40010, updateStatus(rid));
                        }
                    }
                }

            } catch (Exception e) {
                battleIngRole.remove(rid);
                lastBattleData.remove(rid);
                Dreamland dreamland = loadAndRefresh(rid);
                dreamland.setLastBattleResult(2);
                dreamlandDao.update(dreamland);
                winAddLv(dreamland);
                contextManager.write(rid, CmdCode._40010, updateStatus(rid));
                if (!(e instanceof ErrorCodeException)) {
                    log.error("定时任务执行失败！rid:" + rid, e);
                }
            }
        });
    }

    @Override
    public void start() throws Exception {

    }

    /**
     * 停服结算玩家数据，发送奖励
     *
     * @throws Exception
     */
    @Override
    public void stop() throws Exception {
        List<Dreamland> dreamlandList = new ArrayList<>();
        battleIngRole.forEach(rid -> {
            Dreamland dreamland = loadAndRefresh(rid);
            this.battleMissionEnd(dreamland);
            dreamlandList.add(dreamland);
        });
        dreamlandDao.update(dreamlandList);
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._15, "DreamlandService");
    }

    public HeroVo getMySelectAssist(long rid) {
        Dreamland dreamland = loadAndRefresh(rid);
        for (HeroVo value : dreamland.getSelectHero().values()) {
            return value;
        }
        return null;
    }

    private void changeBattleStatus(Dreamland dreamland, DreamlandBattleStatus status) {
        dreamland.setBattleStatus(status.getValue());
        dreamland.setLastBattleResult(0);
        dreamland.setStatusChangeTime(TimeDateUtil.getCurrentTimeInt());
    }

    public DreamlandGMsg.GResDreamlandEndBattle endBattle(Dreamland dreamland) {
        DreamlandGMsg.GResDreamlandEndBattle.Builder builder = DreamlandGMsg.GResDreamlandEndBattle.newBuilder();
        List<ImmutableThing> reward = battleMissionEnd(dreamland);
        builder.addAllRewards(PbUtil.buildReward(reward));
        builder.setBattleState(DreamlandGMsg.PSBattleStatus.valueOf(dreamland.getBattleStatus()));
        return builder.build();
    }

    public DreamlandGMsg.GResDreamlandBattleStatus updateStatus(long rid) {
        Dreamland dreamland = loadAndRefresh(rid);
        DreamlandGMsg.GResDreamlandBattleStatus.Builder builder = DreamlandGMsg.GResDreamlandBattleStatus.newBuilder();
        builder.setStatus(DreamlandGMsg.PSBattleStatus.valueOf(dreamland.getBattleStatus()));
        builder.setCurrBattleLv(dreamland.getCurLv());
        return builder.build();
    }

    /***
     * 增加玩家通关关卡
     * @param dreamland
     * @return
     */
    public DreamlandGMsg.GResDreamlandWinAddLv winAddLv(Dreamland dreamland) {
        synchronized (InternerPool.intern(DREAMLAND_ADD_LV_LOCK, dreamland.getRid())) {
            if (dreamland.getBattleStatus() != DreamlandBattleStatus.NORMAL.getValue()) {
                if (dreamland.getLastBattleResult() == 1) {
                    dreamland.setThisPassLv(dreamland.getThisPassLv() + 1);
                    dreamland.setCurLv(dreamland.getCurLv() + 1);
                    dreamland.setTodayMaxLv(Math.max(dreamland.getCurLv(), dreamland.getTodayMaxLv()));
                    if (dreamland.getMaxLv() < dreamland.getCurLv()) {
                        dreamland.setMaxLv(dreamland.getCurLv());
                        eventBus.post(DreamlandMaxLvEvent.of(dreamland.getRid(), dreamland.getMaxLv()));
                    }
                    //最大关卡结算战斗
                    if (dreamland.getCurLv() >= dreamlandLevelSysCache.getMaxLv()) {
                        this.battleMissionEnd(dreamland);
                    } else {
                        //切换状态
                        if (dreamland.getThisPassLv() % DreamLandConst.BUFF_EACH_LEVEL == 0) {
                            changeBattleStatus(dreamland, DreamlandBattleStatus.SELECT);
                        } else {
                            changeBattleStatus(dreamland, DreamlandBattleStatus.BATTLE);
                        }
                    }
                } else if (dreamland.getLastBattleResult() == 2) {
                    this.battleMissionEnd(dreamland);
                }
            }
            dreamlandDao.update(dreamland);
        }
        DreamlandGMsg.GResDreamlandWinAddLv.Builder builder = DreamlandGMsg.GResDreamlandWinAddLv.newBuilder();
        builder.setCurLv(dreamland.getCurLv());
        builder.setCurrBattleLv(dreamland.getCurLv() + 1);
        builder.setMaxLv(dreamland.getMaxLv());
        builder.setTodayMaxLv(dreamland.getTodayMaxLv() - dreamland.getTodayMinLv());
        builder.setStatus(DreamlandGMsg.PSBattleStatus.valueOf(dreamland.getBattleStatus()));

        return builder.build();

    }

    /**
     * 清理永恒梦境助战英雄
     *
     * @param rid
     * @param heroId
     */
    private void clearDreamLandAssist(long rid, long heroId) {
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(rid, LineUpType.DREAMLAND);
        if (heroLineUp.getFormationMap().containsKey(heroId)) {
            heroLineUp.getFormationMap().remove(heroId);
            heroLineUpService.updateHeroLineUp(heroLineUp);
        }
    }
}
