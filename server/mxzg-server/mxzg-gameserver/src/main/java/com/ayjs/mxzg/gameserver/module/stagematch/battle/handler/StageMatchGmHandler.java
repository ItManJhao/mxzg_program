package com.ayjs.mxzg.gameserver.module.stagematch.battle.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.SuperStageSysCache;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.RoleStageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.event.PushAllOpponentEvent;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.service.StageMatchService;
import com.ayjs.mxzg.message.module.stagematch.NextStageMessage;
import com.ayjs.mxzg.message.module.stagematch.SetStageMessage;
import com.ayjs.mxzg.message.module.stagematch.gm.CleanOpponentMessage;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class StageMatchGmHandler  extends ProtocolHandler {

    @Autowired
    private RoleStageMatchDao roleStageMatchDao;
    @Autowired
    private StageMatchService stageMatchService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private SuperStageSysCache superStageSysCache;

    /**
     * 进入下一个阶段
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.SUPER_MATCH_NEXT_STAGE)
    public void gmNextStage(Role role, List<String> param) {
        messageDispatcher.dispatch(NextStageMessage.getInstance());
    }

    /**
     * 清理对手
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.CLEAN_OPPONENT)
    public void gmCleanOpponent(Role role, List<String> param) {
        messageDispatcher.dispatch(CleanOpponentMessage.getInstance());
    }

    /**
     * 重置次数
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.SUPER_STAGE_RESET)
    public void gmAddTimes(Role role, List<String> param) {
        RoleStageMatch roleStageMatch = stageMatchService.getOrCreate(role.getId(), false);
        roleStageMatch.dailyReset();
        roleStageMatchDao.update(roleStageMatch);
    }

    /**
     * 重置次数
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.PINNACLE_UPLOAD_ALL)
    public void gmUploadAll(Role role, List<String> param) {
        eventBus.post(PushAllOpponentEvent.getInstance());
    }

    /**
     * 重置次数
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.STAGE_MATCH_SET_STAGE)
    public void gmSetStage(Role role, List<String> param) {
        int stageId = Integer.parseInt(param.get(0));
        superStageSysCache.getOrThrow(stageId);
        messageDispatcher.dispatch(SetStageMessage.valueOf(role.getId(), stageId));
    }

}
