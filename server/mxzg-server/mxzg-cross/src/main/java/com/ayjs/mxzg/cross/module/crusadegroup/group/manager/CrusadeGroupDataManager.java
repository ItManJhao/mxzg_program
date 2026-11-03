package com.ayjs.mxzg.cross.module.crusadegroup.group.manager;

import cn.hutool.core.util.RandomUtil;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupBirthplaceSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupBuildSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupMapSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupNpcSysCache;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBirthplace;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBuild;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.NpcFormation;
import com.ayjs.mxzg.config.struct.Element;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrossCrusadeGroupDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeSystemDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrossCrusadeGroup;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeSystem;
import com.ayjs.mxzg.cross.module.crusadegroup.map.dao.CrossCrusadeGroupMapDao;
import com.ayjs.mxzg.cross.module.crusadegroup.map.dao.CrossCrusadersDao;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.CrossCrusadeGroupMap;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.CrossCrusaders;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.NpcForce;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

/**
 * 讨伐团数据管理器
 */
@Slf4j
@Component
public class CrusadeGroupDataManager {

    @Autowired
    private CrusadeSystemDao crusadeSystemDao;
    @Autowired
    private CrossCrusadersDao crossCrusadersDao;
    @Autowired
    private CrossCrusadeGroupDao crossCrusadeGroupDao;
    @Autowired
    private CrossCrusadeGroupMapDao crossCrusadeGroupMapDao;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private CrusadeGroupMapSysCache crusadeGroupMapSysCache;
    @Autowired
    private CrusadeGroupNpcSysCache crusadeGroupNpcSysCache;
    @Autowired
    private CrusadeGroupBirthplaceSysCache crusadeGroupBirthplaceSysCache;
    @Autowired
    private CrusadeGroupBuildSysCache crusadeGroupBuildingSysCache;

    /** Map<serverId,讨伐团> */
    private ConcurrentMap<Integer, CrossCrusadeGroup> serverGroups = new ConcurrentHashMap<>();

    /** Map<serverId,讨伐团所在的地图> */
    private ConcurrentMap<Integer, CrossCrusadeGroupMap> serverGroupMaps = new ConcurrentHashMap<>();

    /**
     * 加载数据
     */
    public void loadData(){
        log.info("开始加载讨伐团数据");
        List<CrossCrusadeGroupMap> maps = crossCrusadeGroupMapDao.listAll();
        for (CrossCrusadeGroupMap map : maps) {
            addMap(map);
        }

        List<CrossCrusadeGroup> groups = crossCrusadeGroupDao.listAll();
        for (CrossCrusadeGroup group : groups) {
            addGroup(group);
        }

        log.info("讨伐团数据加载完毕");
    }

    /**
     * 添加地图数据
     * @param map
     */
    public void addMap(CrossCrusadeGroupMap map){
        for (Integer serverId : map.getServer_id()) {
            serverGroupMaps.put(serverId, map);
        }
    }

    /**
     * 添加分组数据
     * @param group
     */
    public void addGroup(CrossCrusadeGroup group){
        for (Integer serverId : group.getServer_id()) {
            serverGroups.put(serverId, group);
        }
    }

    /**
     * 根据serverId获取讨伐团所属的场景数据
     * @param serverId
     * @return
     */
    public CrossCrusadeGroupMap getMapBy(int serverId){
        CrossCrusadeGroupMap map = this.serverGroupMaps.get(serverId);
        if(map == null){
            throw new RuntimeException(String.format("服务器%s讨伐团地图数据未找到", serverId));
        }
        return map;
    }

    /**
     * 根据serverId获取讨伐团
     * @param serverId
     * @return
     */
    public CrossCrusadeGroup getGroupBy(int serverId){
        CrossCrusadeGroup group = this.serverGroups.get(serverId);
//        if(group == null){
//            throw new RuntimeException(String.format("服务器%s讨伐团数据未找到", serverId));
//        }
        return group;
    }

    /**
     * 查找服务器所在讨伐团指定的坐标范围内的领地占领信息
     * @param serverId
     * @param bottomLeftX
     * @param bottomLeftY
     * @param upperRightX
     * @param upperRightY
     * @return
     */
    public List<Territory> getTerritoryRange(int serverId, int bottomLeftX, int bottomLeftY, int upperRightX, int upperRightY){
        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        CrossCrusadeGroupMap map = getMapBy(serverId);
        List<Territory> territories = new ArrayList<>();
        for (Integer territoryId : map.getOccupiedId().keySet()) {
            CCrusadeGroupMap crusadeGroupMap = crusadeGroupMapSysCache.getMap(territoryId);
            if (crusadeGroupMap.isInRange(bottomLeftX, bottomLeftY, upperRightX, upperRightY)) {
                int element = crusadeSystem.getElement(territoryId);
                long occupierId = map.getOccupiedId(territoryId);
                int heroId = map.isReclaim(territoryId) ? CrusadeGroupConst.DEFAULT_RECLAIM_HERO_ID : 0;
                territories.add(Territory.valueOf(territoryId, occupierId, element, heroId));
            }
        }
        return territories;
    }

    /**
     * 生成npc数据
     */
    public void generateNpc(){
        log.info("开始生成地图npc数据");
        CrusadeSystem system = crusadeSystemDao.get();
        Collection<CCrusadeGroupMap> maps = crusadeGroupMapSysCache.getAllMap();
        Map<Integer, Set<Integer>> npcTeamIds = new HashMap<>();
        for (CCrusadeGroupMap map : maps) {
            CCrusadeGroupBuild building = crusadeGroupBuildingSysCache.getBuild(map.getArea_level(), map.getBuilding_level(), map.getFight_type());
            List<NpcFormation> formations = crusadeGroupNpcSysCache.getFormationBy(map.getArea_level(), map.getBuilding_level(), map.getFight_type());
            if(building == null || CollectionUtils.isEmpty(formations)){
                log.error("领地怪物配置生成失败areaLevel = {}, buildLevel = {}, type = {}",map.getArea_level(), map.getBuilding_level(), map.getFight_type());
                continue;
            }
            Set<Integer> teamIds;
            if(formations.size() <= building.getMon_team()){
                teamIds = formations.stream().map(NpcFormation::getTeamId).collect(Collectors.toSet());
                if(teamIds.size() < building.getMon_team()){
                    log.error("领地{}配置怪物数量为{}波，实际最大可以生成{}波", map.getGroup_id(), building.getMon_team(), teamIds.size());
                }
            } else {
                Set<NpcFormation> formationSet = RandomUtil.randomEleSet(formations, building.getMon_team());
                teamIds = formationSet.stream().map(NpcFormation::getTeamId).collect(Collectors.toSet());
            }
            npcTeamIds.put(map.getGroup_id(), teamIds);
        }
        system.setTerritorialTeamIds(npcTeamIds);
        crusadeSystemDao.update(system);
        log.info("地图npc数据生成完毕共{}组", npcTeamIds.size());
    }

    /**
     * 生成元素
     */
    public void generateElement(){
        log.info("开始生成地图元素");
        List<Integer> list = Lists.newArrayList(CrusadeGroupConst.ELEMENT_RATE.keySet().iterator());
        list = list.stream().sorted(Integer::compareTo).collect(Collectors.toList());

        CrusadeSystem system = crusadeSystemDao.get();
        Collection<CCrusadeGroupMap> maps = crusadeGroupMapSysCache.getAllMap();
        Map<Integer, Integer> mapElement = new HashMap<>();

        for (CCrusadeGroupMap map : maps) {
            int randomNum = RandomUtils.nextInt(CrusadeGroupConst.ELEMENT_RATE_DENOMINATOR);
            int element = Element.DARK.getValue();
            for (Integer rate : list) {
                if(randomNum <= rate){
                    element = CrusadeGroupConst.ELEMENT_RATE.get(rate);
                    break;
                }
            }
            mapElement.put(map.getGroup_id(), element);
        }
        system.setTerritorialElements(mapElement);
        crusadeSystemDao.update(system);
        log.info("地图元素生成个数:{}", mapElement.size());
    }

    /**
     * 生成地图玩家出生点
     */
    public void generateBirthplace(){
        List<CCrusadeGroupBirthplace> allBirthplace = crusadeGroupBirthplaceSysCache.getAll();
        log.info("开始设置玩家出生点位置，配置出生点位置数量为:{}", allBirthplace.size());

        List<CrossCrusadeGroupMap> maps = crossCrusadeGroupMapDao.listAll();
        for (CrossCrusadeGroupMap map : maps) {
            int memberNumber = map.getRoleId().size();
            log.info("讨伐团地图{}的玩家数量为{}", map.getId(), memberNumber);
            int spacing = allBirthplace.size() / memberNumber;
            int birthplaceId = 1;
            for (Integer groupId : map.getGroupIds()) {
                CrossCrusadeGroup group = crossCrusadeGroupDao.get(groupId);
                for (Long member : group.getMembers()) {
                    CrossCrusaders crossCrusaders = crossCrusadersDao.getOrCreate(member);
                    CCrusadeGroupBirthplace birthplace = crusadeGroupBirthplaceSysCache.getOrThrow(birthplaceId);
                    crossCrusaders.setBirthplace(birthplace.getBirth_id());
                    crossCrusaders.setKnighthoodId(1);
                    crossCrusadersDao.update(crossCrusaders);

                    map.occupiedTerritory(member, birthplace.getBirth_id(), false);
                    crossCrusadeGroupMapDao.update(map);

                    birthplaceId += spacing;
                }
            }
        }
    }

    /**
     * 生成npc数据
     * @param territoryId
     * @return
     */
    public NpcForce generateNpcForce(int territoryId){
        NpcForce npcForce = new NpcForce();
        npcForce.setId(territoryId);

        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        Set<Integer> teamIds = crusadeSystem.getTeamIds(territoryId);
        List<NpcFormation> formations = teamIds.stream().map(crusadeGroupNpcSysCache::getFormation).collect(Collectors.toList());

        Map<Integer, BattlerVo> battlerVos = new HashMap<>();
        Map<Integer, Integer> fightingMap = new HashMap<>();
        for (NpcFormation formation : formations) {
            BattlerDo battlerDo = battleTemplate.queryNpcBattler(formation.getFormation(), Faction.DEFENDER, UnitType.MOSTER);
            BattlerVo battleVo = BattlerVo.createOf(battlerDo);
            battlerVos.put(formation.getTeamId(), battleVo);
            int fighting = battleTemplate.computeStrength(battlerDo);
            fightingMap.put(formation.getTeamId(), fighting);
        }
        npcForce.setBattlerVoMap(battlerVos);
        npcForce.setFightingMap(fightingMap);
        return npcForce;
    }

}
