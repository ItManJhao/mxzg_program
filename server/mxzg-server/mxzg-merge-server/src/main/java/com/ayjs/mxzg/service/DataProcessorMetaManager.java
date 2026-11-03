package com.ayjs.mxzg.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.meta.TableMeta;
import com.ayjs.mxzg.common.util.scanner.PackageScanner;
import com.ayjs.mxzg.gameserver.module.achievement.domain.RoleAchievementRecord;
import com.ayjs.mxzg.gameserver.module.achievement.domain.RoleDailyTask;
import com.ayjs.mxzg.gameserver.module.adven.domain.AdvenMission;
import com.ayjs.mxzg.gameserver.module.astrolabe.domain.Astrolabe;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPoolRareLog;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionBattle;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionPlayer;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionRobot;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMemberDonate;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanSkill;
import com.ayjs.mxzg.gameserver.module.clanworldboss.domain.ClanWorldBossReport;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarSystem;
import com.ayjs.mxzg.gameserver.module.dreamland.domin.Dreamland;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonInfo;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess2;
import com.ayjs.mxzg.gameserver.module.friend.domain.BlackList;
import com.ayjs.mxzg.gameserver.module.friend.domain.FriendShip;
import com.ayjs.mxzg.gameserver.module.headPortrait.domain.RoleHeadPortrait;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroFashion;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroPrayer;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroScore;
import com.ayjs.mxzg.gameserver.module.hero.domain.Illustrat;
import com.ayjs.mxzg.gameserver.module.ladder.domain.LadderMyBattle;
import com.ayjs.mxzg.gameserver.module.ladder.domain.LadderSuperiorBattle;
import com.ayjs.mxzg.gameserver.module.mail.domain.MailSome;
import com.ayjs.mxzg.gameserver.module.onlineReward.domain.OnlineReward;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion067WeekendKoiSysInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.pvp.domain.PvpSysInfo;
import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowSlot;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.sensitive.domain.SensitiveWord;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.StageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleReport;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesSuperiorBattle;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernInfo;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamBattleRecord;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamBattleRecordDetail;
import com.ayjs.mxzg.gameserver.module.title.domain.Title;
import com.ayjs.mxzg.gameserver.module.tower.domain.Tower;
import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaidersLog;
import com.ayjs.mxzg.gameserver.module.video.domain.VideoHall;
import com.ayjs.mxzg.gameserver.remote.cross.domain.CrossServerGroup;
import com.ayjs.mxzg.gameserver.remote.large.domain.LargeServerGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslands;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.register.MergeRegister;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.manager.TableMetaManager;
import com.ayjs.mxzg.struct.DataProcessorMeta;
import com.ayjs.mxzg.template.scheduler.domain.CronTaskBackup;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 表合并方式
 *
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
@Slf4j
public class DataProcessorMetaManager {
    private static DataProcessorMetaManager instance;

    public static DataProcessorMetaManager getInstance() {
        if (instance == null) {
            instance = new DataProcessorMetaManager();
        }
        return instance;
    }

    @Getter
    List<DataProcessorMeta> dataProcessorMetas = Lists.newArrayList();

    private Comparator comparator = Comparator.comparingInt(DataProcessorMeta::getPriority);

    Map<Class<? extends AbstractEntity>, DataProcessorMeta> mergeTableMap = Maps.newHashMap();

    @Getter
    Map<String, ProcessorType> tableName2ProcessType = new HashMap<>();

    /***
     *
     * @param clz
     * @param type
     * @param priority
     *      注册游戏表处理
     */
    public void doRegisterGame(Class<? extends AbstractEntity> clz, ProcessorType type, int priority) {
        doRegister(clz, type, priority, MergeRepositoryManager.DATA_SIGN);
    }

    /***
     *
     * @param clz
     * @param type
     * @param priority
     * @param source MergeRepositoryManager.DATA_SIGN,MergeRepositoryManager.LOG_SIGN
     * 优先级，值越大，优先级越高
     */
    public void doRegister(Class<? extends AbstractEntity> clz, ProcessorType type, int priority, String source) {
        DataProcessorMeta old = mergeTableMap.put(clz, DataProcessorMeta.of(clz, priority, type, source));
        if (Objects.nonNull(old) && old.getProcessorType() != type) {
            throw new RuntimeException(String.format("duplicate register clz{%s}", clz));
        }
        tableName2ProcessType.put(TableMetaManager.getInstance().get(clz).getName().toLowerCase(), type);
    }

    public void registerMeta(Map<String, Set<Class<? extends AbstractEntity>>> tables) {
        doRegisterGame(RoleAchievementRecord.class, ProcessorType.REMOVE_ZERO, 0);

        doRegisterGame(ArenaTeamBattleRecord.class, ProcessorType.TRUNCATE_ALL, 0);
        doRegisterGame(ArenaTeamBattleRecordDetail.class, ProcessorType.TRUNCATE_ALL, 0);

        doRegisterGame(BlessingPoolRareLog.class, ProcessorType.RESERVE_SOURCE, 0);
        doRegisterGame(BlackList.class, ProcessorType.REMOVE_ZERO, 0);

        doRegisterGame(Clan.class, ProcessorType.CLAN, 0);
        //世界boss处理
        doRegister(ClanWorldBossReport.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(ChampionBattle.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(ChampionCompetitor.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(ChampionPlayer.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(ChampionRobot.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(ChampionSystem.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(CronTaskBackup.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(CrossServerGroup.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);

        doRegister(FloatingIslandsTime.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(FloatingIslands.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);

        doRegister(HeroScore.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
//        doRegister(HeroPalace.class, ProcessorType.SOURCE_TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);

        doRegister(LadderMyBattle.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(LadderSuperiorBattle.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(LargeServerGroup.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);

        doRegister(MailSome.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);

        doRegister(PinnacleReport.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(Promotion067WeekendKoiSysInfo.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(PromotionControl.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(PvpSysInfo.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(PreliminariesSuperiorBattle.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);

        doRegister(Role.class, ProcessorType.ROLE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(RoleDailyTask.class, ProcessorType.REMOVE_ZERO, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(SensitiveWord.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(ServerParam.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(StageMatch.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(TowerRaidersLog.class, ProcessorType.TOWER_LOG, 0, MergeRepositoryManager.DATA_SIGN);
        doRegister(VideoHall.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);

        doRegisterGame(Tower.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(Astrolabe.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(ClanSkill.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(FetterGoddess2.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(Title.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(AdvenMission.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(DungeonInfo.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(Illustrat.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(RoleHeadPortrait.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(FriendShip.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(HeroPrayer.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(HeroFashion.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(Dreamland.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(ClanMemberDonate.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(RainbowSlot.class, ProcessorType.RAINBOW_SLOT, 0);
        doRegisterGame(SpaceTimeInfo.class, ProcessorType.SPACE_TIME_INFO, 0);
        doRegisterGame(TavernInfo.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(OnlineReward.class, ProcessorType.REMOVE_ZERO, 0);
        doRegisterGame(CountryWarSystem.class, ProcessorType.RESERVE_SOURCE, 0);

        //扫描模块处理类
        Set<Class<MergeRegister>> classes = PackageScanner.scanPackages((clz) -> !clz.isInterface() && MergeRegister.class.isAssignableFrom(clz),
                "com.ayjs.mxzg.register");
        classes.forEach(clz -> {
            try {
                MergeRegister mergeRegister = clz.newInstance();
                mergeRegister.register(this);
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        });

        checkNotRegisterHandler(tables);

        dataProcessorMetas.addAll(mergeTableMap.values());
        CollectionUtil.sort(dataProcessorMetas, comparator);

        log.info("合并的表和合并方式*********************{}", dataProcessorMetas.size());

        Collection<TableMeta> values = TableMetaManager.getInstance().getMetaMap().values();
        List<TableMeta> list = new ArrayList<>(values);
        Collections.sort(list, Comparator.comparing(TableMeta::getName));
        list.forEach(meta -> {
            if (mergeTableMap.get(meta.getClazz()) == null) {
                log.info("表:{},表描述:{},合并方式:{}", meta.getName(), meta.getComment(), ProcessorType.NONE.getContext());
            } else {
                log.info("表:{},表描述:{},合并方式:{}", meta.getName(), meta.getComment(), mergeTableMap.get(meta.getClazz()).getProcessorType().getContext());
            }
        });
//        dataProcessorMetas.forEach(dataProcessorMeta -> {
//            TableMeta meta = TableMetaManager.getInstance().get(dataProcessorMeta.getClz());
//            log.info("表:{},表描述:{}，合并方式:{}", meta.getName(), meta.getComment(), dataProcessorMeta.getProcessorType().getContext());
//        });
        log.info("**************************");

    }

    /***
     * 检测没有注册处理类的entity对象，只检测游戏类
     * @param tables
     */
    public void checkNotRegisterHandler(Map<String, Set<Class<? extends AbstractEntity>>> tables) {
        Set<Class<? extends AbstractEntity>> classSet = tables.get(MergeRepositoryManager.DATA_SIGN);
        classSet = classSet.stream().filter(clz -> !mergeTableMap.containsKey(clz)).collect(Collectors.toSet());
        classSet.forEach(clz -> {
            try {
                if (clz.getDeclaredField("rid") == null) {
                    log.info("未注册合服数据处理类{}", clz.getName());
                }
            } catch (NoSuchFieldException e) {
            }
        });
    }

}
