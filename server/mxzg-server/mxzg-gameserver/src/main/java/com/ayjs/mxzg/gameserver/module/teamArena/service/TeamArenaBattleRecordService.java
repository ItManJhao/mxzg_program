package com.ayjs.mxzg.gameserver.module.teamArena.service;

import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.gameserver.module.teamArena.dao.ArenaTeamBattleRecordDao;
import com.ayjs.mxzg.gameserver.module.teamArena.dao.ArenaTeamBattleRecordDetailDao;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamBattleRecord;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamBattleRecordDetail;
import com.ayjs.mxzg.gameserver.module.teamArena.event.TeamArenaRecordEvent;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaDefendRecordReqMessage;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.util.ProtostuffUtil;
import com.google.protobuf.InvalidProtocolBufferException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/4/15
 **/

@Service
@Observer
public class TeamArenaBattleRecordService implements MessageHandler {

    @Autowired
    private ArenaTeamBattleRecordDao arenaTeamBattleRecordDao;
    @Autowired
    private ArenaTeamBattleRecordDetailDao arenaTeamBattleRecordDetailDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private CommandBus commandBus;
//    @auto

    public int getRecordMax() {
        return 30;
    }

    public void add(ArenaTeamBattleRecord record) {
        arenaTeamBattleRecordDao.add(record);
        List<ArenaTeamBattleRecord> records = arenaTeamBattleRecordDao.list("teamId", record.getTeamId());
        if (records.size() > getRecordMax() * 2) {
            records.sort(new Comparator<ArenaTeamBattleRecord>() {
                @Override
                public int compare(ArenaTeamBattleRecord o1, ArenaTeamBattleRecord o2) {
                    return o1.getBattleTime() - o2.getBattleTime();
                }
            });
            removeRecord(records.subList(getRecordMax() - 1, records.size()));
        }

    }


    /***
     * 获取有效的记录
     * @param teamId
     * @return
     */
    public List<ArenaTeamBattleRecord> getTeamRecord(long teamId) {
        List<ArenaTeamBattleRecord> records = arenaTeamBattleRecordDao.list("teamId", teamId);
        records.sort(new Comparator<ArenaTeamBattleRecord>() {
            @Override
            public int compare(ArenaTeamBattleRecord o1, ArenaTeamBattleRecord o2) {
                return o1.getBattleTime() - o2.getBattleTime();
            }
        });
        return records.subList(0, Math.min(getRecordMax(), records.size()));
    }

    public void removeAll() {
        arenaTeamBattleRecordDao.remove(arenaTeamBattleRecordDao.listAll());
        arenaTeamBattleRecordDetailDao.remove(arenaTeamBattleRecordDetailDao.listAll());
    }

    public void removeRecord(List<ArenaTeamBattleRecord> records) {
        arenaTeamBattleRecordDao.remove(records);
        List<ArenaTeamBattleRecordDetail> remove = new ArrayList<>();
        records.forEach(record -> {
            remove.addAll(getDetails(record.getId()));
        });
        arenaTeamBattleRecordDetailDao.remove(remove);
    }

    public List<ArenaTeamBattleRecordDetail> getDetails(long recordId) {
        return arenaTeamBattleRecordDetailDao.list("recordId", recordId);
    }

    public List<ArenaTeamBattleRecordDetail> addRecordDetail(ArenaTeamBattleRecord record, List<BattleGMsg.BattleReport> reports) {
        List<ArenaTeamBattleRecordDetail> adds = new ArrayList<>();
        reports.forEach(report -> {
            ArenaTeamBattleRecordDetail detail = new ArenaTeamBattleRecordDetail();
            detail.setWinTeamId(record.getWinTeamId());
            detail.setAttackTeamName(record.getAttack().getTeamData().getTeamName());
            detail.setDefendTeamName(record.getDefend().getTeamData().getTeamName());
            try {
                detail.setBattleLogStr(new String(report.getLog().toByteArray(), VideoConst.ISO));
                detail.setBattleRound(report.getRoundsCount());
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            detail.setBattleTime((int) (report.getStartTime() / 1000));
            detail.setReportId(report.getBattleId());
            detail.setRecordId(record.getId());
            adds.add(detail);
        });
        arenaTeamBattleRecordDetailDao.add(adds);

        return adds;

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(TeamArenaRecordEvent event) {

        ArenaTeamBattleRecord record = new ArenaTeamBattleRecord();
        record.setTeamId(event.getAttack().getTeamData().getTeamId());
        record.setWinTeamId(event.getWinTeamId());
        record.setBattleTime(event.getBattleTime());

        record.setAddRank(event.getAttackAddRank());
        record.setAddScore(event.getAttackAddScore());
        record.setAttack(event.getAttack());

        record.setDefend(event.getDefend());
        record.setDefendAddRank(event.getDefendAddRank());
        record.setDefendReduceScore(event.getDefendReduceScore());

        add(record);

        List<ArenaTeamBattleRecordDetail> arenaTeamBattleRecordDetails = addRecordDetail(record, event.getReports());

        event.getReports().forEach(report -> {
            //保存战报
            SaveBattleReportCommand saveBattleReportCommand = SaveBattleReportCommand.of(report);
            commandBus.invoke(saveBattleReportCommand);
        });

        TeamArenaDefendRecordReqMessage message = new TeamArenaDefendRecordReqMessage();
        message.setServerId(event.getDefend().getTeamData().getServerId());
        message.setRecord(ProtostuffUtil.serialize(record));
        List<byte[]> detailBytes = new ArrayList<>();
        arenaTeamBattleRecordDetails.forEach(arenaTeamBattleRecordDetail -> detailBytes.add(ProtostuffUtil.serialize(arenaTeamBattleRecordDetail)));
        message.setRecordDetail(detailBytes);
        List<byte[]> reportBytes = new ArrayList<>();
        event.getReports().forEach(report -> reportBytes.add(report.toByteArray()));
        message.setReports(reportBytes);

        messageDispatcher.dispatch(message);
    }

    @RemoteMethod
    public void defendBattleRecord(TeamArenaDefendRecordReqMessage req) {
        ArenaTeamBattleRecord remoteRecord = ProtostuffUtil.deserialize(req.getRecord(), ArenaTeamBattleRecord.class);

        ArenaTeamBattleRecord record = new ArenaTeamBattleRecord();

        record.setTeamId(remoteRecord.getDefend().getTeamData().getTeamId());
        record.setBattleTime(remoteRecord.getBattleTime());
        record.setWinTeamId(remoteRecord.getWinTeamId());

        record.setDefend(remoteRecord.getDefend());
        record.setDefendAddRank(remoteRecord.getDefendAddRank());
        record.setDefendReduceScore(remoteRecord.getDefendReduceScore());

        record.setAttack(remoteRecord.getAttack());
        record.setAddScore(remoteRecord.getAddScore());
        record.setAddRank(remoteRecord.getAddRank());

        add(record);
        List<ArenaTeamBattleRecordDetail> arenaTeamBattleRecordDetails = new ArrayList<>();

        req.getRecordDetail().forEach(detailBytes -> {
            ArenaTeamBattleRecordDetail remoteRecordDetail = ProtostuffUtil.deserialize(detailBytes, ArenaTeamBattleRecordDetail.class);

            ArenaTeamBattleRecordDetail detail = new ArenaTeamBattleRecordDetail();
            detail.setWinTeamId(remoteRecordDetail.getWinTeamId());
            detail.setAttackTeamName(remoteRecordDetail.getAttackTeamName());
            detail.setDefendTeamName(remoteRecordDetail.getDefendTeamName());
            detail.setBattleLogStr(remoteRecordDetail.getBattleLogStr());
            detail.setBattleRound(remoteRecordDetail.getBattleRound());

            detail.setBattleTime(remoteRecordDetail.getBattleTime());
            detail.setReportId(remoteRecordDetail.getReportId());
            detail.setRecordId(record.getId());

            arenaTeamBattleRecordDetails.add(detail);

        });

        arenaTeamBattleRecordDetailDao.add(arenaTeamBattleRecordDetails);

        if (record.getDefend().getTeamData().getServerId() != record.getAttack().getTeamData().getServerId()) {
            req.getReports().forEach(report -> {
                try {
                    BattleGMsg.BattleReport battleReport = BattleGMsg.BattleReport.parseFrom(report);
                    //保存战报
                    SaveBattleReportCommand saveBattleReportCommand = SaveBattleReportCommand.of(battleReport);
                    commandBus.invoke(saveBattleReportCommand);
                } catch (InvalidProtocolBufferException e) {
                    e.printStackTrace();
                }
            });
        }
    }


}
