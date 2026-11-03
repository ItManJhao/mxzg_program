package com.ayjs.mxzg.gameserver.module.floatingIslands.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.floatingIslands.FloatingIslandsDmgRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.floatingIslands.FloatingIslandsRankRewardSysCache;
import com.ayjs.mxzg.config.excel.constant.FloatingIslandsConst;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsDmgReward;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsRankReward;
import com.ayjs.mxzg.config.struct.FloatingIslandsStage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.floatingIslands.dao.FloatingIslandsDao;
import com.ayjs.mxzg.gameserver.module.floatingIslands.dao.FloatingIslandsTimeDao;
import com.ayjs.mxzg.gameserver.module.floatingIslands.dao.RoleFloatingIslandsDao;
import com.ayjs.mxzg.gameserver.module.floatingIslands.domain.RoleFloatingIslands;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsRankSettleRecordReqMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsRankSettleRecordResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslands;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankDataRecord;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Service
@Slf4j
@Observer
public class FloatingIslandsService {

    @Autowired
    private RoleFloatingIslandsDao roleFloatingIslandsDao;
    @Autowired
    private FloatingIslandsConst floatingIslandsConst;
    @Autowired
    private FloatingIslandsTimeDao floatingIslandsTimeDao;
    @Autowired
    private FloatingIslandsDao floatingIslandsDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private RoleService roleService;
    @Autowired
    private FloatingIslandsRankRewardSysCache floatingIslandsRankRewardSysCache;
    @Autowired
    private MailService mailService;
    @Autowired
    private FloatingIslandsDmgRewardSysCache floatingIslandsDmgRewardSysCache;

    public RoleFloatingIslands get(long rid) {
        RoleFloatingIslands roleFloatingIslands = roleFloatingIslandsDao.get(rid);
        if (roleFloatingIslands == null) {
            roleFloatingIslands = new RoleFloatingIslands();
            roleFloatingIslands.setRid(rid);
            roleFloatingIslandsDao.add(roleFloatingIslands);
        }
        if (!TimeDateUtil.isToday(roleFloatingIslands.getCountRefreshTime())) {
            roleFloatingIslands.setChallengeCount(floatingIslandsConst.getFloatingIslandsInitChallengeCount());
            roleFloatingIslands.setHadBuyCount(0);
            roleFloatingIslands.setCountRefreshTime(TimeDateUtil.getCurrentTimeInt());
            update(roleFloatingIslands);
        }

        return roleFloatingIslands;
    }

    public List<RoleFloatingIslands> listAll() {
        return roleFloatingIslandsDao.listAll();
    }

    public void update(List<RoleFloatingIslands> entities) {
        roleFloatingIslandsDao.update(entities);
    }

    public void update(RoleFloatingIslands entity) {
        roleFloatingIslandsDao.update(entity);
    }

    public FloatingIslandsTime getTime() {
        return floatingIslandsTimeDao.get();
    }

    public void update(FloatingIslandsTime floatingIslandsTime) {
        floatingIslandsTimeDao.update(floatingIslandsTime);
    }

    public FloatingIslands getServerDmg() {
        return floatingIslandsDao.get();
    }

    public void update(FloatingIslands floatingIslandsTime) {
        floatingIslandsDao.update(floatingIslandsTime);
    }

    public void settleChallengeBoss() {
        FloatingIslands time = getServerDmg();
        messageDispatcher.dispatch(
                FloatingIslandsRankSettleRecordReqMessage.of(time.getLastBossSettleTime(), serverConfig.getSubServerIds()),
                res -> {
                    FloatingIslandsRankSettleRecordResMessage response = (FloatingIslandsRankSettleRecordResMessage) res;
                    if (!CollectionUtil.isEmpty(response.getRankList())) {
                        mailRankReward(response.getRankList());
                    }
                    if (!CollectionUtil.isEmpty(response.getTotalDmgList())) {
                        mailDmgReward(response.getTotalDmgList());
                    }
                    time.setLastBossSettleTime(response.getSettleTime());
                    update(time);
                });
    }

    private void mailRankReward(List<RankDataRecord> ranks) {
        if (CollectionUtil.isEmpty(ranks)) {
            return;
        }
        List<Mail> mails = new ArrayList<>();
        ranks.forEach(rankDataRecord -> {
            try {
                Role role = roleService.getOrThrow(rankDataRecord.getRankData().getRankId());
                CFloatingIslandsRankReward rewardConfig = floatingIslandsRankRewardSysCache.getAll().
                        stream().filter(config -> config.getRank_up() <= rankDataRecord.getRank() &&
                        config.getRank_down() >= rankDataRecord.getRank()).findAny().orElse(null);
                if (rewardConfig != null) {
                    Mail mail = mailService.newMailNoTitle(role.getId(), MailScene.FLOATING_ISLANDS_RANK_REWARD,
                            MailParams.build(rankDataRecord.getRank()), rewardConfig.getReward(),
                            GameEvent.FLOATING_ISLANDS_RANK_REWARD);
                    mails.add(mail);
                }
            } catch (Exception e) {
                log.error(String.format("排名奖励发放失败{%s}", JsonUtil.toJson(rankDataRecord)), e);
            }
        });
        mailService.insertMails(mails);
    }

    private void mailDmgReward(List<Long> dmgList) {
        if (CollectionUtil.isEmpty(dmgList)) {
            return;
        }
        List<RoleFloatingIslands> allRewardRole = listAll().stream().filter(roleFloatingIslands ->
                roleFloatingIslands.getTotalDmg() > 0).collect(Collectors.toList());
        List<Mail> list = new ArrayList<>();
        dmgList.forEach(dmg -> {
            log.info("伤害结算");
            CFloatingIslandsDmgReward dmgRewardConfig = floatingIslandsDmgRewardSysCache.getAll().stream()
                    .filter(config -> config.getDmg_value() <= dmg)
                    .max(Comparator.comparingLong(CFloatingIslandsDmgReward::getDmg_value)).orElse(null);
            if (dmgRewardConfig != null) {
                allRewardRole.forEach(roleFloatingIslands -> {
                    Mail mail = mailService.newMailNoTitle(roleFloatingIslands.getRid(), MailScene.FLOATING_ISLANDS_DMG,
                            MailParams.build(dmgRewardConfig.getDmg_value()), dmgRewardConfig.getReward(), GameEvent.FLOATING_ISLANDS_DMG_REWARD);
                    list.add(mail);
                });
            }
        });
        mailService.insertMails(list);
    }

    public void setNewStage(FloatingIslandsTime newTime) {
        FloatingIslandsTime currTime = getTime();
        if (isSameTime(currTime, newTime)) {
            return;
        }

        int currStage = currTime.getStage();
        FloatingIslandsStage enumStage = FloatingIslandsStage.getStage(currStage);
        if (enumStage == null) {
            doChangeStage(FloatingIslandsStage.getStage(newTime.getStage()), currTime);
        } else {
            while (currStage != newTime.getStage()) {
                FloatingIslandsStage nextStage = FloatingIslandsStage.getStage(currStage).nextStage();
                currStage = nextStage.getCode();
                doChangeStage(nextStage, currTime);
            }
        }

        log.info("修改新的时间》》" + JsonUtil.toJson(newTime));
        currTime.setNextTime(newTime.getNextTime());
        currTime.setStage(newTime.getStage());
        currTime.setStageChangeTime(newTime.getStageChangeTime());
        currTime.setNextStage(newTime.getNextStage());
//        currTime.setBossTurns(newTime.getBossTurns());
        update(newTime);


    }

    private void doChangeStage(FloatingIslandsStage stage, FloatingIslandsTime teamArenaTime) {
        switch (stage) {
            case OVER:
                break;
            case CHALLENGE_BOSS:
                clearDmg();
                break;
            case CHALLENGE_SETTLE:
                settleChallengeBoss();
                break;
        }

    }

    public void clearDmg() {
        //清除伤害记录
        List<RoleFloatingIslands> allRole = listAll();
        allRole.forEach(roleFloatingIslandsTemp -> {
            roleFloatingIslandsTemp.setMaxDmg(0);
            roleFloatingIslandsTemp.setTotalDmg(0);
        });
        update(allRole);
        //清除总伤害
        FloatingIslands serverDmg = getServerDmg();
        serverDmg.setDmg(0);
        update(serverDmg);
    }

    private boolean isSameTime(FloatingIslandsTime time1, FloatingIslandsTime time2) {
        return time1.getStage() == time2.getStage() && time1.getNextStage() == time2.getNextStage()
                && time1.getNextTime() == time2.getNextTime() && time1.getStageChangeTime() == time2.getStageChangeTime();
    }
}
