package com.ayjs.mxzg.gameserver.module.stagematch.battle.observer;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.event.LineUpChangeEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.StageMathConstant;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.RoleStageMatchLogDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.MatchLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatchLog;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.event.PushAllOpponentEvent;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.event.StageMatchBattleEvent;
import com.ayjs.mxzg.gameserver.remote.large.event.StageCrossConnectEvent;
import com.ayjs.mxzg.message.module.stagematch.ReportOpponentMessage;
import com.ayjs.mxzg.message.module.stagematch.StageMatchReqMessage;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.CollectionUtils;

@Slf4j
@Observer
public class StageMatchObserver {


    @Value("${server.id}")
    private int serverId;
    @Autowired
    private RoleService roleService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private RoleStageMatchLogDao roleStageMatchLogDao;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private CommandBus commandBus;


    @Subscribe
    public void listen(StageCrossConnectEvent event) {
        log.info("请求段位赛信息。。。");
        messageDispatcher.dispatch(StageMatchReqMessage.getInstance());
    }

    /**
     * 登录时上传满足的玩家数据到跨服
     * @param event
     */
    @Subscribe
    public void onLoginEvent(LoginEvent event){
        Role role = roleService.getOrThrow(event.getRid());
        COpenCondition openCondition = openConditionSysCache.getCondition(StageMathConstant.FUNCTION_OPEN_NAME);
        if(openCondition == null){
            return;
        }

        if(role.getLevel() < openCondition.getCondition_value()){
            return;
        }

        pushOpponentInfoToCross(event.getRid());
    }

    /**
     * 登录时上传满足的玩家数据到跨服
     * @param event
     */
    @Subscribe
    public void onRoleLvUpEvent(RoleLvUpEvent event){
        COpenCondition openCondition = openConditionSysCache.getCondition(StageMathConstant.FUNCTION_OPEN_NAME);
        if(openCondition == null){
            return;
        }

        if(event.getNewLv() < openCondition.getCondition_value()){
            return;
        }

        pushOpponentInfoToCross(event.getRid());
    }

    @Subscribe
    public void onLineUpChangeEvent(LineUpChangeEvent event) {
        if(event.getHeroLineUp().getType() == LineUpType.STAGE_MATCH.getValue()){
            pushOpponentInfoToCross(event.getHeroLineUp().getRid());
        }
    }

    /**
     * 推送对手信息到跨服
     * @param rid
     */
    private void pushOpponentInfoToCross(long rid){
        Role role = roleService.getOrThrow(rid);
        BattlerDo battlerDo = battleHelper.queryBattlerOrMain(BattleType.STAGE_MATCH, rid, Faction.ATTACKER);
        if(CollectionUtils.isEmpty(battlerDo.getHeros())){
            return;
        }
        String battleVoStr = JSON.toJSONString(battlerDo.toBattlerVo());
        ReportOpponentMessage message = ReportOpponentMessage.createOf(rid, serverId, role.getNick(), role.getImageId(), battleVoStr, battlerDo.getFighting(), role.getLevel());
        messageDispatcher.dispatch(message);
    }

    @Subscribe
    public void pushAllOpponentToCross(PushAllOpponentEvent event){
        for (Role role : roleService.getAllRole()) {
            pushOpponentInfoToCross(role.getId());
        }
    }

    /**
     * 响应段位赛战斗事件
     * @param event
     */
    @Subscribe
    public void onStageMatchBattleEvent(StageMatchBattleEvent event){
        MatchLog matchLog = event.getMatchlog();
        RoleStageMatchLog roleStageMatchLog = roleStageMatchLogDao.getOrCreate(event.getRid());
        roleStageMatchLog.addLog(matchLog);
        roleStageMatchLogDao.update(roleStageMatchLog);

        SaveBattleReportCommand command = SaveBattleReportCommand.of(event.getBattleReport());
        commandBus.invoke(command);
    }

}
