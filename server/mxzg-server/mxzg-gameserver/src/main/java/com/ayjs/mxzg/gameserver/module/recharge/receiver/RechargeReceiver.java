package com.ayjs.mxzg.gameserver.module.recharge.receiver;


import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.PeerageEmblemSysCache;
import com.ayjs.mxzg.config.excel.entity.CPeerageEmblem;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import sun.security.krb5.Config;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 尊贵标识
 *
 * @author hyx
 */
@Component
public class RechargeReceiver implements Receivers {

    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private PeerageEmblemSysCache peerageEmblemSysCache;

    @Invoker
    public void onQueryBattleCommand(QueryBattleCommand command) {
        setAttributeAddition(command.getPlayerId(), command.getHeros());
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        setAttributeAddition(command.getPlayerId(), command.getHeroDos());
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        setAttributeAddition(command.getHero().getRid(), Lists.newArrayList(command.getHeroDo()));
    }


    private void setAttributeAddition(long playerId, List<HeroDo> heroDos) {

        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(playerId);
        //获取属性增益
        Map<AttributeType, Long> map = new HashMap<>();
        peerageEmblemSysCache.getAll().stream().filter(config -> config.getRecharge() <= roleRecharge.getTotalRecharge()).forEach(config -> {
            config.getAbility().forEach((k, v) -> {
                map.put(k, map.getOrDefault(k, 0L) + v);
            });
        });

        for (HeroDo heroDo : heroDos) {
            heroDo.getAttributeInfo().addAllAttribute(map);
        }

    }

}
