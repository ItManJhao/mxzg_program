package com.ayjs.mxzg.largecross.module.floatingIslands.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.struct.FloatingIslandsStage;
import com.ayjs.mxzg.largecross.module.floatingIslands.domain.FloatingIslandsRankSettleRecord;
import com.ayjs.mxzg.largecross.module.floatingIslands.domain.RoleFloatingIslands;
import com.ayjs.mxzg.largecross.module.floatingIslands.event.FloatingIslandsChallengeBossEvent;
import com.ayjs.mxzg.largecross.module.floatingIslands.service.FloatingIslandsRankService;
import com.ayjs.mxzg.largecross.module.floatingIslands.service.FloatingIslandsService;
import com.ayjs.mxzg.largecross.servergroup.dao.CrossServerGroupDao;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsChallengeReqMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsChallengeResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGMAddDmgMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGMMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGetRankMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGetStateReqMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGetStateResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsRankSettleRecordReqMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsRankSettleRecordResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslands;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankDataRecord;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Component
@Slf4j
public class CrossFloatingIslandsHandler implements MessageHandler {

    @Autowired
    private FloatingIslandsService floatingIslandsService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private FloatingIslandsRankService floatingIslandsRankService;
    @Autowired
    private CrossServerGroupDao crossServerGroupService;

    @RemoteMethod
    public FloatingIslandsChallengeResMessage challenge(FloatingIslandsChallengeReqMessage req, Connection connection) {
        FloatingIslands floatingIslands = null;
        try {
            FloatingIslandsTime islandsTime = floatingIslandsService.getTime();
            Asserts.isTrue(islandsTime.getStage() == FloatingIslandsStage.CHALLENGE_BOSS.getCode(),
                    ErrorCode.FLOATING_ISLANDS_STAGE_ERROR.getValue(), String.format("阶段{%s}错误", islandsTime.getStage()));

            synchronized (InternerPool.intern(FloatingIslandsService.FLOATING_ISLANDS_DMG_LOCK)) {
                floatingIslands = floatingIslandsService.get();
                floatingIslands.setDmg(req.getDmg() + floatingIslands.getDmg());
                floatingIslandsService.update(floatingIslands);
            }

            //战斗之后更新玩家数据
            RoleFloatingIslands roleFloatingIslands = floatingIslandsService.getRoleFloatingIslands(req.getRid());
            if (roleFloatingIslands == null) {
                roleFloatingIslands = new RoleFloatingIslands();
                roleFloatingIslands.setRid(req.getRid());
                roleFloatingIslands.setServerId(req.getServerId());
                floatingIslandsService.add(roleFloatingIslands);
            }

            roleFloatingIslands.setTotalDmg(roleFloatingIslands.getTotalDmg() + req.getDmg());
            if (roleFloatingIslands.getMaxDmg() < req.getDmg()) {
                roleFloatingIslands.setMaxDmg(req.getDmg());
            }
            roleFloatingIslands.setRankTime(TimeDateUtil.getCurrentTimeInt());
            floatingIslandsService.update(roleFloatingIslands);

            eventBus.post(FloatingIslandsChallengeBossEvent.of(req.getRid()));

            return FloatingIslandsChallengeResMessage.of(ErrorCode.NO_ERROR.getValue(), floatingIslands.getDmg());
        } catch (Exception e) {
            log.error("挑战boss失败", e);
            return FloatingIslandsChallengeResMessage.of(ErrorCode.SYSTEM_ERROR.getValue(), floatingIslands != null ? floatingIslands.getDmg() : 0);
        }

    }

    @RemoteMethod
    public void getState(FloatingIslandsGetStateReqMessage req, Connection connection) {
        connection.send(FloatingIslandsGetStateResMessage.of(floatingIslandsService.getTime()));
    }

    @RemoteMethod
    public void gmSetStage(FloatingIslandsGMMessage req) {
        floatingIslandsService.setStage(FloatingIslandsStage.getStage(req.getStage()), false);
    }

    @RemoteMethod
    public void gmAddDmg(FloatingIslandsGMAddDmgMessage req) {
        FloatingIslands floatingIslands = floatingIslandsService.get();
        floatingIslands.setDmg(floatingIslands.getDmg() + req.getDmg());
        floatingIslandsService.update(floatingIslands);
    }

    @RemoteMethod
    public void getRank(FloatingIslandsGetRankMessage req, Connection connection) {
        floatingIslandsRankService.pullToGame(req.getServerId(), connection);
    }

    @RemoteMethod
    public FloatingIslandsRankSettleRecordResMessage getRankSettleRecord(FloatingIslandsRankSettleRecordReqMessage req, Connection connection) {
        List<RankDataRecord> list = new ArrayList<>();
        List<Long> dmgList = new ArrayList<>();
        if (req.getServerIds() == null || req.getServerIds().length == 0) {
            throw new RuntimeException("请求结算信息，但是服务器id集合未空");
        }
        CrossGroup crossGroup = crossServerGroupService.get().getGroupByServerId(req.getServerIds()[0]);
        if (crossGroup == null) {
            return FloatingIslandsRankSettleRecordResMessage.of(list, req.getSettleTime(), dmgList);
        }
        List<FloatingIslandsRankSettleRecord> records = floatingIslandsService.getRecordByGroup(crossGroup.getGroupId());

        records = records.stream().filter(record -> record.getSettleTime() > req.getSettleTime()).collect(Collectors.toList());
        if (records.size() <= 0) {
            return FloatingIslandsRankSettleRecordResMessage.of(list, req.getSettleTime(), dmgList);
        }
        int settleTime = records.stream().mapToInt(FloatingIslandsRankSettleRecord::getSettleTime).max().getAsInt();
        records.forEach(record -> {
            record.getRanks().forEach(rankDataRecord -> {
                //过滤掉非本服数据
                RoleFloatingIslands roleFloatingIslands = floatingIslandsService.getRoleFloatingIslands(rankDataRecord.getRankData().getRankId());
                if (req.matchServerId(roleFloatingIslands.getServerId())) {
                    list.add(rankDataRecord);
                }
            });
            dmgList.add(record.getTotalDmg());
        });

        return FloatingIslandsRankSettleRecordResMessage.of(list, settleTime, dmgList);
    }
}
