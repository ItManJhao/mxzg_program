package com.ayjs.mxzg.gameserver.module.magicTower.handler;

import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.marquee.constant.NoticeIdx;
import com.ayjs.mxzg.gameserver.module.marquee.service.MarqueeService;
import com.ayjs.mxzg.gameserver.module.marquee.struct.ObjParam;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerArenaChangeBroReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelPassBroReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerRemoteBattleReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerRemoteBattleRes;
import com.ayjs.mxzg.module.battle.BattleReportManager;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.MagicTowerGMsg;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/6/18
 **/
@Slf4j
@Component
@Remote
public class MagicTowerRemoteHandler implements MessageHandler {
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private MarqueeService marqueeService;
    @Autowired
    private BattleReportManager battleReportManager;


    @RemoteMethod
    public void arenaChangeBro(MagicTowerArenaChangeBroReq req) {
        try {
            MagicTowerGMsg.PSMagicTowerArena newArena = MagicTowerGMsg.PSMagicTowerArena.parseFrom(req.getNewArenaRole());
            if (req.getOldArenaRole() != null) {
                MagicTowerGMsg.PSMagicTowerArena oldArena = MagicTowerGMsg.PSMagicTowerArena.parseFrom(req.getOldArenaRole());
                if (oldArena.getRid() != 0) {
                    marqueeService.addMarquee(NoticeIdx.MAGIC_TOWER_ARENA_CHANGE, 0, ObjParam.build(newArena.getServerId()
                            , newArena.getName(), oldArena.getServerId(), oldArena.getName(), req.getLevel()));
                }
            }
            MagicTowerGMsg.GResMagicTowerArenaBro.Builder builder = MagicTowerGMsg.GResMagicTowerArenaBro.newBuilder();
            builder.setArena(MagicTowerGMsg.PSMagicTowerArena.parseFrom(req.getNewArenaRole()));
            contextManager.writeAll(CmdCode._76508, builder.build());
        } catch (Exception e) {
            log.error("协议解析失败！", e);
        }

    }

    @RemoteMethod
    public void levelPassBro(MagicTowerLevelPassBroReq req) {
        MagicTowerGMsg.GResMagicTowerLevelPassBro.Builder builder = MagicTowerGMsg.GResMagicTowerLevelPassBro.newBuilder();
        try {
            builder.setLevelPass(MagicTowerGMsg.PSMagicLevelPassData.parseFrom(req.getPassData()));
            contextManager.writeAll(CmdCode._76509, builder.build());
        } catch (Exception e) {
            log.error("协议解析失败！", e);
        }
    }

    @RemoteMethod
    public MagicTowerRemoteBattleRes remoteBattle(MagicTowerRemoteBattleReq req) {
        BattleGMsg.BattleReport report = battleReportManager.getReport(req.getBattleId());
        if (report != null) {
            return MagicTowerRemoteBattleRes.of(report.toByteArray());
        }
        return MagicTowerRemoteBattleRes.of(null);

    }
}
