package com.ayjs.mxzg.config.excel.cache.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupNpc;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.NpcFormation;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.TerritoryType;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Multimap;
import com.google.common.collect.Table;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * 讨伐团npc
 */
@Slf4j
@Component
public class CrusadeGroupNpcSysCache extends BaseExcelCache<CCrusadeGroupNpc> {

    /** areaId, buildLevel Map<领地类型， 阵容> */
    private Table<Integer, Integer, Multimap<TerritoryType, NpcFormation>> formations = HashBasedTable.create();
    /** teamId,阵容 */
    private Map<Integer, NpcFormation> teamFormation = new HashMap<>();


    @Override
    public String getFileName() {
        return "crusadegroupnpc";
    }

    @Override
    protected void loadAfterReady() {
        Collection<CCrusadeGroupNpc> all = getAll();
        Multimap<Integer, CCrusadeGroupNpc> teams = ArrayListMultimap.create();
        for (CCrusadeGroupNpc cCrusadeGroupNpc : all) {
            teams.put(cCrusadeGroupNpc.getTeam(), cCrusadeGroupNpc);
        }

        List<NpcFormation> npcFormations = new ArrayList<>();
        for (Integer teamId : teams.keySet()) {
            List<CCrusadeGroupNpc> npcList = (List<CCrusadeGroupNpc>)teams.get(teamId);
            NpcFormation formation = NpcFormation.of(teamId, npcList);
            npcFormations.add(formation);
            this.teamFormation.put(teamId, formation);
        }

        for (NpcFormation npcFormation : npcFormations) {
            Multimap<TerritoryType, NpcFormation> typeFormations = this.formations.get(npcFormation.getAreaLevel(), npcFormation.getBuildingLevel());

            if(typeFormations == null){
                typeFormations = ArrayListMultimap.create();
                this.formations.put(npcFormation.getAreaLevel(), npcFormation.getBuildingLevel(), typeFormations);
            }
            typeFormations.put(npcFormation.getType(), npcFormation);
        }

    }

    /**
     * 根据领地等级和领地类型获取阵容列表
     * @param areaLevel
     * @param buildLevel
     * @param type
     * @return
     */
    public List<NpcFormation> getFormationBy(int areaLevel, int buildLevel, TerritoryType type){
        Multimap<TerritoryType, NpcFormation> typeFormations = this.formations.get(areaLevel, buildLevel);
        if(typeFormations == null || typeFormations.isEmpty()){
            log.info("npc阵容数据获取失败areaLevel = {}, buildLevel = {}, type = {}", areaLevel, buildLevel, type.getCode());
        }
        return (List<NpcFormation>) typeFormations.get(type);
    }

    /**
     * 根据队伍id获取阵容
     * @param teamId
     * @return
     */
    public NpcFormation getFormation(int teamId){
        return this.teamFormation.get(teamId);
    }

}
