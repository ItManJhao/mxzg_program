package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.config.excel.constant.BlessingConst;
import com.ayjs.mxzg.config.excel.constant.ClanConst;
import com.ayjs.mxzg.config.excel.constant.ClanWarConst;
import com.ayjs.mxzg.config.excel.constant.ClanWorldBossConst;
import com.ayjs.mxzg.config.excel.constant.FriendConst;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.excel.constant.IdleConst;
import com.ayjs.mxzg.config.excel.constant.ProphecyConst;
import com.ayjs.mxzg.config.excel.constant.PvpConst;
import com.ayjs.mxzg.config.excel.constant.TavernConst;
import com.ayjs.mxzg.config.excel.constant.TowerConst;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.config.excel.entity.CSystem;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Slf4j
@Component
public class SystemSysCache extends BaseExcelCache<CSystem> {

    private Map<String, CSystem> nameMap;

    private int heroSpaceInitial;
    private int elf1UnlockLevel;
    private int elf2UnlockStar;
    private int elfCombineReturn;
    private int clanBossFreeTimes;

    private int clanBossTimesBuyLimit;
    private String clanBossPlayExp;
    private ImmutableList<ImmutableThing> createClanGem;

    private String buyGoldRefresh;
    private int createClanTotalChargeRequire;
    // 解析后的数据
    @Getter
    private List<LocalTime> bugGoldRefreshList = new ArrayList<>();

    private int dailyMissionFreeTickets;
    private int dailyMissionTicketsCostGem;
    private ImmutableList<ImmutableThing> dailyGift;
    private int shelterHealing;
    private int shelterItemUseLimit;
    private int shelterLevelResetNum;
    private int shelterLastDay;
    private long worshipGetGold;

    private int promotionBlessPoolTargetRewardRound;
    private int promotionAdvSummonTargetRewardRound;
    private int promotionSpeedFightGetFreeTimes;
    private int promotionInvestShowTime;
    private int promotionInvestDisappearTime;
    private int clanRejoinTime;
    private int clanSecedeTime;
    private ImmutableList<ImmutableThing> guideInitialReward;
    private Integer[] marketInitialItem;

    private int firstOrdinaryLottery;
    @Getter
    private int secondSeniorLottery;
    /**
     * 高级第一抽固定产出英雄
     */
    @Getter
    private int firstSeniorLottery;
    private Integer[] heroRebornStar;

    /**
     * 诸神之战挑战卷费用
     */
    @Getter
    private int promotionPveItemNeedGem;
    /**
     * 诸神之战挂机单位时间
     */
    @Getter
    private int promotionPveGetItemUnitTime;
    /**
     * 诸神之战挑战消耗
     */
    @Getter
    private List<ImmutableThing> promotionPveFightNeedItem;
    /**
     * 诸神之战挂机产出，购买产出
     */
    @Getter
    private List<ImmutableThing> promotionPveItemReward;

    private int rechargeDaysAtLeastRmb;

    @Getter
    private int higherRechargeDaysAtLeastRmb;
    /**
     * 聊天限制，根据玩家的主等级
     */
    @Getter
    private int chatUnlockMainLevel;
    /**
     * 每次发送聊天消息至少相隔的秒数
     */
    @Getter
    private int chatFrequencyAtLeast;

    @Getter
    private int chatLimitSize;

    /**
     * 跨服开启时间
     */
    private String crossServerStartTime;
    /**
     * 跨服重组间隔的周数
     */
    private int crossServerRegroupIntervalWeek;
    /**
     * 跨服老服组世界等级
     */
    private int crossServerOldGroupWorldLevel;

    /**
     * 旧服分组的开服天数限制
     */
    private int oldGroupOpenServerDay;
    /**
     * 旧的跨服分组大小
     */
    private int oldCrossServerGroupSize;
    /**
     * 新跨服分组大小
     */
    private int newCrossServerGroupSize;

    /**
     * 跨服周几重新分组
     */
    private int crossServerRegroupWeek;
    /**
     * 世界等级取决等级排名前N名
     */
    @Getter
    private int worldLevelPeople;

    /**
     * 跨服天梯-每天免费挑战次数
     */
    @Getter
    private int crossServerLadderFreeTimes;
    /**
     * 跨服天梯-每周开启和结束时间点，从周一0点开启算起
     */
    @Getter
    private Integer[] crossServerLadderOpenTime;
    /**
     * 跨服天梯-英雄圣殿点赞获得奖励
     */
    @Getter
    private List<ImmutableThing> crossServerLadderLikeReward;

    /**
     * 跨服天梯-每天免费刷新cd
     */
    @Getter
    private int crossServerLadderMatchFreshCd;
    /**
     * 跨服天梯-我的战斗保留数量
     */
    @Getter
    private int crossServerLadderMyRecord;
    /**
     * 大神风采保留数量
     */
    @Getter
    private int crossServerLadderGodRecord;
    /**
     * 跨服天梯-匹配排名分界线，高于本排名则在1到当前排名+3中随机5个玩家，否则就读serverladdermatch.xlsx
     */
    @Getter
    private int crossServerLadderMatchSeparateRankA;
    /**
     * 跨服天梯-匹配排名分界线B，排名高于6则在1到6中随机5个玩家，否则就读serverladdermatch.xlsx
     */
    @Getter
    private int crossServerLadderMatchSeparateRankB;
    /**
     * 跨服天梯-高于排名分界线的系数3，则在1到当前排名+3中随机5个玩家
     */
    @Getter
    private int crossServerLadderMatchSeparateRatio;

    /**
     * 活跃玩家需要的天数
     */
    @Getter
    private int activePlayerNeedLoginDays;

    /**
     * 旧服分组活跃玩家
     */
    @Getter
    private int oldGroupActivePlayers;

    /**
     * 新服分组活跃玩家
     */
    @Getter
    private int newGroupActivePlayers;

    /**
     * 每页请求英雄数量
     */
    @Getter
    private int heroPageNum;

    /**
     * 多次修改昵称费用
     */
    @Getter
    private ImmutableList<ImmutableThing> nickChangeCost;

    /**
     * 英雄跳升级别功能在x级别以下生效
     */
    @Getter
    private int heroLevelJumpLimit;
    /**
     * 在资源足够的前提下，英雄一次最多跳升x级
     */
    @Getter
    private int heroLevelJumpMax;

    @Getter
    private int equipmentComposeQuicklyLevel;

    @Getter
    private int mailDeleteDay;
    @Getter
    private int mailRefuseLossDay;
    @Getter
    private int runePageSize;

    /***
     * 勇者试炼选择难度所需历史最高战力
     */
    @Getter
    private int adventureLevelChooseScore;
    /***
     * 勇者试炼可助战英雄数量
     */
    @Getter
    private int adventureAssistNum;

    /***
     * 勇者试炼可选择助战英雄数量

     */
    @Getter
    private int adventureGetAssistNum;

    /***
     *   勇者试炼精英难度需要战力
     */
    @Getter
    private int adventureSecondLevelNeedScore;

    /***
     *  勇者试炼噩梦难度需要战力
     */
    @Getter
    private int adventureThirdLevelNeedScore;

    /***
     *  勇者试炼好友助战战力万分比范围
     */
    @Getter
    private int adventureAssistScoreLimit;

    /**
     * 许愿池稀有公告上限条数
     */
    @Getter
    private int wishpoolRareBroadcastNum;
    /**
     * 许愿池免费次数刷新时间
     */
    @Getter
    private int wishpoolFreeRefreshCd;
    @Getter
    private ImmutableList<ImmutableThing> adventureAssistReward;
    @Getter
    private int blacklistMaxNum;
    /**
     * 评论分享有礼
     */
    @Getter
    private List<ImmutableThing> commentsReward;

    @Getter
    private int initialExperiencePoints;
    @Getter
    private int initialStage;
    @Getter
    private int skipArrayWaitingTime;
    @Getter
    private int matchingWaitingTime;
    @Getter
    private int openTotemsHeroStar;//图腾开启英雄星级
    @Getter
    private int openTotemsRoleLevel;//图腾开启角色等级
    @Getter
    private int promotionQsqRolelv;//七神器开启角色等级限制
    @Getter
    private int promotionZsjtRolelv;//诸神祭坛开启角色等级限制
    @Getter
    private int promotionZsjtMoneyBuynum;//诸神祭坛每天货币购买次数限制
    @Getter
    private int promotionZsjtBatchLuckdrawnum;//诸神祭坛批量抽奖次数配置
    @Getter
    private int chatRepeatedTimes;//聊天重复次数
    @Getter
    private int chatRepeatedExpireTime;//聊天重复次数
    @Getter
    private int heroJobMax;//英雄最大职业号

    /**
     * 多次修改昵称所耗道具
     */
    @Getter
    private ImmutableList<ImmutableThing> consumptionProps;

    /**
     * 公会修改昵称所耗道具
     */
    @Getter
    private ImmutableList<ImmutableThing> clanRenamingCard;

    @Getter
    private int playerNameLength = 0;
    @Getter
    private int clanNameLength = 0;
    @Getter
    private Integer[] magicWandStrengthenUnlockLevel;
    @Getter
    private int magicWandBaptismResetProbability = 0;
    @Getter
    private int openMagicWandHeroStar = 0;
    @Getter
    private int magicTowerKingTitleId = 0;
    @Getter
    private int magicTowerKingBuyGemId = 0;
    @Getter
    private int magicTowerKingGiftStar = 0;
    @Getter
    private int openSkinStoreLevel = 0;



    @Override
    public String getFileName() {
        return "system";
    }

    @Override
    protected void loadAfterReady() {
        this.nameMap = this.fillOneLayerMap(CSystem::getKey);
        heroSpaceInitial = parseInt("hero_space_initial");
        elf1UnlockLevel = parseInt("elf_1_unlock_level");
        elf2UnlockStar = parseInt("elf_2_unlock_star");
        elfCombineReturn = parseInt("elf_combine_return");
        clanBossFreeTimes = parseInt("clan_boss_free_times");
        clanBossTimesBuyLimit = parseInt("clan_boss_times_buy_limit");
        clanBossPlayExp = this.nameMap.get("clan_boss_play_exp").getValue();

        createClanGem = ImmutableThingUtil.fromJson(this.nameMap.get("create_clan_gem").getValue());

        buyGoldRefresh = this.nameMap.get("buy_gold_refresh").getValue();
        if (Objects.nonNull(buyGoldRefresh)) {
            String[] split = buyGoldRefresh.split(",");
            bugGoldRefreshList.clear();
            Arrays.stream(split).sorted(Comparator.comparing(String::new)).forEach(str -> {
                bugGoldRefreshList.add(LocalTime.parse(str));
            });
        }

        dailyGift = ImmutableThingUtil.fromJson(this.nameMap.get("daily_gift").getValue());
        dailyMissionFreeTickets = parseInt("daily_mission_free_tickets");
        dailyMissionTicketsCostGem = parseInt("daily_mission_tickets_cost_gem");
        shelterHealing = parseInt("shelter_healing");
        shelterItemUseLimit = parseInt("shelter_item_use_limit");
        shelterLevelResetNum = parseInt("shelter_level_reset_num");
        shelterLastDay = parseInt("shelter_last_day");

        worshipGetGold = parseInt("worship_get_gold");

        createClanTotalChargeRequire = parseInt("create_clan_total_charge_require");

        promotionPveItemNeedGem = parseInt("promotion_pve_item_need_gem");
        promotionPveGetItemUnitTime = parseInt("promotion_pve_get_item_unittime");
        promotionPveFightNeedItem = ImmutableThingUtil.fromJson(this.nameMap.get("promotion_pve_fight_need_item").getValue());
        promotionPveItemReward = ImmutableThingUtil.fromJson(this.nameMap.get("promotion_pve_item_reward").getValue());
        promotionBlessPoolTargetRewardRound = parseInt("promotion_bless_pool_target_reward_round");
        promotionAdvSummonTargetRewardRound = parseInt("promotion_adv_summon_target_reward_round");
        promotionSpeedFightGetFreeTimes = parseInt("promotion_speed_fight_get_free_times");
        promotionInvestShowTime = parseInt("promotion_invest_show_time");
        promotionInvestDisappearTime = parseInt("promotion_invest_disappear_time");


        String marketInitialItemStr = this.nameMap.get("market_initial_item").getValue();
        marketInitialItem = StringUtil.stringToArray(marketInitialItemStr, "_", Integer.class);

        String heroRebornStarStr = this.nameMap.get("hero_reborn_star").getValue();
        heroRebornStar = StringUtil.stringToArray(heroRebornStarStr, "_", Integer.class);

        rechargeDaysAtLeastRmb = parseInt("recharge_days_at_least_rmb");
        higherRechargeDaysAtLeastRmb = parseInt("higher_recharge_days_at_least_rmb");
        chatUnlockMainLevel = parseInt("chat_unlock_main_level");
        chatFrequencyAtLeast = parseInt("chat_frequency_at_least");


        clanRejoinTime = parseInt("clan_rejoin_time");
        clanSecedeTime = parseInt("clan_secede_time");
        guideInitialReward = ImmutableThingUtil.fromJson(this.nameMap.get("guide_initial_reward").getValue());

        FriendConst.loadConst(this.nameMap);
        ClanWorldBossConst.loadConst(this.nameMap);
        ProphecyConst.loadConst(this.nameMap);
        HeroConst.loadConst(this.nameMap);
        ClanWarConst.loadConst(this.nameMap);
        PvpConst.loadConst(this.nameMap);
        TavernConst.loadConst(this.nameMap);
        TowerConst.loadConst(this.nameMap);
        BlessingConst.loadConst(this.nameMap);
        IdleConst.loadConst(this.nameMap);
        ClanConst.loadConst(this.nameMap);

        VideoConst.MAX_COUNT = parseInt("video_max_count");

        chatLimitSize = parseInt("chat_num");

        firstOrdinaryLottery = parseInt("first_ordinary_lottery");
        firstSeniorLottery = parseInt("first_senior_lottery");
        secondSeniorLottery = parseInt("second_senior_lottery");
        crossServerStartTime = this.nameMap.get("cross_server_start_time").getValue();
        crossServerRegroupIntervalWeek = parseInt("cross_server_regroup_interval_week");
        crossServerOldGroupWorldLevel = parseInt("cross_server_old_group_world_level");
        oldCrossServerGroupSize = parseInt("old_cross_server_group_size");
        newCrossServerGroupSize = parseInt("new_cross_server_group_size");
        crossServerRegroupWeek = parseInt("cross_server_regroup_week");
        oldGroupOpenServerDay = parseInt("cross_server_old_group_server_day");


        worldLevelPeople = parseInt("world_level_people");

        crossServerLadderFreeTimes = parseInt("cross_server_ladder_free_times");
        crossServerLadderMyRecord = parseInt("cross_server_ladder_my_record");
        crossServerLadderGodRecord = parseInt("cross_server_ladder_god_record");
        crossServerLadderMatchFreshCd = parseInt("cross_server_ladder_match_fresh_cd");
        crossServerLadderMatchSeparateRankA = parseInt("cross_server_ladder_match_separate_rankA");
        crossServerLadderMatchSeparateRankB = parseInt("cross_server_ladder_match_separate_rankB");
        crossServerLadderMatchSeparateRatio = parseInt("cross_server_ladder_match_separate_ratio");
        activePlayerNeedLoginDays = parseInt("player_need_login");
        newGroupActivePlayers = parseInt("new_group_active_players");
        oldGroupActivePlayers = parseInt("old_group_active_players");

        String crossServerLadderOpenTimeStr = this.nameMap.get("cross_server_ladder_open_time").getValue();
        crossServerLadderOpenTime = StringUtil.stringToArray(crossServerLadderOpenTimeStr, "_", Integer.class);

        crossServerLadderLikeReward = ImmutableThingUtil.fromJson(this.nameMap.get("cross_server_ladder_like_reward").getValue());

        heroPageNum = parseInt("hero_page_num");
        nickChangeCost = ImmutableThingUtil.fromJson(this.nameMap.get("nick_change_cost").getValue());

        heroLevelJumpLimit = parseInt("hero_level_jump_limit");
        heroLevelJumpMax = parseInt("hero_level_jump_max");

        equipmentComposeQuicklyLevel = parseInt("equipment_compose_quickly_level");

        mailDeleteDay = parseInt("mail_delete_day");
        mailRefuseLossDay = parseInt("mail_refuse_loss_day");

        runePageSize = parseInt("rune_page_size");
        adventureLevelChooseScore = parseInt("adventure_level_choose_score");
        adventureAssistNum = parseInt("adventure_assist_num");
        adventureGetAssistNum = parseInt("adventure_get_assist_num");
        adventureSecondLevelNeedScore = parseInt("adventure_second_level_need_score");
        adventureThirdLevelNeedScore = parseInt("adventure_third_level_need_score");
        adventureAssistScoreLimit = parseInt("adventure_assist_score_limit");
        adventureAssistReward = ImmutableThingUtil.fromJson(this.nameMap.get("adventure_assist_reward").getValue());

        blacklistMaxNum = parseInt("blacklist_max_num");

        wishpoolRareBroadcastNum = parseInt("wishpool_rare_broadcast_num");
        wishpoolFreeRefreshCd = parseInt("wishpool_free_refresh_cd");
        initialExperiencePoints = parseInt("initial_experience_points");
        initialStage = parseInt("initial_stage");
        skipArrayWaitingTime = parseInt("skip_array_waiting_time");
        matchingWaitingTime = parseInt("matching_waiting_time");

        commentsReward = ImmutableThingUtil.fromJson(this.nameMap.get("comments_reward").getValue());
        openTotemsHeroStar = parseInt("open_totems_hero_star");
        openTotemsRoleLevel = parseInt("open_totems_role_level");

        promotionQsqRolelv = parseInt("promotion_qsq_rolelv");
        promotionZsjtRolelv = parseInt("promotion_zsjt_rolelv");
        promotionZsjtMoneyBuynum = parseInt("promotion_zsjt_money_buynum");
        promotionZsjtBatchLuckdrawnum = parseInt("promotion_zsjt_batch_luckdrawnum");
        chatRepeatedTimes = parseInt("chat_repeated_times");
        chatRepeatedExpireTime = parseInt("chat_repeated_expire_time");
        heroJobMax = parseInt("hero_job_max");
        consumptionProps = ImmutableThingUtil.fromJson(this.nameMap.get("consumption_props").getValue());
        clanRenamingCard = ImmutableThingUtil.fromJson(this.nameMap.get("clan_renaming_card").getValue());
        playerNameLength = parseInt("player_name_length");
        clanNameLength = parseInt("clan_name_length");

        magicWandStrengthenUnlockLevel = StringUtil.stringToArray(this.nameMap.get("magic_wand_strengthen_unlock_level").getValue(), "_", Integer.class);
        magicWandBaptismResetProbability = parseInt("magic_wand_baptism_reset_probability");
        openMagicWandHeroStar = parseInt("open_magic_wand_hero_star");
        magicTowerKingTitleId = parseInt("magic_tower_king_title_id");
        magicTowerKingBuyGemId = parseInt("magic_tower_king_buy_gem_id");
        magicTowerKingGiftStar = parseInt("magic_tower_king_gift_star");
        openSkinStoreLevel = parseInt("open_skin_store_level");
        ExcelDictionaryCache.load(this.nameMap);
    }

    private int parseInt(String key) {
        CSystem system = this.nameMap.get(key);
        if (Objects.isNull(system)) {
            return 0;
        }
        try {
            return Integer.parseInt(system.getValue());
        } catch (Exception e) {
            log.error("参数{}解释错误，无法转化为int value:{}", key, system.getValue());
        }
        return 0;
    }

    public static int parseInt0(Map<String, CSystem> nameMap, String key) {
        CSystem cSystem = nameMap.get(key);
        if (Objects.isNull(cSystem)) {
            return 0;
        }
        try {
            return Integer.parseInt(cSystem.getValue());
        } catch (Exception e) {
            log.error("参数{}解释错误，无法转化为int value:{}", key, cSystem.getValue());
        }
        return 0;
    }

    public int getPromotionInvestShowTime() {
        return promotionInvestShowTime;
    }

    public int getPromotionInvestDisappearTime() {
        return promotionInvestDisappearTime;
    }

    public int getCreateClanTotalChargeRequire() {
        return createClanTotalChargeRequire;
    }

    public Integer[] getMarketInitialItem() {
        return marketInitialItem;
    }

    public Integer[] getHeroRebornStar() {
        return heroRebornStar;
    }

    public int getClanRejoinTime() {
        return clanRejoinTime;
    }

    public int getHeroSpaceInitial() {
        return heroSpaceInitial;
    }

    public int getFirstOrdinaryLottery() {
        return firstOrdinaryLottery;
    }

    public int getPromotionSpeedFightGetFreeTimes() {
        return promotionSpeedFightGetFreeTimes;
    }

    public int getPromotionBlessPoolTargetRewardRound() {
        return promotionBlessPoolTargetRewardRound;
    }

    public ImmutableList<ImmutableThing> getGuideInitialReward() {
        return guideInitialReward;
    }

    public int getPromotionAdvSummonTargetRewardRound() {
        return promotionAdvSummonTargetRewardRound;
    }

    public int getDailyMissionTicketsCostGem() {
        return dailyMissionTicketsCostGem;
    }

    public int getShelterHealing() {
        return shelterHealing;
    }

    public int getShelterItemUseLimit() {
        return shelterItemUseLimit;
    }

    public int getClanSecedeTime() {
        return clanSecedeTime;
    }

    public int getClanBossTimesBuyLimit() {
        return clanBossTimesBuyLimit;
    }

    public int getElf1UnlockLevel() {
        return elf1UnlockLevel;
    }

    public ImmutableList<ImmutableThing> getCreateClanGem() {
        return createClanGem;
    }

    public int getDailyMissionFreeTickets() {
        return dailyMissionFreeTickets;
    }

    public int getElf2UnlockStar() {
        return elf2UnlockStar;
    }

    public String getBuyGoldRefresh() {
        return buyGoldRefresh;
    }

    public String getClanBossPlayExp() {
        return clanBossPlayExp;
    }


    public Map<String, CSystem> getNameMap() {
        return nameMap;
    }

    protected void setNameMap(Map<String, CSystem> nameMap) {
        this.nameMap = nameMap;
    }

    public int getElfCombineReturn() {
        return elfCombineReturn;
    }

    public int getClanBossFreeTimes() {
        return clanBossFreeTimes;
    }

    public int getShelterLevelResetNum() {
        return shelterLevelResetNum;
    }

    public int getShelterLastDay() {
        return shelterLastDay;
    }

    public long getWorshipGetGold() {
        return worshipGetGold;
    }

    public ImmutableList<ImmutableThing> getDailyGift() {
        return dailyGift;
    }

    public int getRechargeDaysAtLeastRmb() {
        return rechargeDaysAtLeastRmb;
    }

    public String getCrossServerStartTime() {
        return crossServerStartTime;
    }

    public int getCrossServerRegroupIntervalWeek() {
        return crossServerRegroupIntervalWeek;
    }

    public int getCrossServerRegroupWeek() {
        return crossServerRegroupWeek;
    }

    public int getCrossServerOldGroupWorldLevel() {
        return crossServerOldGroupWorldLevel;
    }

    public int getOldCrossServerGroupSize() {
        return oldCrossServerGroupSize;
    }

    public int getNewCrossServerGroupSize() {
        return newCrossServerGroupSize;
    }

    public int getOldGroupOpenServerDay() {
        return oldGroupOpenServerDay;
    }
}