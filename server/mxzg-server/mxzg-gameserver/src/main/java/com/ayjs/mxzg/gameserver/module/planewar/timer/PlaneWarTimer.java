package com.ayjs.mxzg.gameserver.module.planewar.timer;

import com.ayjs.mxzg.config.excel.cache.planewar.PlaneWarRankSysCache;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarRank;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.planewar.dao.PlaneWarDao;
import com.ayjs.mxzg.gameserver.module.planewar.domain.PlaneWar;
import com.ayjs.mxzg.gameserver.module.planewar.rank.PlaneWarRankService;
import com.ayjs.mxzg.gameserver.module.planewar.service.PlaneWarService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/17
 **/
@Slf4j
@Component
public class PlaneWarTimer extends AbstractCronTask {

    @Autowired
    private PlaneWarDao planeWarDao;
    @Autowired
    private PlaneWarService planeWarService;
    @Autowired
    private PlaneWarRankService planeWarRankService;
    @Autowired
    private PlaneWarRankSysCache planeWarRankSysCache;
    @Autowired
    private MailService mailService;

    @Override
    public Object identity() {
        return "PLANE_WAR_TIMER";
    }

    @Override
    public String expression() {
        return "0 0 0 * * 1";
    }

    @Override
    public void run() {
        //重置人数
        planeWarService.getTurn();
        log.info("位面之战结算排行榜奖励");
        List<PlaneWar> planeWars = planeWarDao.listAll().stream().filter(planeWar -> planeWar.getPassLevelInfo().size() > 0).collect(Collectors.toList());
        List<Mail> mails = Lists.newArrayList();
        LocalDate now = LocalDate.now();
        planeWars.forEach(planeWar -> {
            try {
                int rank = planeWarRankService.getRank(planeWar.getRid());
                if (rank > 0) {
                    CPlaneWarRank config = planeWarRankSysCache.getByRank(rank);
                    if (Objects.nonNull(config)) {
                        Mail mail = mailService.newMailNoTitle(planeWar.getRid(), MailScene.PLANE_WAR_RANK, MailParams.build(rank),
                                config.getReward(), GameEvent.PLANE_WAR_CHALLENGE);
                        mails.add(mail);
                    }else{
                        log.error("玩家{}排名{}不存在奖励", planeWar.getRid(), rank);
                    }
                }
                planeWar.getLastLevelInfo().putAll(planeWar.getPassLevelInfo());
                planeWar.getPassLevelInfo().clear();
                planeWar.setPassLevelReset(now);
            } catch (Exception e) {
                log.error(String.format("player{%s} settle plane war error", planeWar.getRid()), e);
            }
        });
        planeWarRankService.clear();

        planeWarDao.update(planeWars);
        mailService.insertMails(mails);

    }
}
