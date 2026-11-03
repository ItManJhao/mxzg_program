package com.ayjs.mxzg.gameserver.module.dreamland.receiver;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.DreamlandBuffSysCache;
import com.ayjs.mxzg.config.excel.entity.CDreamlandBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.gameserver.module.dreamland.domin.Dreamland;
import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandService;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class DreamlandReceiver implements Receivers {

    @Autowired
    private DreamlandService dreamlandService;
    @Autowired
    private DreamlandBuffSysCache dreamlandBuffSysCache;

    @Invoker(Invoker.Priority.HIGHEST)
    public void onQueryBattlerCommand(BattleCommand battleCommand) {

        if (battleCommand.getBattleType() != BattleType.DREAMLAND) {
            return;
        }

        Dreamland dreamland = dreamlandService.loadAndRefresh(battleCommand.getAttacker().getPlayerId());
        CDreamlandBuff cDreamlandBuff = dreamlandBuffSysCache.getOrThrow(dreamland.getCurrBuffId());

        if (cDreamlandBuff.getAdd_type() == 0 && dreamland.getBuffValid() >= 1){
            return;
        }
        addBuff(battleCommand, dreamland, cDreamlandBuff);

    }

    private void addBuff(BattleCommand battleCommand, Dreamland dreamland, CDreamlandBuff cDreamlandBuff) {
        //生成BUFF
        Map<AttributeType, Long> buffMap = new HashMap<>();
        cDreamlandBuff.getBuff_id().forEach(attributeKind -> {
            AttributeType attributeType = AttributeType.valueOf(attributeKind.getAttr());
            if (attributeType == AttributeType.RECOVER_HP) {
                //dreamland.getBattlerVo().wholeBloodPercent((int) attributeKind.getValue());
            } else {
                buffMap.put(AttributeType.valueOf(attributeKind.getAttr()), attributeKind.getValue());
            }
        });
        //添加BUFF
        battleCommand.getAttacker().getHeros().forEach(heroDo -> {
            heroDo.getAttributeInfo().addTemporaryAttribute(buffMap);
        });
    }

}
