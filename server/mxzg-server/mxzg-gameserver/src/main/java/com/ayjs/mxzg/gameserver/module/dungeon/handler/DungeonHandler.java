package com.ayjs.mxzg.gameserver.module.dungeon.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.config.excel.entity.*;
import com.ayjs.mxzg.config.struct.*;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonAgenitaEventEnum;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEnum;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonItemEnum;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.Dungeon;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonBackpack;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonInfo;
import com.ayjs.mxzg.gameserver.module.dungeon.event.*;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonBackpackService;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonInfoService;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonService;
import com.ayjs.mxzg.gameserver.module.dungeon.struct.DungeonShopItem;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.struct.ShelterStartTime;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.DungeonGMsg;
import com.ayjs.mxzg.protocol.DungeonGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.*;

@Controller
public class DungeonHandler extends ProtocolHandler {

    @Autowired
    private ShelterEventItemSysCache shelterEventItemSysCache;
    @Autowired
    private ShelterKillRewardSysCache shelterKillRewardSysCache;
    @Autowired
    private ShelterShopPrizeSysCache shelterShopPrizeSysCache;
    @Autowired
    private ShelterLevelSysCache shelterLevelSysCache;
    @Autowired
    private ShelterEventStoneSysCache shelterEventStoneSysCache;
    @Autowired
    private ShelterEventFreeBoxSysCache shelterEventFreeBoxSysCache;
    @Autowired
    private ShelterEventKeyBoxSysCache shelterEventKeyBoxSysCache;
    @Autowired
    private SheltereventBuffSysCache sheltereventBuffSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private DungeonInfoService dungeonInfoService;
    @Autowired
    private DungeonService dungeonService;
    @Autowired
    private DungeonBackpackService dungeonBackpackService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;

    /**
     * 地牢数据
     */
    @CMD(id = CmdCode._24001)
    public void dungeonInfo(PlayerContext playerContext, GReqDungeonInfo msg) {
        GResDungeonInfo.Builder builder = GResDungeonInfo.newBuilder();
        ServerParam shelterStarTime = dungeonInfoService.getShelterStarTime();
        builder.setStartTime(shelterStarTime.parseJson(ShelterStartTime.class).getStartTime());
        builder.setEndTime(shelterStarTime.parseJson(ShelterStartTime.class).getEndTime());
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());
        builder.setNpcNum(dungeonInfo.getWinTimes());
        builder.setCurStage(dungeonInfo.getNowStage());
        builder.setGridType(dungeonInfo.getGridType());
        List<Dungeon> list = dungeonService.list(playerContext.getId());
        for (Dungeon dungeon : list) {
            PSDungeonInfo.Builder model = PSDungeonInfo.newBuilder();
            model.setGridRandType(dungeon.getGridType());
            model.setGridX(dungeon.getGridX());
            model.setGridY(dungeon.getGridY());
            model.setIsOpen(dungeon.getIsOpen());
            model.setGridEventType(dungeon.getEventDetail() == 0 ? 0 : dungeon.getEventType());
            model.setGridEventNum(dungeon.getEventDetail());
            builder.addList(model.build());
        }
        playerContext.write(CmdCode._24001, builder.build());
    }

    /**
     * 地牢商店
     */
    @CMD(id = CmdCode._24002)
    public void dungeonShopData(PlayerContext playerContext, GReqDungeonShopList msg) {
        GResDungeonShopList.Builder builder = GResDungeonShopList.newBuilder();
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());
        for (DungeonShopItem model : dungeonInfo.getShopItemList()) {
            PSDungeonShopData.Builder shopData = PSDungeonShopData.newBuilder();
            shopData.setIndex(model.getIndex());
            shopData.setShopId(model.getShopId());
            shopData.setIsBuy(model.getIsBuy());

            CShelterShopPrize cModel = shelterShopPrizeSysCache.getOrThrow(model.getItemId());
            shopData.setCostType(cModel.getCost().get(0).getItem_type());
            shopData.setCostNum((int) cModel.getCost().get(0).getItem_num());
            shopData.setItemType(cModel.getItem().get(0).getItem_type());
            shopData.setItemNum((int) cModel.getItem().get(0).getItem_num());
            shopData.setDiscount(cModel.getDiscount());

            builder.addList(shopData.build());
        }//end for
        playerContext.write(CmdCode._24002, builder.build());
    }

    /**
     * 请求地牢出战队列信息
     */
    @CMD(id = CmdCode._24003)
    public void getDungeonBattleLineup(PlayerContext playerContext, GReqDungeonTeam msg) {
        GResDungeonTeam.Builder builder = GResDungeonTeam.newBuilder();
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());
        Map<Integer, BattlerVo> map = dungeonInfo.getBattleMap();
        map.forEach((key, value) -> {
            PSDungeonTeamData.Builder data = PSDungeonTeamData.newBuilder();
            data.setIndex(key);
            long currHp = value.getHeros().stream().mapToLong(HeroVo::getHp).sum();//当前血量值
            long maxHp = value.getHeros().stream().mapToLong(HeroVo::getMaxHp).sum();//最大血量值
            data.setHeroRate((int) Math.ceil((currHp >= 0 ? currHp : 0) * 1.0f / maxHp * DungeonEnum.HP_RATE.getType()));
            data.setLevel(value.getHeros().get(0).getHero_level());
            data.setHeroType(value.getHeros().get(0).getHero_type());
            data.setStar(value.getHeros().get(0).getHero_star());
            data.setElem(heroTypeSysCache.getOrThrow(value.getHeros().get(0).getHeroId()).getElem());
            data.setHeroBat(dungeonInfo.getFightingMap().get(key));
            data.setHeroId(value.getHeros().get(0).getId());
            builder.addList(data);
        });
        playerContext.write(CmdCode._24003, builder.build());
    }

    /**
     * 保存地牢出战队列信息
     */
    @CMD(id = CmdCode._24004)
    public void putDungeonBattleLineup(PlayerContext playerContext, GReqDungeonInitTeam msg) {
        GResDungeonInitTeam.Builder builder = GResDungeonInitTeam.newBuilder();

        Asserts.isTrue(msg.getListList().size() > 0, ErrorCode.SHELTER_LINEUP_NOT_NULL.getValue(),
                "shelter lineup null; rid: " + playerContext.getId());

        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());

        Asserts.isTrue(dungeonInfo.getBattleMap().size() <= 0, ErrorCode.SHELTER_BATTER_LINEUP.getValue(),
                "Shelter battle lineup already exist!");

        Map<Integer, BattlerVo> battlerMap = new HashMap<>();
        Map<Integer, Integer> fightingMap = new HashMap<>();

        msg.getListList().forEach(data -> {
            if (data.getHeroId() > 0) {
                Hero hero = heroService.getHero(playerContext.getId(), data.getHeroId());
                Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "庇护所战斗队伍英雄为空：" + data.getHeroId());
                BattlerVo battlerVo = battleHelper.queryPlayerBattler(playerContext.getId(), data.getHeroId(), Faction.ATTACKER).toBattlerVo();
                battlerMap.put(data.getIndex(), battlerVo);
                fightingMap.put(data.getIndex(), hero.getFighting());
            }

        });

        dungeonInfo.setFightingMap(fightingMap);
        dungeonInfo.setBattleMap(battlerMap);
        dungeonInfoService.update(dungeonInfo);

        playerContext.write(CmdCode._24004, builder.build());

        eventBus.post(DungeonHeroLineEvent.of(playerContext.getId()));

    }

    /**
     * 地牢击杀奖励列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._24005)
    public void dungeonKillBossReward(PlayerContext playerContext, GReqDungeonKillRewardList msg) {
        GResDungeonKillRewardList.Builder builder = GResDungeonKillRewardList.newBuilder();
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());

        Map<Integer, Integer> killMap = dungeonInfo.getKillReward();

        List<CShelterKillReward> list = shelterKillRewardSysCache.getAll();

        boolean b = false;
        for (CShelterKillReward cModel : list) {
            if (killMap.get(cModel.getIdx()) == null) {//存在未添加的奖励类型
                killMap.put(cModel.getIdx(), 0);
                b = true;
            }
        }
        if (b) {
            dungeonInfo.setKillReward(killMap);
            dungeonInfoService.update(dungeonInfo);
        }
        for (Map.Entry<Integer, Integer> entry : killMap.entrySet()) {
            PSdungeonKillRewardData.Builder data = PSdungeonKillRewardData.newBuilder();
            data.setIndex(entry.getKey());
            data.setReward(entry.getValue());
            builder.addList(data);
        }
        playerContext.write(CmdCode._24005, builder.build());
    }

    /**
     * 地牢击杀奖励领取
     */
    @CMD(id = CmdCode._24006)
    public void getDungeonKillReward(PlayerContext playerContext, GReqDungeonKillReward msg) {
        GResDungeonKillReward.Builder builder = GResDungeonKillReward.newBuilder();
        builder.setIndex(msg.getRewardIndex());
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());
        if (dungeonInfo.getKillReward().getOrDefault(msg.getRewardIndex(), 0) == 1) {
            builder.setStatus(0);
            playerContext.write(CmdCode._24006, builder.build());
            return;
        }
        CShelterKillReward cModel = shelterKillRewardSysCache.getOrThrow(msg.getRewardIndex());
        if (cModel == null || cModel.getWin_times() > dungeonInfo.getWinTimes()) {
            builder.setStatus(0);
            playerContext.write(CmdCode._24006, builder.build());
            return;
        }
        // 修改数据
        dungeonInfo.getKillReward().put(cModel.getIdx(), 1);
        dungeonInfoService.update(dungeonInfo);
        // 加奖励内容
        thingService.add(playerContext.getId(), cModel.getReward(), GameEvent.DUNGEON_KILL_BOX);

        playerContext.write(CmdCode._24006, builder.build());
    }

    /**
     * 获取地牢道具列表
     */
    @CMD(id = CmdCode._24007)
    public void getDungeonPropsList(PlayerContext playerContext, GReqDungeonPropsList msg) {
        dungeonBackpackService.getDungeonBackpack(playerContext.getId());
    }

    /**
     * 获取地牢Buff列表
     */
    @CMD(id = CmdCode._24008)
    public void getDungeonBuffList(PlayerContext playerContext, GReqDungeonBuffList msg) {
        GResDungeonBuffList.Builder builder = GResDungeonBuffList.newBuilder();
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());
        for (Map.Entry<AttributeType, Long> entry : dungeonInfo.getBuff().entrySet()) {
            PSDungeonBuffData.Builder data = PSDungeonBuffData.newBuilder();
            data.setItemType(entry.getKey().getValue());
            data.setItemNum(Math.toIntExact(entry.getValue()));
            builder.addList(data);
        }
        playerContext.write(CmdCode._24008, builder.build());
    }

    /**
     * 地牢怪物剩余血量数据
     */
    @CMD(id = CmdCode._24009)
    public void getDungeonMonsterHpList(PlayerContext playerContext, GReqDungeonMonsterHpList msg) {
        GResDungeonMonsterHpList.Builder builder = GResDungeonMonsterHpList.newBuilder();
        List<Dungeon> dungeonList = dungeonService.getMonsterDungeonList(playerContext.getId());
        dungeonList.forEach(dungeon -> {
            PSDungeonMonsterHpData.Builder data = PSDungeonMonsterHpData.newBuilder();
            data.setMonsterLevel((int) dungeon.getEventDetail());
            long currHp = dungeon.getBattlerVo().getHeros().stream().mapToLong(HeroVo::getHp).sum();//当前血量值
            long maxHp = dungeon.getBattlerVo().getHeros().stream().mapToLong(HeroVo::getMaxHp).sum();//最大血量值
            data.setHpRate((int) Math.ceil(currHp * 1.0f / maxHp * DungeonEnum.HP_RATE.getType()));
            builder.addList(data);

        });
        playerContext.write(CmdCode._24009, builder.build());
    }

    /**
     * 打开地牢网格
     */
    @CMD(id = CmdCode._24011)
    public void dungeonGridOpen(PlayerContext playerContext, GReqDungeonGridLight msg) {

        DungeonGMsg.GResDungeonGridLight.Builder builder = DungeonGMsg.GResDungeonGridLight.newBuilder();

        List<Dungeon> updateDungeonList = new ArrayList<>();

        List<String> no_open_grid = new ArrayList<>();//不能打开的网格
        String[] npc_1 = new String[]{"11", "12", "13", "21", "23", "31",
                "32", "33"};// 怪物1控制区域
        String[] npc_2 = new String[]{"13", "14", "15", "23", "25", "33",
                "34", "35"};// 怪物2控制区域
        String[] npc_3 = new String[]{"31", "32", "33", "41", "43", "51",
                "52", "53"};// 怪物3控制区域
        String[] npc_4 = new String[]{"33", "34", "35", "43", "45", "53",
                "54", "55"};// 怪物4控制区域
        List<Dungeon> dungeonList = dungeonService.getAliveBoss(playerContext.getId());
        for (Dungeon model : dungeonList) {
            if (model.getGridX() == 2 && model.getGridY() == 2) {
                for (String str : npc_1) {
                    if (!no_open_grid.contains(str)) {
                        no_open_grid.add(str);
                    }
                }
            } else if (model.getGridX() == 2 && model.getGridY() == 4) {
                for (String str : npc_2) {
                    if (!no_open_grid.contains(str)) {
                        no_open_grid.add(str);
                    }
                }
            } else if (model.getGridX() == 4 && model.getGridY() == 2) {
                for (String str : npc_3) {
                    if (!no_open_grid.contains(str)) {
                        no_open_grid.add(str);
                    }
                }
            } else if (model.getGridX() == 4 && model.getGridY() == 4) {
                for (String str : npc_4) {
                    if (!no_open_grid.contains(str)) {
                        no_open_grid.add(str);
                    }
                }
            }
        }//end for

        msg.getListList().forEach(psDungeonPlace -> {

            Dungeon dungeon = dungeonService.selectOne(playerContext.getId(), psDungeonPlace.getGridX(), psDungeonPlace.getGridY());

            updateDungeonList.forEach(dungeon1 -> {
                Asserts.isTrue(!(dungeon1.getGridY() == dungeon.getGridY() && dungeon1.getGridX() == dungeon.getGridX()),
                        ErrorCode.SHELTER_GRID_REPEAT_OPEN.getValue(), "网格重复开启，x:" + psDungeonPlace.getGridX() + ",y: " + psDungeonPlace.getGridY());
            });

            Asserts.isTrue(dungeon != null && dungeon.getIsOpen() == 0, ErrorCode.SHELTER_DUNGEON_OPEN.getValue(),
                    "该网格已打开或不存在该位置网格，x:" + psDungeonPlace.getGridX() + ",y: " + psDungeonPlace.getGridY());

            Asserts.isTrue(!no_open_grid.contains(psDungeonPlace.getGridX() + "" + psDungeonPlace.getGridY()), ErrorCode.SHELTER_DUNGEON_OPEN.getValue(),
                    "守护网格的NPC没被击杀无法打开。");

            //更新网格打开状态
            dungeon.setIsOpen(1);
            updateDungeonList.add(dungeon);

        });

        updateDungeonList.stream().filter(dungeon -> dungeon.getEventType() == DungeonEvent.SHOP_EVENT.getEventType()).forEach(dungeon -> {
            dungeonInfoService.insertShopCommodity(playerContext.getId(), dungeon.getEventDetail(), 3);
        });

        dungeonService.update(updateDungeonList);

        playerContext.write(CmdCode._24011, builder.build());
    }

    /**
     * 进入地牢下一层
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._24012)
    public void nextDungeonStage(PlayerContext playerContext, DungeonGMsg.GReqDungeonNextStage msg) {
        GResDungeonNextStage.Builder builder = GResDungeonNextStage.newBuilder();
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());

        //检查当前层是否为最大层
        int maxStage = shelterLevelSysCache.maxShelterLevel();

        builder.setStatus(1);
        if (dungeonInfo.getNowStage() >= maxStage) {

            dungeonInfo.setStage(maxStage);
            dungeonInfoService.update(dungeonInfo);
            eventBus.post(DungeonStageEvent.of(playerContext.getId(), dungeonInfo.getStage()));
            playerContext.write(CmdCode._24012, builder.build());
            return;
        }
        //检查怪物是否全部已击杀
        if (dungeonService.getAliveBoss(playerContext.getId()).size() > 0) {
            playerContext.write(CmdCode._24012, builder.build());
            return;
        }

        dungeonInfo.setGridType(RandomUtil.rand(1, DungeonEnum.GRID_TYPE1_MAX.getType() + 1));
        dungeonInfo.setNowStage(dungeonInfo.getNowStage() + 1);
        boolean f = false;//用于判断是否更新排行榜
        if (dungeonInfo.getNowStage() - 1 > dungeonInfo.getStage()) {//更新历史记录
            f = true;
            dungeonInfo.setStage(dungeonInfo.getNowStage() - 1);//只记录已通关最高关卡
        }
        dungeonInfo.setTime(DateTimeUtil.currentSecond());
        dungeonService.resetDungeon(dungeonInfo);

        builder.setStatus(0);
        List<PSDungeonNextStageData> builderList = new ArrayList<>();
        dungeonInfo.getEarningsList().forEach(earnings -> {
            PSDungeonNextStageData.Builder data = PSDungeonNextStageData.newBuilder();
            data.setItemType(earnings.getItemType());
            data.setItemNum((int) earnings.getItemNum());
            builderList.add(data.build());
        });
        //dungeonInfo.getEarningsList().clear();
        dungeonInfoService.update(dungeonInfo);

        builderList.sort(Comparator.comparingLong(PSDungeonNextStageData::getItemType));
        builder.addAllList(builderList);

        playerContext.write(CmdCode._24012, builder.build());
        //空清当前层地牢收益

        if (f) {
            eventBus.post(DungeonStageEvent.of(playerContext.getId(), dungeonInfo.getStage()));
        }
    }

    /**
     * 地牢使用道具
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._24013)
    public void dungeonUseProps(PlayerContext playerContext, DungeonGMsg.GReqDungeonUseProps msg) {
        DungeonGMsg.GResDungeonUseProps.Builder builder = DungeonGMsg.GResDungeonUseProps.newBuilder();
        builder.setPropsType(msg.getPropsType());
        builder.setTargetId(msg.getTargetId());
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());

        DungeonBackpack dungeonBackpack = dungeonBackpackService.selectItem(playerContext.getId(), msg.getPropsType());
        if (dungeonBackpack.getUseNum() >= systemSysCache.getShelterItemUseLimit()) {
            builder.setStatus(0);
            playerContext.write(CmdCode._24013, builder.build());
            return;
        }

        if (msg.getPropsType() == DungeonAgenitaEventEnum.HP_AGENTIA.getType()) {// 使用HP回药剂

            long maxHp = dungeonInfo.getBattleMap().get(msg.getTargetId()).getHeros().get(0).getMaxHp();
            long currHp = dungeonInfo.getBattleMap().get(msg.getTargetId()).getHeros().get(0).getHp();

            if (currHp <= 0 || currHp >= maxHp) {
                builder.setStatus(0);
                playerContext.write(CmdCode._24013, builder.build());
                return;
            }

            if (!dungeonBackpackService.delitem(playerContext.getId(), msg.getPropsType(), 1)) {// 扣除道具
                builder.setStatus(0);
                playerContext.write(CmdCode._24013, builder.build());
                return;
            }

            //恢复battlerVo里的血量数据

            long regainHp = maxHp * systemSysCache.getShelterHealing() / DungeonEnum.HP_RATE.getType();
            if (regainHp + currHp > maxHp) {
                regainHp = maxHp - currHp;
            }

            dungeonInfo.getBattleMap().get(msg.getTargetId()).getHeros().get(0).addAttribute(AttributeType.HP, regainHp);

        } else if (msg.getPropsType() == DungeonAgenitaEventEnum.NPC_AGENTIA.getType()) {// 使用怪物NPC驱散药剂
            List<Dungeon> list = dungeonService.getAliveBoss(playerContext.getId());
            if (list.size() >= 2 && msg.getTargetId() == 5) {// 当怪物量大于2只，且要清除的是BOSS时。不执行
                // BOSSNPC要最后击杀才有效
                builder.setStatus(0);
                playerContext.write(CmdCode._24013, builder.build());
                return;
            }
            if (!dungeonBackpackService.delitem(playerContext.getId(), msg.getPropsType(), 1)) {// 扣除道具
                builder.setStatus(0);
                playerContext.write(CmdCode._24013, builder.build());
                return;
            }
            // 删除该Boss的网格记录
            Dungeon dungeon = null;
            for (Dungeon model : list) {
                if (model.getEventDetail() == msg.getTargetId()) {
                    dungeon = model;
                }
            }
            Asserts.notNull(dungeon, ErrorCode.SHELTER_MONSTER_NOT_HP.getValue(), "该祭祀已阵亡。");
            dungeon.setEventDetail(0);
            dungeon.setEventType(0);
            dungeonService.update(dungeon);

            // 更新击杀怪物数据
            dungeonInfo.setWinTimes(dungeonInfo.getWinTimes() + 1);
        }
        dungeonInfoService.update(dungeonInfo);

        // 返回数据给前端
        builder.setStatus(1);
        playerContext.write(CmdCode._24013, builder.build());

        eventBus.post(DungeonUseAgenitaEvent.of(playerContext.getId(), msg.getPropsType()));
    }

    /**
     * 地牢获得资源
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._24014)
    public void dungeonGetResource(PlayerContext playerContext, DungeonGMsg.GReqDungeonGetRes msg) {
        DungeonGMsg.GResDungeonGetRes.Builder builder = DungeonGMsg.GResDungeonGetRes.newBuilder();
        builder.setGridX(msg.getGridX());
        builder.setGridY(msg.getGridY());
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());
        Dungeon dungeon = dungeonService.selectOne(playerContext.getId(), msg.getGridX(), msg.getGridY());
        if (dungeon == null || dungeon.getEventDetail() == 0
                || dungeon.getIsOpen() == 0 || DungeonEvent.getNotResourceEvent().contains(dungeon.getEventType())) {//无资源事件或网格未打开
            builder.setStatus(1);
            playerContext.write(CmdCode._24014, builder.build());
            return;
        }

        Role role = roleService.getOrThrow(playerContext.getId());
        builder.setEventType(dungeon.getEventType());
        if (dungeon.getEventType() == DungeonEvent.GOLD_EVENT.getEventType()) {// 金币事件
            ImmutableThing reward = dungeonInfoService.dungeonGoldEven((int) dungeon.getEventDetail(), dungeonInfo.getNowStage() - 1);
            thingService.add(role.getId(), reward, GameEvent.DUNGEON, NoticeType.TIPS);
            //记录收益
            dungeonInfoService.addDungeonItem(playerContext.getId(), ItemType.IT_GOLD, reward.getItem_num());
            builder.setItemType(reward.getItem_type());
            builder.setItemNum((int) reward.getItem_num());
        } else if (dungeon.getEventType() == DungeonEvent.STONE_EVENT.getEventType()) {// 石堆事件
            CShelterEventStone cShelterEventStone = shelterEventStoneSysCache.getOrThrow((int) dungeon.getEventDetail());
            thingService.add(role.getId(), cShelterEventStone.getReward(), GameEvent.DUNGEON, NoticeType.TIPS);
            for (ImmutableThing reward : cShelterEventStone.getReward()) {
                dungeonInfoService.addDungeonItem(playerContext.getId(), reward.getItem_type(), reward.getItem_num());
                builder.setItemType(reward.getItem_type());
                builder.setItemNum((int) reward.getItem_num());
            }
        } else if (dungeon.getEventType() == DungeonEvent.KEY_EVENT.getEventType()) {// 钥匙事件
            dungeonBackpackService.addItem(playerContext.getId(), DungeonItemEnum.BOX_KEY.getItemType(), (int) dungeon.getEventDetail());
            dungeonInfoService.addDungeonItem(playerContext.getId(), DungeonItemEnum.BOX_KEY.getItemType(), 1);
            builder.setItemType(DungeonItemEnum.BOX_KEY.getItemType());
            builder.setItemNum(1);
        } else if (dungeon.getEventType() == DungeonEvent.BUFF_EVENT.getEventType()) {// BUFF事件
            ImmutableList<EffectBuffType> buff = sheltereventBuffSysCache.getOrThrow((int) dungeon.getEventDetail()).getEffect();
            Map<AttributeType, Long> newBuff = dungeonInfo.getBuff();
            buff.forEach(type -> {
                newBuff.put(AttributeType.valueOf(type.getAttr()), newBuff.getOrDefault(AttributeType.valueOf(type.getAttr()), 0L) + type.getValue());
                builder.setItemType(type.getAttr());
                builder.setItemNum((int) type.getValue());
            });
            dungeonInfoService.update(dungeonInfo);
        } else if (dungeon.getEventType() == DungeonEvent.HP_EVENT.getEventType() || dungeon.getEventType() == DungeonEvent.DISPEL_EVENT.getEventType()) {// 生命药水事件

            CShelterEventItem cShelterEventItem = DropUtil.randomDrop(shelterEventItemSysCache.getItemMap(dungeon.getEventType()), CShelterEventItem::getIdx, CShelterEventItem::getChance);
            ImmutableThing immutableThing = cShelterEventItem.getReward().get(0);
            dungeonBackpackService.addItem(playerContext.getId(), immutableThing.getItem_type(), (int) immutableThing.getItem_num());
            dungeonInfoService.addDungeonItem(playerContext.getId(), immutableThing.getItem_type(), (int) immutableThing.getItem_num());
            builder.setItemType(immutableThing.getItem_type());
            builder.setItemNum((int) immutableThing.getItem_num());

        } else if (dungeon.getEventType() == DungeonEvent.SUMMON_SHOP_EVENT.getEventType()) {// 召唤商店事件
            dungeonBackpackService.addItem(playerContext.getId(), (int) dungeon.getEventDetail(), 1);
            dungeonInfoService.addDungeonItem(playerContext.getId(), (int) dungeon.getEventDetail(), 1);
            builder.setItemType((int) dungeon.getEventDetail());
            builder.setItemNum(1);
        }
        // 修改该网格信息
        dungeon.setEventDetail(0);
        dungeonService.update(dungeon);

        builder.setStatus(0);
        playerContext.write(CmdCode._24014, builder.build());
    }

    /**
     * 地牢宝箱打开
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._24016)
    public void dungeonOpenBox(PlayerContext playerContext, DungeonGMsg.GReqDungeonOpenBox msg) {
        DungeonGMsg.GResDungeonOpenBox.Builder builder = DungeonGMsg.GResDungeonOpenBox.newBuilder();
        builder.setGridX(msg.getGridX());
        builder.setGridY(msg.getGridY());
        Dungeon dungeon = dungeonService.selectOne(playerContext.getId(), msg.getGridX(), msg.getGridY());

        Asserts.isTrue(shelterEventFreeBoxSysCache.getEventIdList().contains(dungeon.getEventType()) ||
                        dungeon.getEventType() == DungeonEvent.KEY_BOX_EVENT.getEventType(), ErrorCode.SHELTER_EVENT_ERROR.getValue(),
                "非宝箱类型网格。x: " + msg.getGridX() + " y: " + msg.getGridY());

        Asserts.isTrue(dungeon.getEventDetail() != 0, ErrorCode.SHELTER_BOX_REWARD.getValue(), "网格宝箱已领取");

        ImmutableThing immutableThing = null;
        if (shelterEventFreeBoxSysCache.getEventIdList().contains(dungeon.getEventType())) {//免费宝箱事件

            CShelterEventFreeBox shelterEventFreeBox = shelterEventFreeBoxSysCache.getOrThrow((int) dungeon.getEventDetail());
            immutableThing = shelterEventFreeBox.getReward().get(0);

        } else if (dungeon.getEventType() == DungeonEvent.KEY_BOX_EVENT.getEventType()) {//钥匙宝箱事件

            Asserts.isTrue(dungeonBackpackService.delitem(playerContext.getId(), DungeonItemEnum.BOX_KEY.getItemType(), 1),
                    ErrorCode.SHELTER_ITEM_ERROR.getValue(), "庇护所宝箱钥匙不足");

            CShelterEventKeyBox shelterEventKeyBox = shelterEventKeyBoxSysCache.getOrThrow((int) dungeon.getEventDetail());
            immutableThing = shelterEventKeyBox.getReward().get(0);

        }

        Asserts.isTrue(immutableThing != null, ErrorCode.CONFIG_DATA_ERROR.getValue(), "宝箱奖励内容为空。宝箱事件类型：" + dungeon.getEventType());

        thingService.add(playerContext.getId(), immutableThing, GameEvent.DUNGEON, NoticeType.TIPS);
        builder.setItemType(immutableThing.getItem_type());
        builder.setItemNum((int) immutableThing.getItem_num());
        //记录收益
        dungeonInfoService.addDungeonItem(playerContext.getId(),
                immutableThing.getItem_type(), (int) immutableThing.getItem_num());

        // 修改该网格信息
        dungeon.setEventDetail(0);
        dungeonService.update(dungeon);

        playerContext.write(CmdCode._24016, builder.build());
    }

    /**
     * 购买商店商品
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._24021)
    public void buyShopCommodity(PlayerContext playerContext, DungeonGMsg.GReqDungeonShopBuy msg) {
        DungeonGMsg.GResDungeonShopBuy.Builder builder = DungeonGMsg.GResDungeonShopBuy.newBuilder();
        builder.setIndex(msg.getIndex());
        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());
        DungeonShopItem dungeonShopItem = null;
        for (DungeonShopItem model : dungeonInfo.getShopItemList()) {
            if (model.getIndex() == msg.getIndex()) {
                dungeonShopItem = model;
                break;
            }
        }//end for
        if (dungeonShopItem == null || dungeonShopItem.getIsBuy() == 1) {
            builder.setStatus(0);
            playerContext.write(CmdCode._24021, builder.build());
            return;
        }
        CShelterShopPrize cModel = shelterShopPrizeSysCache.getOrThrow(dungeonShopItem.getItemId());
        thingService.cost(playerContext.getId(), cModel.getCost(), GameEvent.DUNGEON_SHOP_BUY);
        thingService.add(playerContext.getId(), cModel.getItem(), GameEvent.DUNGEON_SHOP_BUY);
        dungeonShopItem.setIsBuy(1);
        dungeonInfoService.update(dungeonInfo);
        builder.setStatus(1);
        playerContext.write(CmdCode._24021, builder.build());
        eventBus.post(DungeonShopEvent.of(playerContext.getId(), cModel.getIdx(), cModel.getCost(), cModel.getItem()));
    }

    /**
     * 地牢召唤商店
     */
    @CMD(id = CmdCode._24022)
    public void dungeonShopAdd(PlayerContext playerContext, GReqDungeonShopAdd msg) {
        DungeonGMsg.GResDungeonShopAdd.Builder builder = DungeonGMsg.GResDungeonShopAdd.newBuilder();
        if (!dungeonBackpackService.delitem(playerContext.getId(), DungeonItemEnum.SHOP_AGENTIA.getItemType(), 1)) {
            builder.setStatus(0);
            playerContext.write(CmdCode._24022, builder.build());
            return;
        }
        long shopId = System.currentTimeMillis() * 100;
        CShelterShopPrize cModel = dungeonInfoService.insertShopCommodity(playerContext.getId(), shopId, 1);
        builder.setDiscount(cModel.getDiscount());
        for (ImmutableThing cost : cModel.getCost()) {
            builder.setCostType(cost.getItem_type());
            builder.setCostNum((int) cost.getItem_num());
        }
        for (ImmutableThing reward : cModel.getItem()) {
            builder.setItemType(reward.getItem_type());
            builder.setItemNum((int) reward.getItem_num());
        }
        builder.setStatus(1);
        builder.setShopId(shopId);
        builder.setIndex(dungeonInfoService.selectMaxIndex(playerContext.getId()));
        playerContext.write(CmdCode._24022, builder.build());
    }

    /**
     * 地牢战斗结算
     */
    @CMD(id = CmdCode._24031, entry = EntryType.MAIN_DUNGEON)
    public void dungeonBattleNPCEnd(PlayerContext playerContext, DungeonGMsg.GReqDungeonBattleEnd msg) {
        DungeonGMsg.GResDungeonBattleEnd.Builder builder = DungeonGMsg.GResDungeonBattleEnd.newBuilder();

        DungeonInfo dungeonInfo = dungeonInfoService.select(playerContext.getId());

        Asserts.isTrue(dungeonInfo.getBattleMap().get(msg.getHeroIndex()) != null, ErrorCode.SHELTER_LINEUP_INDEX_LINEUP_NULL.getValue(),
                () -> "hero_index: " + msg.getHeroIndex() + ", rid: " + playerContext.getId());

        /*Asserts.isTrue(dungeonInfo.getBattleMap().get(msg.getHeroIndex()).getHeros().stream().mapToLong(HeroVo::getHp).sum() != 0, ErrorCode.SHELTER_HERO_NOT_HP.getValue(),
                () -> "hero_index: " + msg.getHeroIndex() + ", hero_hp: " + 0 + ", rid: " + playerContext.getId());*/

        Dungeon dungeon = dungeonService.getMonsterDungeon(playerContext.getId(), msg.getMonsterLevel());

        Asserts.isTrue(dungeon != null, ErrorCode.SHELTER_MONSTER_NOT_HP.getValue(),
                () -> "monster_level: " + msg.getMonsterLevel() + ", monster_hp: " + 0 + ", rid: " + playerContext.getId());

        /*Asserts.isTrue(dungeon.getBattlerVo().getHeros().stream().mapToLong(HeroVo::getHp).sum() != 0, ErrorCode.SHELTER_MONSTER_NOT_HP.getValue(),
                () -> "monster_level: " + msg.getMonsterLevel() + ", monster_hp: " + 0 + ", rid: " + playerContext.getId());*/

        Role role = roleService.getOrThrow(playerContext.getId());

        //英雄
        BattlerDo attackerDo = battleTemplate.queryBattler(dungeonInfo.getBattleMap().get(msg.getHeroIndex()), role.getNick()
                , Faction.ATTACKER, UnitType.HERO);
        //怪物

        CItem cItem = itemSysCache.getOrThrow(dungeon.getBattlerVo().getHeros().get(0).getHeroId());

        CLanguage language = languageSysCache.getByKey(cItem.getName());
        BattlerDo defenderDo = battleTemplate.queryBattler(dungeon.getBattlerVo(), languageHelper.getLanguageBy(language), Faction.DEFENDER, UnitType.MOSTER);
        //构建战场
        BattleCommand command = BattleCommand.createOf(BattleType.SHELTER, attackerDo, defenderDo);

        commandBus.invoke(command);

        BattleResult result = command.getResult();

        if (result.isWin()) {
            //更新击杀数
            dungeonInfo.setWinTimes(dungeonInfo.getWinTimes() + 1);
            //更新网格数据
            dungeon.setEventDetail(0);
            dungeonService.update(dungeon);
        }

        BattlerVo defenderVo = result.buildDefenderVo();
        defenderVo.saveTriggerTimes();//保存复活已触发次数
        defenderVo.saveEnergy();    //保存能量到下一次战斗
        dungeon.setBattlerVo(defenderVo);
        dungeonService.update(dungeon);

        BattlerVo attackerVo = result.buildAttackerVo();
        attackerVo.saveTriggerTimes();  //保存复活已触发次数
        attackerVo.saveEnergy();    //保存能量到下一次战斗
        dungeonInfo.getBattleMap().put(msg.getHeroIndex(), attackerVo);
        dungeonInfoService.update(dungeonInfo);

        builder.setReport(result.getReport());
        playerContext.write(CmdCode._24031, builder.build());

        if (result.isWin()) {
            if (CollectionUtil.isNotEmpty(attackerDo.getHeros())) {
                eventBus.post(DungeonBattleEndEvent.of(playerContext.getId(), attackerDo.getHeros().get(0).getHeroId(), msg.getMonsterLevel(), result.isWin()));
            }
        }
    }

    /**
     * 清除地牢数据
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.CLEAN_SHELTER)
    public void gmCleanShelter(Role role, List<String> param) {
        DungeonInfo model = dungeonInfoService.select(role.getId());
        dungeonInfoService.resetDungeonInfo(model);
        dungeonService.resetDungeon(model);
        dungeonBackpackService.resetBackPack(role.getId());

        DungeonGMsg.GResRemoveShelterInfo.Builder builder = DungeonGMsg.GResRemoveShelterInfo.newBuilder();
        contextManager.write(role.getId(), CmdCode._24000, builder.build());
    }

}
