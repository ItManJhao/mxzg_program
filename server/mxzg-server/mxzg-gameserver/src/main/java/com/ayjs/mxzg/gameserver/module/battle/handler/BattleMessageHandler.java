package com.ayjs.mxzg.gameserver.module.battle.handler;

import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.ladder.service.LadderService;
import com.ayjs.mxzg.message.module.study.ReqBattlerVOMessage;
import com.ayjs.mxzg.message.module.study.ResBattlerVOMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.util.ProtostuffUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 战场消息接口
 */
@Component
public class BattleMessageHandler implements MessageHandler {

    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private LadderService ladderService;

    @RemoteMethod
    public ResBattlerVOMessage handleReqBattlerVOMessage(ReqBattlerVOMessage message) {
        BattleType type = BattleType.valueOf(message.getType());
        BattlerDo battlerDo = null;
        if (type == BattleType.LADDER_DEFEND) {
            HeroLineUp lineUpByType = heroLineUpService.getLineUpByType(message.getOpponentId(), LineUpType.LADDER_DEFENDER);
            if (lineUpByType.getFormationMap().size() == 0) {
                battlerDo = battleHelper.queryPlayerBattler(BattleType.MAIN, message.getOpponentId(), Faction.DEFENDER);
            } else {
                battlerDo = battleHelper.queryPlayerBattler(BattleType.LADDER_DEFEND, message.getOpponentId(), Faction.DEFENDER);
            }
        } else {
            battlerDo = battleHelper.queryPlayerBattler(type, message.getOpponentId(), Faction.DEFENDER);
        }
        BattlerVo battlerVo = battlerDo.toBattlerVo();
        byte[] bytes = ProtostuffUtil.serialize(battlerVo);
        return ResBattlerVOMessage.of(bytes, battlerDo.getServerId(), battlerDo.getName(), battlerDo.getHeadId(), battlerDo.getBorderId(), battlerDo.getLevel(), battlerDo.getFighting());
    }

}
