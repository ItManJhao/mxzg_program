package com.ayjs.mxzg.gameserver.module.tower.converter;

import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaiders;
import com.ayjs.mxzg.protocol.TowerGMsg;
import org.springframework.stereotype.Component;

@Component
public class TowerConverter {

    public TowerGMsg.TowerLog convertFrom(TowerRaiders raiders){
        if(raiders == null){
            return null;
        }
        TowerGMsg.TowerLog.Builder builder = TowerGMsg.TowerLog.newBuilder();
        builder.setAbility(raiders.getAbility());
        builder.setDuration(raiders.getDuration());
        builder.setBattleId(raiders.getBattleId());
        builder.setRoleName(raiders.getNickName());
        return builder.build();
    }

}
