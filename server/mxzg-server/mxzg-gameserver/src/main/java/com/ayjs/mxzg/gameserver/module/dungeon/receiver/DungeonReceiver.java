package com.ayjs.mxzg.gameserver.module.dungeon.receiver;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonInfo;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonInfoService;

@Component
public class DungeonReceiver implements Receivers {

    @Autowired
    private DungeonInfoService dungeonInfoService;

    @Invoker(Invoker.Priority.HIGHEST)
    public void onQueryBattlerCommand(BattleCommand battleCommand) {
        if (battleCommand.getBattleType() != BattleType.SHELTER) {
            return;
        }
        List<HeroDo> heroDos = battleCommand.getAttacker().getHeros();
        DungeonInfo dungeonInfo = dungeonInfoService.select(battleCommand.getAttacker().getPlayerId());
        heroDos.forEach(heroDo -> {
            heroDo.getAttributeInfo().addTemporaryAttribute(dungeonInfo.getBuff());
        });
    }

}
