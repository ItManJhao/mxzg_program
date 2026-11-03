package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.observer;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
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
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.StageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.StageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.event.PushAllOpponentEvent;
import com.ayjs.mxzg.gameserver.remote.large.event.StageCrossConnectEvent;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.LeaderBoardReqMessage;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.ReportLadderMessage;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.CollectionUtils;

@Slf4j
@Observer
public class PreliminariesObserver {


    @Value("${server.id}")
    private int serverId;
    @Autowired
    private RoleService roleService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private StageMatchDao stageMatchDao;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private MessageDispatcher messageDispatcher;


    /**
     * 跨服连接后获取排行榜
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void getCrossRank(StageCrossConnectEvent event) {
        messageDispatcher.dispatch(LeaderBoardReqMessage.getInstance());
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

        StageMatch stageMatch = stageMatchDao.get();
        if(stageMatch.isRegularSeason()){
            return;
        }

        pushOpponentInfoToCross(event.getRid());
    }

    @Subscribe
    public void onLineUpChangeEvent(LineUpChangeEvent event) {
        if(event.getHeroLineUp().getType() == LineUpType.PINNACLE.getValue()){
            pushOpponentInfoToCross(event.getHeroLineUp().getRid());
        }
    }

    /**
     * 推送对手信息到跨服
     * @param rid
     */
    private void pushOpponentInfoToCross(long rid){
        Role role = roleService.getOrThrow(rid);
        BattlerDo battlerDo = battleHelper.queryBattlerOrMain(BattleType.PINNACLE, rid, Faction.ATTACKER);
        if(CollectionUtils.isEmpty(battlerDo.getHeros())){
            return;
        }
        String battleVoStr = JSON.toJSONString(battlerDo.toBattlerVo());
        ReportLadderMessage message = ReportLadderMessage.createOf(rid, serverId, role.getNick(), role.getImageId(), battleVoStr, battlerDo.getFighting(), role.getLevel());
        messageDispatcher.dispatch(message);
    }

    @Subscribe
    public void pushAllOpponentToCross(PushAllOpponentEvent event){
        for (Role role : roleService.getAllRole()) {
            pushOpponentInfoToCross(role.getId());
        }
    }

}
