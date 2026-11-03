package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGuideBattle;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.KindType;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class GuideBattleSysCache extends BaseExcelCache<CGuideBattle> implements MonsterTeamCheck {


    @Override
    public String getFileName() {
        return "guidebattle";
    }

    @Override
    protected void loadAfterReady() {
        List<CGuideBattle> all = getAll();
        for (CGuideBattle guideBattle : all) {
            AttributeKind kind = AttributeKind.valueOf(AttributeType.ATTACK.getValue(), guideBattle.getAtk_multiple(), KindType.ADDITION);
            guideBattle.setAttr(Arrays.asList(kind));
        }
    }

    /**
     * 根据阵容获取英雄列表
     *
     * @param faction
     * @return
     */
    public List<CGuideBattle> getHerosBy(int faction) {
        List<CGuideBattle> all = getAll();
        return all.stream().filter(hero -> hero.getTeam() == faction).collect(Collectors.toList());
    }

    @Override
    public List<List<CGuideBattle>> getAllTeams() {
        return ImmutableList.copyOf(getAll().stream().collect(Collectors.groupingBy(CGuideBattle::getTeam)).values());
    }
}