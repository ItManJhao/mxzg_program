package com.ayjs.mxzg.gameserver.module.dreamland.service;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.DreamlandRankRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.CDreamlandRankReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.dreamland.domin.Dreamland;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandMaxLvEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/12/16
 **/
@Service
@Observer
public class DreamlandRankService extends AbstractPlayerRankService {

    @Autowired
    private DreamlandService dreamlandService;
    @Autowired
    private MailService mailService;
    @Autowired
    private DreamlandRankRewardSysCache dreamlandRankRewardSysCache;
    @Autowired
    private ServerParamService serverParamService;

    @Override
    public RankType getRankType() {
        return RankType.DREAMLAND;
    }

    @Override
    protected int getNotRankScore(Role role) {
        Dreamland dreamland = dreamlandService.loadAndRefresh(role.getId());
        return dreamland.getMaxLv();
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> list = new ArrayList<>();
        int now = TimeDateUtil.getCurrentTimeInt();
        dreamlandService.loadAll().forEach(dreamland -> {
            Rank rank = new Rank();
            rank.setRankId(dreamland.getRid());
            rank.setRankValue(dreamland.getMaxLv());
            rank.setRankTime(now);
            list.add(rank);
        });
        return list;
    }

    @Override
    public void start() throws Exception {
        super.start();
        zeroSendMail();
    }

    private Rank buildRankData(Dreamland dreamland) {
        Rank rank = new Rank();
        rank.setRankId(dreamland.getRid());
        rank.setRankTime(DateTimeUtil.currentSecond());
        rank.setRankValue(dreamland.getMaxLv());
        return rank;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void DreamlandRankEvent(DreamlandMaxLvEvent event) {
        Dreamland dreamland = dreamlandService.loadAndRefresh(event.getRid());
        topN.add(buildRankData(dreamland));
    }


    /***
     * 零点发送排名奖励
     */
    public void zeroSendMail() {
        ServerParam serverParam = serverParamService.getOrCreate(ServerParamType.DREAMLAND_RANK_REWARD_TIME, () -> 0);
        if (TimeDateUtil.isToday(ConvertUtils.toInt(serverParam.getSpValue())))
            return;

        List<Rank> rankList = topN.top(this.getRankType().getRankCount());
        List<Mail> mails = new ArrayList<>();
        for (Rank rank : rankList) {
            int rankInt = topN.getRank(rank.getRankId());
            CDreamlandRankReward config = dreamlandRankRewardSysCache.getConfigByRank(rankInt);
            if (config == null)
                continue;
            Mail mail = mailService.newMailNoTitle(rank.getRankId(), MailScene.DREAMLAND_RANK_REWARD,
                    MailParams.build(rankInt), config.getReward(), GameEvent.DREAMLAND);
            mails.add(mail);
        }
        mailService.insertMails(mails);

        serverParam.setSpValue(TimeDateUtil.getCurrentTimeInt() + "");
        serverParamService.update(serverParam);
    }
}
