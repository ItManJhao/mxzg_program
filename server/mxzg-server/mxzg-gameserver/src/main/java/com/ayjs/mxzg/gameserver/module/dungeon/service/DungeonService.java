package com.ayjs.mxzg.gameserver.module.dungeon.service;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.config.excel.entity.*;
import com.ayjs.mxzg.config.struct.EventModel;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonAgenitaEventEnum;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEnum;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonItemEnum;
import com.ayjs.mxzg.gameserver.module.dungeon.dao.DungeonDao;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.Dungeon;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class DungeonService {
    @Autowired
    private DungeonDao dungeonDao;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private ShelterEventGoldSysCache shelterEventGoldSysCache;
    @Autowired
    private ShelterEventStoneSysCache shelterEventStoneSysCache;
    @Autowired
    private ShelterEventFreeBoxSysCache shelterEventFreeBoxSysCache;
    @Autowired
    private ShelterEventKeyBoxSysCache shelterEventKeyBoxSysCache;
    @Autowired
    private SheltereventBuffSysCache sheltereventBuffSysCache;
    @Autowired
    private ShelterLevelSysCache shelterLevelSysCache;
    @Autowired
    private ShelterEventSysCache shelterEventSysCache;
    @Autowired
    private DungeonInfoService dungeonInfoService;

    public List<Dungeon> list(long rid) {
        List<Dungeon> list = dungeonDao.list("rid", rid);
        if (list.size() == 25) {
            return list;
        }
        Map<Integer, Map<Integer, Dungeon>> xyMap = ListMapUtil.fillTwoLayerMap(list, Dungeon::getGridX, Dungeon::getGridY);

        List<Dungeon> newList = new ArrayList<>();

        for (int x = 1; x <= 5; x++) {
            Map<Integer, Dungeon> yMap = xyMap.get(x);
            if (yMap == null) {
                yMap = new HashMap<>();
                xyMap.put(x, yMap);
            }
            for (int y = 1; y <= 5; y++) {
                Dungeon dungeon = yMap.get(y);
                if (dungeon == null) {
                    dungeon = new Dungeon();
                    dungeon.setRid(rid);
                    dungeon.setGridX(x);
                    dungeon.setGridY(y);
                    newList.add(dungeon);
                    yMap.put(y, dungeon);
                }
            }
        }
        if (!newList.isEmpty()) {
            this.insertList(newList);
        }
        return dungeonDao.list("rid", rid);
    }

    /**
     * 更新网格
     *
     * @param entity
     */
    public void update(Dungeon entity) {
        dungeonDao.update(entity);
    }

    /**
     * 指量更新网格
     *
     * @param entity
     */
    public void update(List<Dungeon> entity) {
        dungeonDao.update(entity);
    }

    /**
     * 批量添加地牢网格数据
     *
     * @param list
     */
    public void insertList(List<Dungeon> list) {
        dungeonDao.add(list);
    }

    /**
     * 获取某个网格数据
     *
     * @param rid
     * @param grid_x
     * @param grid_y
     * @return
     */
    public Dungeon selectOne(long rid, int grid_x, int grid_y) {
        Dungeon dungeon = null;
        List<Dungeon> list = list(rid);
        for (Dungeon model : list) {
            if (model.getGridX() == grid_x && model.getGridY() == grid_y) {
                dungeon = model;
            }
        }
        return dungeon;
    }

    /**
     * 获取庇护所所有怪物数据
     *
     * @return
     */
    public List<Dungeon> getMonsterDungeonList(long rid) {
        List<Dungeon> dungeonList = new ArrayList<>();
        for (Dungeon dungeon : list(rid)) {
            if (dungeon.getEventType() == DungeonEvent.BOSS_EVENT.getEventType()) {
                dungeonList.add(dungeon);
            }
        }
        return dungeonList;
    }

    /**
     * 获取庇护所怪物数据
     *
     * @param rid
     * @return
     */
    public Dungeon getMonsterDungeon(long rid, int iconLevel) {
        Dungeon dungeon = null;
        for (Dungeon dungeon1 : getMonsterDungeonList(rid)) {
            if (dungeon1.getEventDetail() == iconLevel) {
                dungeon = dungeon1;
            }
        }
        return dungeon;
    }

    /**
     * 还存活的boss列表
     *
     * @param rid
     * @return
     */
    public List<Dungeon> getAliveBoss(long rid) {
        List<Dungeon> list = new ArrayList<>();
        for (Dungeon dungeon : list(rid)) {
            if (dungeon.getEventType() != DungeonEvent.BOSS_EVENT.getEventType()) {
                continue;
            }
            if (dungeon.getEventDetail() != 0) {
                list.add(dungeon);
            }
        }
        return list;
    }


    private static final Integer[] randomEvent = new Integer[]{11, 12, 13, 14, 15, 21, 23, 25, 31, 32, 34, 35, 41, 43,
            45, 51, 52, 53, 54, 55};
    private static final Integer[] bossEvent = new Integer[]{22, 24, 42, 44, 33};


    public void resetDungeon(DungeonInfo dungeonInfo) {
        List<Dungeon> dungeonList = list(dungeonInfo.getRid());

        List<CShelterLevel> shelterLevelList = shelterLevelSysCache.getByStage(dungeonInfo.getNowStage());

        Map<Integer, Map<Integer, Dungeon>> xyMap = ListMapUtil.fillTwoLayerMap(dungeonList, Dungeon::getGridX, Dungeon::getGridY);
        //刷新BOSS事件的网格
        for (CShelterLevel cShelterLevel : shelterLevelList) {
            int gridX = bossEvent[cShelterLevel.getIcon_level() - 1] / 10;
            int gridY = bossEvent[cShelterLevel.getIcon_level() - 1] % 10;
            Dungeon dungeon = xyMap.get(gridX).get(gridY);
            setDungeonEvent(dungeon, DungeonEvent.BOSS_EVENT, cShelterLevel.getIcon_level());
            List<CShelterLevel> cShelterLevelList = new ArrayList<>();
            cShelterLevelList.add(cShelterLevel);
            //添加怪物数据
            dungeon.setBattlerVo(battleHelper.queryNpcBattler(cShelterLevelList, "庇护所NPC").toBattlerVo());
        }


        List<Integer> placeList = new ArrayList<>(Arrays.asList(randomEvent));

        int nowTime = TimeDateUtil.getCurrentTimeInt();
        long identity = nowTime * 100l;

        List<CShelterEvent> eventList = new ArrayList<>(shelterEventSysCache.getAll());
        Map<Integer, Integer> eventCountMap = new HashMap<>();//用于保存当前层事件出现的次数

        int keyBox = -1;

        for (int i = 0; i < placeList.size(); i++) {

            identity++;
            int place = placeList.get(i);
            int gridX = place / 10;
            int gridY = place % 10;
            Dungeon dungeon = xyMap.get(gridX).get(gridY);

            //让事件未出现次数+1
            Map<Integer, Integer> map = new HashMap<>(dungeonInfo.getEventMap());
            map.forEach((key, value) -> {
                dungeonInfo.getEventMap().put(key, value + 1);
            });

            if (keyBox == i) {//当前事件为钥匙宝箱事件
                continue;
            }

            //先获取当前次必出的事件
            List<CShelterEvent> eventList2 = new ArrayList<>();
            dungeonInfo.getEventMap().forEach((k, v) -> {
                CShelterEvent cShelterEvent = shelterEventSysCache.getOrThrow(k);
                if (cShelterEvent.getGuarantee_times() > 0 && cShelterEvent.getGuarantee_times() <= v &&
                        cShelterEvent.getMax_each_level() > eventCountMap.getOrDefault(cShelterEvent.getIdx(), 0)) {
                    eventList2.add(cShelterEvent);
                }
            });

            CShelterEvent cShelterEvent = null;
            if (eventList2.size() > 0) {
                cShelterEvent = DropUtil.randomDrop(eventList2, CShelterEvent::getIdx, CShelterEvent::getChance);
                updateDungeonEvent(dungeon, identity, cShelterEvent.getIdx(), eventCountMap, dungeonInfo);
            } else {
                cShelterEvent = DropUtil.randomDrop(eventList, CShelterEvent::getIdx, CShelterEvent::getChance);
                updateDungeonEvent(dungeon, identity, cShelterEvent.getIdx(), eventCountMap, dungeonInfo);
            }

            //如果抽取到钥匙事件，对应解锁宝箱事件
            if (cShelterEvent.getIdx() == DungeonEvent.KEY_EVENT.getEventType()) {
                identity++;
                int index = 0;
                if (i >= placeList.size() - 1) {//若当前为最后一个网格数据,将除了钥匙事件的任一网格变为钥匙宝箱事件
                    index = RandomUtil.rand(0, placeList.size() - 2);
                } else {//将后面的任一网格变为宝箱事件
                    index = RandomUtil.rand(i + 1, placeList.size());
                    keyBox = index;
                }
                place = placeList.get(index);
                gridX = place / 10;
                gridY = place % 10;
                dungeon = xyMap.get(gridX).get(gridY);
                updateDungeonEvent(dungeon, identity, DungeonEvent.KEY_BOX_EVENT.getEventType(), eventCountMap, dungeonInfo);
            }

            //删除已达当前层出现最大次数的事件
            eventList = eventList.stream().filter(cShelterEvent1 ->
                    eventCountMap.getOrDefault(cShelterEvent1.getIdx(), 0) < cShelterEvent1.getMax_each_level()).collect(Collectors.toList());
        }
        this.update(dungeonList);
        dungeonInfoService.update(dungeonInfo);
    }

    private void updateDungeonEvent(Dungeon dungeon, long identity, int eventType, Map<Integer, Integer> eventCountMap, DungeonInfo dungeonInfo) {
        //添加事件内容
        addEventDungeon(eventType, dungeon, identity);
        //当前层该事件出现次数+1
        eventCountMap.put(eventType, eventCountMap.getOrDefault(eventType, 0) + 1);
        //清空未出现次数
        dungeonInfo.getEventMap().put(eventType, 0);
    }


    private void setDungeonEvent(Dungeon dungeon, DungeonEvent eventType, long eventDetail) {
        if (eventType == DungeonEvent.NO_EVENT) {//此处为配置前端奖空事件改为0
            dungeon.setEventType(0);
        } else {
            dungeon.setEventType(eventType.getEventType());
        }
        dungeon.setEventDetail(eventDetail);
        if (eventType == DungeonEvent.BOSS_EVENT) {
            dungeon.setIsOpen(1);
        } else {
            dungeon.setIsOpen(0);
        }
        dungeon.setGridType(RandomUtil.rand(1, DungeonEnum.GRID_TYPE2_MAZ.getType() + 1));
    }


    /**
     * 添加事件网格
     *
     * @param eventType
     * @param dungeon
     * @param identity  事件的唯一标记，看网格事件的类型决定是否使用
     */
    private void addEventDungeon(int eventType, Dungeon dungeon, long identity) {

        if (eventType == DungeonEvent.NO_EVENT.getEventType()) {

            setDungeonEvent(dungeon, DungeonEvent.NO_EVENT, 0);

        } else if (eventType == DungeonEvent.GOLD_EVENT.getEventType()) {

            CShelterEventGold cShelterEventGold = RandomUtil.getRand(shelterEventGoldSysCache.getAll());
            setDungeonEvent(dungeon, DungeonEvent.GOLD_EVENT, cShelterEventGold.getIdx());

        } else if (eventType == DungeonEvent.STONE_EVENT.getEventType()) {

            CShelterEventStone cShelterEventStone = RandomUtil.getRand(shelterEventStoneSysCache.getAll());
            setDungeonEvent(dungeon, DungeonEvent.STONE_EVENT, cShelterEventStone.getIdx());

        } else if (eventType == DungeonEvent.KEY_EVENT.getEventType()) {

            setDungeonEvent(dungeon, DungeonEvent.KEY_EVENT, 1);

        } else if (eventType == DungeonEvent.KEY_BOX_EVENT.getEventType()) {

            List<CShelterEventKeyBox> list = shelterEventKeyBoxSysCache.getAll();
            CShelterEventKeyBox cShelterEventKeyBox = DropUtil.randomDrop(list);
            setDungeonEvent(dungeon, DungeonEvent.KEY_BOX_EVENT, cShelterEventKeyBox.getIdx());

        } else if (eventType == DungeonEvent.BUFF_EVENT.getEventType()) {

            List<CSheltereventBuff> list = sheltereventBuffSysCache.getAll();
            CSheltereventBuff cSheltereventBuff = DropUtil.randomDrop(list);
            setDungeonEvent(dungeon, DungeonEvent.BUFF_EVENT, cSheltereventBuff.getIdx());

        } else if (eventType == DungeonEvent.HP_EVENT.getEventType()) {

            setDungeonEvent(dungeon, DungeonEvent.HP_EVENT, DungeonAgenitaEventEnum.HP_AGENTIA.getType());

        } else if (eventType == DungeonEvent.SHOP_EVENT.getEventType()) {

            setDungeonEvent(dungeon, DungeonEvent.SHOP_EVENT, identity);

        } else if (eventType == DungeonEvent.SUMMON_SHOP_EVENT.getEventType()) {

            setDungeonEvent(dungeon, DungeonEvent.SUMMON_SHOP_EVENT, DungeonItemEnum.SHOP_AGENTIA.getItemType());

        } else if (eventType == DungeonEvent.DISPEL_EVENT.getEventType()) {

            setDungeonEvent(dungeon, DungeonEvent.DISPEL_EVENT, DungeonAgenitaEventEnum.NPC_AGENTIA.getType());

        } else if (shelterEventFreeBoxSysCache.getEventIdList().contains(eventType)) {

            freeBoxEventExcel(DungeonEvent.valueOf(eventType), dungeon);

        }
    }

    /**
     * 根据事件获取item
     *
     * @param dungeonEvent
     * @param dungeon
     */
    private void freeBoxEventExcel(DungeonEvent dungeonEvent, Dungeon dungeon) {

        List<CShelterEventFreeBox> list = shelterEventFreeBoxSysCache.getItemMap(dungeonEvent.getEventType());

        CShelterEventFreeBox cShelterEventFreeBox = DropUtil.randomDrop(list, CShelterEventFreeBox::getIdx, CShelterEventFreeBox::getChance);

        setDungeonEvent(dungeon, dungeonEvent, cShelterEventFreeBox.getIdx());
    }

}
