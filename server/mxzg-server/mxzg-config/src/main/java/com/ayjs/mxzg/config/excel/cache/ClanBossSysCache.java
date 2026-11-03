package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanBoss;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class ClanBossSysCache extends BaseExcelCache<CClanBoss> implements MonsterTeamCheck {


    @Override
    public String getFileName() {
        return "clanboss";
    }

    @Override
    public List<List<CClanBoss>> getAllTeams() {
        Map<Integer, List<CClanBoss>> collect = getAll().stream().collect(Collectors.groupingBy(CClanBoss::getBoss));
        return ImmutableList.copyOf(collect.values());
    }

}