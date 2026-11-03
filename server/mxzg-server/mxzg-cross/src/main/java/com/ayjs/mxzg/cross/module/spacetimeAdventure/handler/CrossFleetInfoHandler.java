package com.ayjs.mxzg.cross.module.spacetimeAdventure.handler;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeBotRoleSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeBotSysCache;
import com.ayjs.mxzg.config.excel.constant.SpaceTimeAdventureConst;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeBot;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeBotRole;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.spacetimeAdventure.domain.CrossFleetInfo;
import com.ayjs.mxzg.cross.module.spacetimeAdventure.service.CrossFleetInfoService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.spacetimeAdventure.SpaceTimeChooseInfoReqMessage;
import com.ayjs.mxzg.message.module.spacetimeAdventure.SpaceTimeChooseInfoResMessage;
import com.ayjs.mxzg.message.module.spacetimeAdventure.SpaceTimeUpdateInfoReqMessage;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.util.ProtostuffUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 时空冒险航行阵容跨服数据
 *
 * @author hyx
 */
@Component
public class CrossFleetInfoHandler implements MessageHandler {

    @Autowired
    private CrossFleetInfoService crossFleetInfoService;
    @Autowired
    private SpaceTimeBotSysCache spaceTimeBotSysCache;
    @Autowired
    private SpaceTimeBotRoleSysCache spaceTimeBotRoleSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private CrossServerGroupService crossServerGroupService;

    /**
     * 上传航行数据
     *
     * @param message
     * @param connection
     */
    @RemoteMethod
    public void uploadingLineUp(SpaceTimeUpdateInfoReqMessage message, Connection connection) {
        CrossFleetInfo crossFleetInfo = crossFleetInfoService.getInfo(message.getRid());
        if (crossFleetInfo == null) {
            crossFleetInfo = new CrossFleetInfo();
            crossFleetInfo.setRid(message.getRid());
            crossFleetInfoService.add(crossFleetInfo);
        }
        crossFleetInfo.setNick(message.getNick());
        crossFleetInfo.setServerId(message.getServerId());
        crossFleetInfo.setMaxFighting(message.getMaxFighting());
        for (Map.Entry<Integer, byte[]> entry : message.getBattlerMap().entrySet()) {
            crossFleetInfo.getBattlerVoMap().put(entry.getKey(), ProtostuffUtil.deserialize(entry.getValue(), BattlerVo.class));
        }
        crossFleetInfoService.update(crossFleetInfo);
    }

    /**
     * 匹配对手
     *
     * @param message
     * @param connection
     */
    @RemoteMethod
    public void chooseEnemyInfo(SpaceTimeChooseInfoReqMessage message, Connection connection) {
        SpaceTimeChooseInfoResMessage.SpaceTimeChooseInfoResMessageBuilder builder = SpaceTimeChooseInfoResMessage.builder();
        builder.rid(message.getRid());
        //战力上限
        long fightingUp = message.getFighting() * SpaceTimeAdventureConst.SPACETIME_FIGHTING_UP / GameConstant.WAN;
        //战力下限
        long fightingDown = message.getFighting() * SpaceTimeAdventureConst.SPACETIME_FIGHTING_DOWN / GameConstant.WAN;
        //匹配对手集，不包括自身。
        List<CrossFleetInfo> infoList = crossFleetInfoService.getInfoList().stream().filter(info -> info.getMaxFighting() > fightingDown
                && info.getMaxFighting() < fightingUp && info.getRid() != message.getRid() && !info.getNick().equals(message.getLastEnemy())).collect(Collectors.toList());
        if (!infoList.isEmpty()) {
            CrossFleetInfo crossFleetInfo = RandomUtil.getRand(infoList);
            builder.isTurn(true);
            builder.serverId(crossFleetInfo.getServerId());
            builder.nick(crossFleetInfo.getNick());
            Map<Integer, byte[]> battlerMap = new HashMap<>();
            for (Map.Entry<Integer, BattlerVo> map : crossFleetInfo.getBattlerVoMap().entrySet()) {
                battlerMap.put(map.getKey(), ProtostuffUtil.serialize(map.getValue()));
            }
            builder.battlerMap(battlerMap);
        } else {//匹配机器人.根据等级获取当前等级对应的机器人
            List<CSpaceTimeBotRole> botRoleList = spaceTimeBotRoleSysCache.getBotList(message.getLevel());
            CSpaceTimeBotRole cSpaceTimeBotRole = RandomUtil.getRand(botRoleList);
            //机器人名字
            CLanguage cLanguage = languageSysCache.getByKey(cSpaceTimeBotRole.getName_lang());
            String defNick = languageHelper.getLanguageBy(cLanguage);
            //机器人阵容
            Map<Integer, byte[]> battlerMap = new HashMap<>();
            for (Map.Entry<Integer, List<CSpaceTimeBot>> map : spaceTimeBotSysCache.getMap(cSpaceTimeBotRole.getBot_id()).entrySet()) {
                BattlerDo battlerDo = battleTemplate.queryBattler(map.getValue(), defNick, Faction.DEFENDER, UnitType.HERO);
                battlerMap.put(map.getKey(), ProtostuffUtil.serialize(battlerDo.toBattlerVo()));
            }

            builder.isTurn(true);
            builder.nick(defNick);
            builder.battlerMap(battlerMap);
            //机器人服务器
            CrossGroup crossGroup = crossServerGroupService.getCrossGroup(message.getServerId());
            List<Integer> serverIds = new ArrayList<>();
            if (crossGroup.getServerIds().size() == 1) {
                serverIds.addAll(crossGroup.getServerIds());
            } else {
                serverIds = crossGroup.getServerIds().stream().filter(integer -> integer != message.getServerId()).collect(Collectors.toList());
            }
            builder.serverId(RandomUtil.getRand(serverIds));
        }
        connection.send(builder.build());
    }


}
