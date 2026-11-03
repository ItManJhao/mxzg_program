package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.receiver;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeFleetSkillSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleetSkill;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetSkillEnum;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SpaceTimeReceiver implements Receivers {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private SpaceTimeFleetSkillSysCache spaceTimeFleetSkillSysCache;

    @Invoker(Invoker.Priority.HIGHEST)
    public void onQueryBattlerCommand(BattleCommand battleCommand) {
        if (battleCommand.getBattleType() == BattleType.SPACE_TIME_WEAPON ||
                battleCommand.getBattleType() == BattleType.SPACE_TIME_IMPETUS ||
                battleCommand.getBattleType() == BattleType.SPACE_TIME_MONSTER) {

            SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(battleCommand.getAttacker().getPlayerId());
            if (spaceTimeInfo.getSkillMap().get(FleetSkillEnum.WU_QI_XI_TONG.getType()) > 1) {

                CSpaceTimeFleetSkill cSpaceTimeFleetSkill = spaceTimeFleetSkillSysCache.getSkill(FleetSkillEnum.WU_QI_XI_TONG.getType(),
                        spaceTimeInfo.getSkillMap().get(FleetSkillEnum.WU_QI_XI_TONG.getType()));
                //添加BUFF
                battleCommand.getAttacker().getHeros().forEach(heroDo -> {
                    heroDo.getAttributeInfo().addTemporaryAttribute(cSpaceTimeFleetSkill.getAbility());
                });
            }
        }
    }
}
