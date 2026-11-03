//package com.ayjs.mxzg.gameserver.module.operatorValue.observer;
//
//import com.ayjs.mxzg.common.event.annotation.Observer;
//import com.ayjs.mxzg.common.event.annotation.Subscribe;
//import com.ayjs.mxzg.common.event.bus.EventBus;
//import com.ayjs.mxzg.common.util.time.TimeDateUtil;
//import com.ayjs.mxzg.config.excel.cache.EquipmenttypeSysCache;
//import com.ayjs.mxzg.config.excel.entity.CEquipmenttype;
//import com.ayjs.mxzg.gameserver.module.backpack.constant.EquipColourStage;
//import com.ayjs.mxzg.gameserver.module.backpack.event.GemCostEvent;
//import com.ayjs.mxzg.gameserver.module.backpack.event.MakeEquipEvent;
//import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
//import com.ayjs.mxzg.gameserver.module.buygold.event.BuyGoldEvent;
//import com.ayjs.mxzg.gameserver.module.clan.event.ClanChangeEvent;
//import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
//import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
//import com.ayjs.mxzg.gameserver.module.clan.event.ClanSkillUpEvent;
//import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
//import com.ayjs.mxzg.gameserver.module.friend.event.FriendGiveEvent;
//import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
//import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
//import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
//import com.ayjs.mxzg.gameserver.module.hero.struct.SummonType;
//import com.ayjs.mxzg.gameserver.module.operatorValue.constant.OperatorType;
//import com.ayjs.mxzg.gameserver.module.operatorValue.event.OperatorValueChangeEvent;
//import com.ayjs.mxzg.gameserver.module.operatorValue.service.OperatorValueService;
//import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
//import com.ayjs.mxzg.gameserver.module.prophetSummon.event.HeroChangeEvent;
//import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
//import com.ayjs.mxzg.gameserver.module.role.domain.Role;
//import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
//import com.ayjs.mxzg.gameserver.module.role.event.MaxFightingEvent;
//import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
//import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
//import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
//import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;
//import com.ayjs.mxzg.gameserver.module.shop.event.ShopBuyEvent;
//import com.ayjs.mxzg.gameserver.module.task.event.AlterHeroEvent;
//import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
//import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Autowired;
//
//import java.util.Objects;
//
///**
// * @description:
// * @author: CWJ
// * @date: 2019/10/14 10:14
// */
//@Observer
//@Slf4j
//public class OperatorObserver {
//    @Autowired
//    private RoleService roleService;
//    @Autowired
//    OperatorValueService operatorValueService;
//    @Autowired
//    EventBus eventBus;
//    @Autowired
//    private EquipmenttypeSysCache equipmenttypeSysCache;
//
//    @Subscribe
//    public void login(LoginEvent event) {
//        long rid = event.getRid();
//        Role role = roleService.getOrThrow(rid);
//        if (TimeDateUtil.isToday(role.getLastOfflineTime())) {
//            return;
//        }
//        int newValue = operatorValueService.addProcess(rid, OperatorType.ROLE_LOGIN, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.ROLE_LOGIN, newValue, 1));
//    }
//
//    @Subscribe
//    public void zeroTime(ZeroTimeEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.ROLE_LOGIN, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.ROLE_LOGIN, newValue, 1));
//    }
//
//    //TODO 竞技场计数
//
//    //TODO 在线时长
//    @Subscribe
//    public void logout(LoginEvent event) {
//        long rid = event.getRid();
//        Role role = roleService.getOrThrow(rid);
//        int onlineTime = TimeDateUtil.getCurrentTimeInt() - TimeDateUtil.toSecond(role.getLastLoginTime());
//        int newValue = operatorValueService.addProcess(rid, OperatorType.ROLE_ONLINE, onlineTime);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.ROLE_ONLINE, newValue, onlineTime));
//    }
//
//    @Subscribe
//    public void friendGive(FriendGiveEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.GIVE_FRIEND, event.getGiveCount());
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.GIVE_FRIEND, newValue, event.getGiveCount()));
//    }
//
//    @Subscribe
//    public void heroSummon(HeroSummonEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.HERO_SUMMON, event.getSummonCount());
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.HERO_SUMMON, newValue, event.getSummonCount()));
//        if (event.getType() == SummonType.HIGH) {//高抽成就
//            newValue = operatorValueService.addProcess(rid, OperatorType.senior, event.getSummonCount());
//            eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.senior, newValue, event.getSummonCount()));
//        }
//    }
//
//    @Subscribe
//    public void clanBossChallenge(ClanDungeonChallengeEvent event) {
//        long rid = event.getRid();
//
//        int newValue = operatorValueService.addProcess(rid, OperatorType.CHALLENGE_CLAN_BOSS, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.CHALLENGE_CLAN_BOSS, newValue, 1));
//
//        newValue = operatorValueService.addProcess(rid, OperatorType.BATTLE_CLAN_BOSS, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.BATTLE_CLAN_BOSS, newValue, 1));
//    }
//
//    @Subscribe
//    public void tavernTaskStart(TavernTaskStartEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.TAWERN_TASK, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.TAWERN_TASK, newValue, 1));
//    }
//
//    @Subscribe
//    public void heroGet(HeroGetEvent event) {
//        long rid = event.getRid();
//
//        event.getHeros().forEach(hero -> {
//            OperatorType type = null;
//            switch (hero.getStar()) {
//                case 4:
//                    type = OperatorType.FOUR_STAR_HERO;
//                    break;
//                case 5:
//                    type = OperatorType.FIVE_STAR_HERO;
//                    break;
//                case 6:
//                    type = OperatorType.SIX_STAR_HERO;
//                    break;
//                case 7:
//                    type = OperatorType.SEVEN_STAR_HERO;
//                    break;
//                case 8:
//                    type = OperatorType.EIGHT_STAR_HERO;
//                    break;
//                case 9:
//                    type = OperatorType.NINE_STAR_HERO;
//                    break;
//                case 10:
//                    type = OperatorType.TEN_STAR_HERO;
//                    break;
//                case 11:
//                    type = OperatorType.ELEVEN_STAR_HERO;
//                    break;
//                case 12:
//                    type = OperatorType.TWELVE_STAR_HERO;
//                    break;
//                case 13:
//                    type = OperatorType.THIRTEEN_STAR_HERO;
//                    break;
//                default:
//                    break;
//            }
//            if (type == null) {
//                return;
//            }
//            int newValue = operatorValueService.addProcess(rid, type, 1);
//            eventBus.post(OperatorValueChangeEvent.of(rid, type, newValue, 1));
//        });
//    }
//
//    /**
//     * 升星事件
//     *
//     * @param event
//     */
//    @Subscribe
//    public void heroUpStar(HeroStarUpEvent event) {
//        long rid = event.getHero().getRid();
//
//        OperatorType type = null;
//        switch (event.getHero().getStar()) {
//            case 4:
//                type = OperatorType.FOUR_STAR_HERO;
//                break;
//            case 5:
//                type = OperatorType.FIVE_STAR_HERO;
//                break;
//            case 6:
//                type = OperatorType.SIX_STAR_HERO;
//                break;
//            case 7:
//                type = OperatorType.SEVEN_STAR_HERO;
//                break;
//            case 8:
//                type = OperatorType.EIGHT_STAR_HERO;
//                break;
//            case 9:
//                type = OperatorType.NINE_STAR_HERO;
//                break;
//            case 10:
//                type = OperatorType.TEN_STAR_HERO;
//                break;
//            case 11:
//                type = OperatorType.ELEVEN_STAR_HERO;
//                break;
//            case 12:
//                type = OperatorType.TWELVE_STAR_HERO;
//                break;
//            case 13:
//                type = OperatorType.THIRTEEN_STAR_HERO;
//                break;
//            default:
//                break;
//        }
//        if (type == null) {
//            return;
//        }
//        int newValue = operatorValueService.addProcess(rid, type, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, type, newValue, 1));
//    }
//
//    @Subscribe
//    public void passTower(TowerPassEvent event) {
//        long rid = event.getRid();
//        int addValue = operatorValueService.setProcess(rid, OperatorType.TOWER_STAGE, event.getNewStage());
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.TOWER_STAGE, event.getNewStage(), addValue));
//    }
//
//    @Subscribe
//    public void heroChange(HeroChangeEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.HERO_SWOP, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.HERO_SWOP, newValue, 1));
//    }
//
//    @Subscribe
//    public void changePower(MaxFightingEvent event) {
//        long rid = event.getRid();
//        int addValue = operatorValueService.setProcess(rid, OperatorType.ROLE_FIGHTING, event.getMaxFighting());
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.ROLE_FIGHTING, event.getMaxFighting(), addValue));
//    }
//
//    @Subscribe
//    public void roleLvUp(RoleLvUpEvent event) {
//        long rid = event.getRid();
//        int addValue = operatorValueService.setProcess(rid, OperatorType.ROLE_LEVEL, event.getNewLv());
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.ROLE_LEVEL, event.getNewLv(), addValue));
//    }
//
//    @Subscribe
//    public void consumeGem(GemCostEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.GEM_CONSUME, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.GEM_CONSUME, newValue, 1));
//    }
//
//    /***
//     * 英雄献祭
//     * TODO
//     * @param event
//     */
//    @Subscribe
//    public void wish(BlessingPoolDoneEvent event) {
//        long rid = event.getRid();
//
//        OperatorType type = null;
//        switch (event.getType()) {
//            case Normal:
//                type = OperatorType.GENERAL_WISH;
//                break;
//            case Advance:
//                type = OperatorType.SENIOR_WISH;
//                break;
//            default:
//                break;
//        }
//        if (Objects.isNull(type)) {
//            return;
//        }
//        int newValue = operatorValueService.addProcess(rid, type, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, type, newValue, 1));
//    }
//
//    @Subscribe
//    public void joinClan(ClanChangeEvent event) {
//        long rid = event.getRid();
//        if (event.getNewClanId() > 0) {
//            int newValue = operatorValueService.addProcess(rid, OperatorType.JOIN_CLAN, 1);
//            eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.JOIN_CLAN, newValue, 1));
//        }
//    }
//
//    @Subscribe
//    public void clanDetonate(ClanDonateEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.CLAN_DONATE, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.CLAN_DONATE, newValue, 1));
//    }
//
//    /***
//     * 购买点金
//     * @param event
//     */
//    @Subscribe
//    public void buyGold(BuyGoldEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.BUY_GOLD, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.BUY_GOLD, newValue, 1));
//    }
//
//    /**
//     * 装备合成
//     *
//     * @param event
//     */
//    @Subscribe
//    public void makeEquip(MakeEquipEvent event) {
//        long rid = event.getRid();
//        event.getEquipTypeMap().forEach((k, v) -> {
//            OperatorType type = null;
//            CEquipmenttype cEquipmenttype = equipmenttypeSysCache.getOrThrow(k);
//            if (cEquipmenttype.getRare() == EquipColourStage.PURPLE.getType()) {
//
//                type = OperatorType.PURPLE_EQUIP;
//
//            } else if (cEquipmenttype.getRare() == EquipColourStage.ORANGE.getType()) {
//
//                type = OperatorType.ORAGE_EQUIP;
//                if (cEquipmenttype.getStar() == 1) {
//                    int newValue = operatorValueService.addProcess(rid, OperatorType.ORAGE_ONESTAR_EQUIP, v);
//                    eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.ORAGE_ONESTAR_EQUIP, newValue, v));
//                }
//
//            } else if (cEquipmenttype.getRare() == EquipColourStage.RED.getType()) {
//
//                type = OperatorType.RED_EQUIP;
//
//            }
//            if (type != null) {
//                int newValue = operatorValueService.addProcess(rid, type, v);
//                eventBus.post(OperatorValueChangeEvent.of(rid, type, newValue, v));
//            }
//        });
//        int newValue = operatorValueService.addProcess(rid, OperatorType.COMPOSE_EQUIP, event.getTimes());
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.COMPOSE_EQUIP, newValue, event.getTimes()));
//    }
//
//    /**
//     * 快速战斗
//     *
//     * @param event
//     */
//    @Subscribe
//    public void speedFight(SpeedFightEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.QUICK_BATTLE_END, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.QUICK_BATTLE_END, newValue, 1));
//    }
//
//    /**
//     * 日常副本扫荡
//     *
//     * @param event
//     */
//    @Subscribe
//    public void joinDailyDungeon(JoinDailyDungeonEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.DAILY_DUNGEON, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.DAILY_DUNGEON, newValue, 1));
//    }
//
//    /**
//     * 英雄献祭事件
//     *
//     * @param event
//     */
//    @Subscribe
//    public void alterHero(AlterHeroEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.ALTAR_HERO, event.getCount());
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.ALTAR_HERO, newValue, event.getCount()));
//    }
//
//    /**
//     * 市场购买
//     *
//     * @param event
//     */
//    @Subscribe
//    public void shopBuy(ShopBuyEvent event) {
//        if (event.getShopType() == ShopType.MARKET) {
//            long rid = event.getRid();
//            int newValue = operatorValueService.addProcess(rid, OperatorType.MARKET_BUY, event.getBuyTimes());
//            eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.MARKET_BUY, newValue, event.getBuyTimes()));
//        }
//    }
//
//    /**
//     * 公会技能升级
//     *
//     * @param event
//     */
//    @Subscribe
//    public void upClanSKill(ClanSkillUpEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.CLAN_UP_SKILL, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.CLAN_UP_SKILL, newValue, 1));
//    }
//
//    /**
//     * 先知召唤
//     *
//     * @param event
//     */
//    @Subscribe
//    public void prophetSummon(ProphetSummonEvent event) {
//        long rid = event.getRid();
//        int newValue = operatorValueService.addProcess(rid, OperatorType.PROPHET_SUMMON, 1);
//        eventBus.post(OperatorValueChangeEvent.of(rid, OperatorType.PROPHET_SUMMON, newValue, 1));
//    }
//}
