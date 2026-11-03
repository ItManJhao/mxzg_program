/**
 *
 */
package com.ayjs.mxzg.gameserver.module.marquee.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.config.excel.cache.FirstRewardTowerSysCache;
import com.ayjs.mxzg.config.excel.cache.FirstrewardChapterSysCache;
import com.ayjs.mxzg.config.excel.entity.CFirstRewardTower;
import com.ayjs.mxzg.config.excel.entity.CFirstrewardChapter;
import com.ayjs.mxzg.config.struct.ClanJobEnum;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterRewardEvent;
import com.ayjs.mxzg.gameserver.module.blessingPool.constant.BlessingPoolType;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolGetRareEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanCreateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanJobChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanMemberJoinEvent;
import com.ayjs.mxzg.gameserver.module.clanwar.event.ClanWarStageEvent;
import com.ayjs.mxzg.gameserver.module.clanwar.event.ClanWarWinEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.constant.ClanWorldBossStage;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossEndEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossFirstEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossStageEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.marquee.constant.NoticeIdx;
import com.ayjs.mxzg.gameserver.module.marquee.service.MarqueeService;
import com.ayjs.mxzg.gameserver.module.marquee.struct.ObjParam;
import com.ayjs.mxzg.gameserver.module.monthCard.event.MonthCardActiveEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.BuyPrivilegeEvent;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.rainbow.event.RainbowChallengeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.teamArena.event.TeamArenaStateChangeEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerRewardEvent;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaState;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarStage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author YY
 *
 */
@Observer
@Service
public class MarqueeObserver {
    @Autowired
    private MarqueeService marqueeService;
    @Autowired
    private FirstrewardChapterSysCache firstrewardChapterSysCache;
    @Autowired
    private FirstRewardTowerSysCache firstRewardTowerSysCache;

    @Subscribe(async = AsyncType.Async)
    private void listen(ChapterRewardEvent event) {
        CFirstrewardChapter config = firstrewardChapterSysCache.getChapterOrThrow(event.getChapterId());
        if (config.getIs_notice() == 1) {
            marqueeService.addMarquee(NoticeIdx.CHAPTER_REWARD, 0, ObjParam.build(event.getRid(), event.getChapterId()));
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(TowerRewardEvent event) {
        CFirstRewardTower config = firstRewardTowerSysCache.getChapterOrThrow(event.getIdx());
        if (config.getIs_notice() == 1) {
            marqueeService.addMarquee(NoticeIdx.TOWER_MISSION_REWARD, 0, ObjParam.build(event.getRid(), event.getIdx()));
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(RechargeEvent event) {
//        if (event.getProductId() == ProductIdx.FIRST_RECHARGE_SIX) {
//            marqueeService.addMarquee(NoticeIdx.FIRST_RECHARGE_SIX, 0, ObjParam.build(event.getRid()));
//        } else if (event.getProductId() == ProductIdx.FIRST_RECHARGE_SIXTY_EIGHT) {
//            marqueeService.addMarquee(NoticeIdx.FIRST_RECHARGE_SIXTY_EIGHT, 0, ObjParam.build(event.getRid()));
//        } else if (event.getProductId() == ProductIdx.DAILY_GIFT_SIXTY_EIGHT) {
//            marqueeService.addMarquee(NoticeIdx.DAILY_GIFT_SIXTY_EIGHT, 0, ObjParam.build(event.getRid()));
//        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(BuyPrivilegeEvent event) {
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(MonthCardActiveEvent event) {
//        if (event.getType() == 1) {
//            marqueeService.addMarquee(NoticeIdx.RECHARGE_NORMAL_MONTH_CARD, 0, ObjParam.build(event.getRid()));
//        } else if (event.getType() == 2) {
//            marqueeService.addMarquee(NoticeIdx.RECHARGE_BEST_MONTH_CARD, 0, ObjParam.build(event.getRid()));
//        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanCreateEvent event) {
        marqueeService.addMarquee(NoticeIdx.CLAN_CREATE, 0, ObjParam.build(event.getRid(), event.getClanId()));
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanMemberJoinEvent event) {
        marqueeService.addMarquee(NoticeIdx.CLAN_JOIN, event.getClanId(), ObjParam.build(event.getRid()));
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanJobChangeEvent event) {
        //会员升任副会长
        if (event.getOldJob() == ClanJobEnum.CLAN_MEMBER && event.getNewJob() == ClanJobEnum.CLAN_VICE_PRESIDENT) {
            marqueeService.addMarquee(NoticeIdx.CLAN_POS_CHANGE, event.getClanId(), ObjParam.build(event.getMemberId()));
        }
        //副会长升任会长
        if (event.getOldJob() == ClanJobEnum.CLAN_VICE_PRESIDENT && event.getNewJob() == ClanJobEnum.CLAN_PRESIDENT) {
            marqueeService.addMarquee(NoticeIdx.CLAN_CHANGE_LEADER, event.getClanId(), ObjParam.build(event.getMemberId()));
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(HeroSummonEvent event) {
        for (Hero hero : event.getHeros()) {
            if (hero.getStar() >= 5) {
                marqueeService.addMarquee(NoticeIdx.HERO_SUMMON, 0, ObjParam.build(hero.getRid(), event.getType().getType(), hero.getType()));
            }
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ProphetSummonEvent event) {
        if (event.getCProphecyType().getNotice() > 0) {
            int heroType = event.getCProphecyType().getNotice();
            marqueeService.addMarquee(NoticeIdx.PROPHET_SUMMON, 0, ObjParam.build(event.getRid(), heroType));
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(HeroStarUpEvent event) {
        marqueeService.addMarquee(NoticeIdx.HERO_UP_STAR, 0, ObjParam.build(event.getHero().getRid(), event.getHero().getType(), event.getHero().getStar()));
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanWorldBossStageEvent event) {
        if (event.getStage() == ClanWorldBossStage.FORECAST) {
            marqueeService.addMarquee(NoticeIdx.CWB_FORECAST, 0, ObjParam.build(event.getNextStageTime()));
        } else if (event.getStage() == ClanWorldBossStage.CHALLENGE) {
            marqueeService.addMarquee(NoticeIdx.CWB_CHALLENGE, 0, null);
        } else if (event.getStage() == ClanWorldBossStage.ROB) {
            marqueeService.addMarquee(NoticeIdx.CWB_ROB, 0, null);
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanWorldBossFirstEvent event) {
        marqueeService.addMarquee(NoticeIdx.CWB_FIRST, 0, ObjParam.build(event.getFirstRoleServer(),
                event.getFirstRole(), event.getFirstClanServer(), event.getFirstClan()));
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanWorldBossEndEvent event) {
        marqueeService.addMarquee(NoticeIdx.CWB_CLAN, event.getClanId(), ObjParam.build(event.getPoint(), event.getRank()));
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanWarStageEvent event) {
        for (long clanId : event.getClanIds()) {
            if (event.getStage() == ClanWarStage.PREPARE) {
                marqueeService.addMarquee(NoticeIdx.CLANWAR_PREPARE, clanId, null);
            } else if (event.getStage() == ClanWarStage.ADJUST) {
                marqueeService.addMarquee(NoticeIdx.CLANWAR_ADJUST, clanId, null);
            }
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanWarWinEvent event) {
        marqueeService.addMarquee(NoticeIdx.CLAN_WAR_WIN, event.getClanId(), null);
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(BlessingPoolGetRareEvent event) {
        event.getRateItem().forEach(logData -> {

            marqueeService.addMarquee(NoticeIdx.BLESSING_POOL, logData.getRid(), ObjParam.build(logData.getRid(), BlessingPoolType.of(event.getType()).getLangKey(), logData.getItemId()));
        });

    }

    @Subscribe(async = AsyncType.Async)
    private void listen(RainbowChallengeEvent event) {
        if (event.getNewSlot().getType() == 1) {
            marqueeService.addMarquee(NoticeIdx.RAINBOW, 0, ObjParam.build(event.getRid()));
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(TeamArenaStateChangeEvent event) {
        if (event.getTeamArenaState() == TeamArenaState.TEAM) {
            marqueeService.addMarquee(NoticeIdx.TEAM_ARENA_TEAM_START, 0, null);
        } else if (event.getTeamArenaState() == TeamArenaState.CHALLENGE) {
            marqueeService.addMarquee(NoticeIdx.TEAM_ARENA_CHALLENGE_START, 0, null);
        }
    }
}
