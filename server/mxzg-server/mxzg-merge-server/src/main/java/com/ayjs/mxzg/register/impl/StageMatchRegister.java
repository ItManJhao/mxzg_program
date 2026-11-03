package com.ayjs.mxzg.register.impl;

import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.domain.OccupationTask;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinCore;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinEquip;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.GreatStyleLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatchLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.StageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleBattle;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleCompetitor;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnaclePlayer;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleReport;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleSystem;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesGreatStyleLog;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesRecord;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesSuperiorBattle;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.register.MergeRegister;
import com.ayjs.mxzg.service.DataProcessorMetaManager;

/**
 * @Author: CWJ
 * @Date: 2020/11/11
 **/
public class StageMatchRegister implements MergeRegister {

    @Override
    public void register(DataProcessorMetaManager dataProcessorMetaManager) {
        dataProcessorMetaManager.doRegisterGame(RoleCrusadeGroup.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(OccupationTask.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(ShenBinEquip.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(ShenBinCore.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(PreliminariesLadder.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(RoleStageMatch.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(RoleStageMatchLog.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(PinnacleCompetitor.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(PinnaclePlayer.class, ProcessorType.NONE, 0);
        dataProcessorMetaManager.doRegisterGame(PreliminariesRecord.class, ProcessorType.NONE, 0);

        dataProcessorMetaManager.doRegisterGame(CrusadeGroup.class, ProcessorType.RESERVE_SOURCE, 0);
        dataProcessorMetaManager.doRegisterGame(GreatStyleLog.class, ProcessorType.RESERVE_SOURCE, 0);
        dataProcessorMetaManager.doRegisterGame(StageMatch.class, ProcessorType.RESERVE_SOURCE, 0);
        dataProcessorMetaManager.doRegisterGame(PinnacleBattle.class, ProcessorType.RESERVE_SOURCE, 0);
        dataProcessorMetaManager.doRegisterGame(PinnacleReport.class, ProcessorType.RESERVE_SOURCE, 0);
        dataProcessorMetaManager.doRegisterGame(PinnacleSystem.class, ProcessorType.RESERVE_SOURCE, 0);
        dataProcessorMetaManager.doRegisterGame(PreliminariesGreatStyleLog.class, ProcessorType.RESERVE_SOURCE, 0);

        dataProcessorMetaManager.doRegisterGame(PreliminariesSuperiorBattle.class, ProcessorType.TRUNCATE_ALL, 0);
    }
}
