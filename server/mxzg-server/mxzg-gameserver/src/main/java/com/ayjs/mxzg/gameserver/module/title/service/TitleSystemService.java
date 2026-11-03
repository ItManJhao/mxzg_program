/**
 *
 */
package com.ayjs.mxzg.gameserver.module.title.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.TitleSysCache;
import com.ayjs.mxzg.config.excel.entity.CTitle;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.TitleType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import com.ayjs.mxzg.gameserver.module.champion.event.ChampionEndEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.ladder.event.LadderEndEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.teamArena.event.TeamArenaSettleEvent;
import com.ayjs.mxzg.gameserver.module.title.dao.TitleSystemDao;
import com.ayjs.mxzg.gameserver.module.title.domain.Title;
import com.ayjs.mxzg.gameserver.module.title.domain.TitleSystem;
import com.ayjs.mxzg.gameserver.module.title.event.IssueTitleEvent;
import com.ayjs.mxzg.gameserver.module.title.event.RecoverTitleEvent;
import com.ayjs.mxzg.gameserver.module.title.struct.TitleData;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRank;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Slf4j
@Observer
@Service
public class TitleSystemService implements Lifecycle {

    @Autowired
    private TitleSystemDao titleSystemDao;
    @Autowired
    private TitleSysCache titleSysCache;
    @Autowired
    private TitleService titleService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private HeroService heroService;

    public TitleSystem getTitleSystem(TitleType type) {
        for (TitleSystem titleSys : titleSystemDao.listAll()) {
            if (titleSys.getType() == type.getValue()) {
                return titleSys;
            }
        }
        //让它报错
        Asserts.notNull(null, ErrorCode.ERROR_PARAM.getValue(), "");
        return null;
    }

    public void updateSystem(TitleSystem titleSystem) {
        titleSystemDao.update(titleSystem);
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("TitleSystemService");
    }

    @Override
    public void start() throws Exception {
        List<TitleSystem> titleList = titleSystemDao.listAll();
        Map<Integer, TitleSystem> titleMap = ListMapUtil.listToMap(titleList, TitleSystem::getType);

        for (TitleType titleType : TitleType.values()) {
            TitleSystem titleSystem = titleMap.get(titleType.getValue());
            if (titleSystem == null) {
                titleSystem = new TitleSystem();
                titleSystem.setType(titleType.getValue());
                titleSystem.setOwners(new HashSet<>());
                titleSystemDao.add(titleSystem);
            }
        }
    }

    /**
     * 回收称号
     * @param titleType
     */
    private void recoverTitle(TitleType titleType) {
        log.info("正在进行" + titleType + "的称号回收");
        TitleSystem titleSystem = getTitleSystem(titleType);
        List<CTitle> titleList = titleSysCache.getTitles(titleType);
        for (Long rid : titleSystem.getOwners()) {
            if (!roleService.isRole(rid)) {
                continue;
            }
            Title title = titleService.getTitle(rid);
            for (CTitle cTitle : titleList) {
                TitleData titleData = title.getTitles().get(cTitle.getIdx());
                if (titleData == null) {
                    continue;
                }
                titleData.setEndTime(0);
            }
            titleService.update(title);
            heroService.computeStrengthBiggerThenFiveStar(rid, GameEvent.TITLE_RECOVER);
        }
        titleSystem.getOwners().clear();
        this.updateSystem(titleSystem);
    }

    @Subscribe
    private void listen(ChampionEndEvent event) {
        //回收称号
        recoverTitle(TitleType.CHAMPION);
        log.info("对" + TitleType.CHAMPION + "的称号进行发放");
        Map<Integer, ChampionCompetitor> rankMap = ListMapUtil.listToMap(new ArrayList<>(event.getCompetitors()), ChampionCompetitor::getRank);
        List<CTitle> titleList = titleSysCache.getTitles(TitleType.CHAMPION);
        TitleSystem titleSystem = getTitleSystem(TitleType.CHAMPION);

        for (CTitle cTitle : titleList) {
            for (int rank = cTitle.getRankCondition()[0]; rank <= cTitle.getRankCondition()[1]; rank++) {
                ChampionCompetitor competitor = rankMap.get(rank);
                //不处理机器人
                if (competitor == null || competitor.getRobot() == 1) {
                    continue;
                }
                provideTitle(competitor.getRid(), TitleType.CHAMPION, titleSystem, cTitle);
            }
        }
        this.updateSystem(titleSystem);
    }

    @Subscribe
    private void listen(LadderEndEvent event) {
        //回收称号
        recoverTitle(TitleType.LADDER);
        log.info("对" + TitleType.LADDER + "的称号进行发放，比赛数据条数" + event.getRankList().size());
        Map<Integer, CrossLadderRank> rankMap = ListMapUtil.listToMap(new ArrayList<>(event.getRankList()), CrossLadderRank::getRank);
        List<CTitle> titleList = titleSysCache.getTitles(TitleType.LADDER);
        TitleSystem titleSystem = getTitleSystem(TitleType.LADDER);

        for (CTitle cTitle : titleList) {
            log.info("对" + TitleType.LADDER + "的称号第" + cTitle.getCondition() + "名进行发放");
            for (int rank = cTitle.getRankCondition()[0]; rank <= cTitle.getRankCondition()[1]; rank++) {
                CrossLadderRank ranker = rankMap.get(rank);
                if (ranker == null) {
                    continue;
                }
                //不处理不是本服的玩家数据
                if (!roleService.isRole(ranker.getRankId()) || !serverConfig.matchServerId(ranker.getServerId())) {
                    continue;
                }
                provideTitle(ranker.getRankId(), TitleType.LADDER, titleSystem, cTitle);
            }
        }
        this.updateSystem(titleSystem);
    }

    @Subscribe
    private void listen(TeamArenaSettleEvent event) {
        //回收称号
        recoverTitle(TitleType.TEAM_ARENA);
        log.info("对" + TitleType.TEAM_ARENA + "的称号进行发放，比赛数据条数" + event.getRank2Roles().size());

        List<CTitle> titleList = titleSysCache.getTitles(TitleType.TEAM_ARENA);
        TitleSystem titleSystem = getTitleSystem(TitleType.TEAM_ARENA);

        for (CTitle cTitle : titleList) {
            log.info("对" + TitleType.TEAM_ARENA + "的称号第" + cTitle.getCondition() + "名进行发放");
            for (int rank = cTitle.getRankCondition()[0]; rank <= cTitle.getRankCondition()[1]; rank++) {
                List<Long> rids = event.getRank2Roles().get(rank);
                if (rids == null) {
                    continue;
                }
                for (long rid : rids) {
                    //只处理本服玩家的数据
                    if (!roleService.isRole(rid)) {
                        break;
                    }
                    provideTitle(rid, TitleType.TEAM_ARENA, titleSystem, cTitle);
                }
            }
        }
        this.updateSystem(titleSystem);
    }

    /**
     * 发放称号
     * @param event
     */
    @Subscribe
    public void listen(IssueTitleEvent event) {
        TitleSystem titleSystem = getTitleSystem(event.getTitleType());
        CTitle cTitle = titleSysCache.getOrThrow(event.getTitleId());
        provideTitle(event.getRid(), event.getTitleType(), titleSystem, cTitle);
    }

    /**
     * 称号回收事件
     * @param event
     */
    @Subscribe
    public void listen(RecoverTitleEvent event) {
        recoverTitle(event.getTitleType());
    }

    /**
     * 发放称号
     * @param rid
     * @param titleType
     * @param titleSystem
     * @param cTitle
     */
    private void provideTitle(long rid, TitleType titleType, TitleSystem titleSystem, CTitle cTitle) {
        Title title = titleService.getTitle(rid);
        TitleData titleData = title.getTitles().get(cTitle.getIdx());
        if (titleData == null) {
            titleData = new TitleData();
            titleData.setId(cTitle.getIdx());
            title.getTitles().put(cTitle.getIdx(), titleData);
        }
        titleData.setEndTime(TimeDateUtil.getCurrentTimeInt() + cTitle.getTime());
        titleService.update(title);
        //将称号拥有者保存到系统数据中
        titleSystem.getOwners().add(rid);
        //计算战力
        heroService.computeStrengthBiggerThenFiveStar(rid, GameEvent.TITLE_PROVIDE);
        log.info("对" + titleType + "的称号第" + cTitle.getCondition() + "名进行发放，发放成功");
    }

    // 不过期，没有属性增加的称号添加
    public void provideTitle(long rid, TitleType titleType, CTitle cTitle) {
        Title title = titleService.getTitle(rid);
        TitleData titleData = title.getTitles().get(cTitle.getIdx());
        if (titleData == null) {
            titleData = new TitleData();
            titleData.setId(cTitle.getIdx());
            titleData.setEndTime(-1);   // 永久不过期
            title.getTitles().put(cTitle.getIdx(), titleData);
        }
        titleService.update(title);
        TitleSystem titleSystem = getTitleSystem(titleType);
        titleSystem.getOwners().add(rid);
        this.updateSystem(titleSystem);

        heroService.computeStrengthBiggerThenFiveStar(rid, GameEvent.TITLE_PROVIDE);
        log.info(String.format("玩家{%s}斩魔王者礼包称号发放成功", rid));
    }

    //TODO 现在的
}
