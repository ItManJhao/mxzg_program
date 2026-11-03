package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBattleRoundAddition;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;

/**
 * 战斗回合结束
 */
@Component
public class BattleRoundAdditionSysCache extends BaseExcelCache<CBattleRoundAddition> {

    private Multimap<Integer, CBattleRoundAddition> map = ArrayListMultimap.create();

    @Override
    public String getFileName() {
        return "battleroundaddition";
    }

    @Override
    protected void loadAfterReady() {
        List<CBattleRoundAddition> all = getAll();
        for (CBattleRoundAddition cBattleRoundAddition : all) {
            map.put(cBattleRoundAddition.getBattleType(), cBattleRoundAddition);
        }
    }

    /**
     * 根据战斗类型获取加成
     * @param battleType
     * @return
     */
    public Collection<CBattleRoundAddition> getAdditionByType(int battleType){
        return this.map.get(battleType);
    }
}
