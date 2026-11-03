package com.ayjs.mxzg.battle.service;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.OptionalInt;
import java.util.stream.Collectors;

@Component
public class BattleTimeHelper {

    /**
     * 计算回合buff持续时间
     * @param round
     * @param buffType
     * @return
     */
    public int calRoundBuffTime(BattleGMsg.CombatRound.Builder round, BuffType buffType){
        if(buffType == BuffType.BT_FIXED_ROUND){
            return 0;
        }
        List<BattleGMsg.BuffInfo> buffInfos = buffType == BuffType.BT_ROUND_END ? round.getAfterRoundBuffsList() : round.getBuffInfoList();
        Map<Integer, List<BattleGMsg.BuffInfo>> map = buffInfos.stream().collect(Collectors.groupingBy(BattleGMsg.BuffInfo::getTargetUnitId));
        OptionalInt maxBuff = map.values().stream().mapToInt(buffs-> buffs.size()).max();
        return maxBuff.orElse(0) * BattleConstant.BUFF_INTERVAL_TIME;
    }
}
