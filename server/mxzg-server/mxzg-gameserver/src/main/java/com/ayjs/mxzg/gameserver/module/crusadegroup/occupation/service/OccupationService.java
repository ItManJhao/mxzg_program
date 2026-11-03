package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupMapSysCache;
import com.ayjs.mxzg.config.excel.cache.occupation.OccupationSysCache;
import com.ayjs.mxzg.config.excel.cache.occupation.OccupationTaskSysCache;
import com.ayjs.mxzg.config.excel.cache.shenbin.ShenBinSysCache;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.ayjs.mxzg.config.excel.entity.occupation.COccupationTask;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBin;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.service.GroupService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.dao.OccupationTaskDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.domain.OccupationTask;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.*;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.event.ShenBinCoreUpEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.service.ShenBinService;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.protocol.CrusadeGroupOccupationGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Observer
@Service
public class OccupationService {

    @Autowired
    private OccupationTaskDao occupationTaskDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private OccupationTaskSysCache occupationTaskSysCache;
    @Autowired
    private OccupationSysCache occupationSysCache;
    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private ShenBinSysCache shenBinSysCache;
    @Autowired
    private ShenBinService shenBinService;
    @Autowired
    private GroupService groupService;
    @Autowired
    private CrusadeGroupMapSysCache crusadeGroupMapSysCache;

    public List<OccupationTask> getOccupationTasks(long rid) {
        return occupationTaskDao.list("rid", rid);
    }

    public List<OccupationTask> getOccupationTasks_taskId(int taskId) {
        return occupationTaskDao.list("taskId", taskId);
    }

    public OccupationTask getOccupationTask(long rid, int taskId) {
        List<OccupationTask> list = getOccupationTasks(rid);
        for (OccupationTask occupationTask : list) {
            if (occupationTask.getTaskId() == taskId) {
                return occupationTask;
            }
        }
        OccupationTask occupationTask = new OccupationTask();
        occupationTask.setRid(rid);
        occupationTask.setTaskId(taskId);
        occupationTask.setCount(0);
        occupationTask.setCondition(-1);
        occupationTask.setComplete_type(-1);
        occupationTaskDao.add(occupationTask);
        return occupationTask;
    }

    //更新任务数据
    public void updateOccupationTask(OccupationTask occupationTask) {
        occupationTaskDao.update(occupationTask);
    }

    //推送任务信息给客户端，并且保存数据
    private void sendTaskInfoMSG(long rid, List<OccupationTask> list) {
        if (CollectionUtil.isEmpty(list)) {
            return;
        }
        //先保存数据
        occupationTaskDao.update(list);
        //发送消息
        CrusadeGroupOccupationGMsg.GResSendOccupationTaskInfo.Builder builder = CrusadeGroupOccupationGMsg.GResSendOccupationTaskInfo.newBuilder();
        for (OccupationTask occupationTask : list) {
            CrusadeGroupOccupationGMsg.PSOccupationTaskInfo.Builder taskInfo = CrusadeGroupOccupationGMsg.PSOccupationTaskInfo.newBuilder();
            taskInfo.setTaskId(occupationTask.getTaskId());
            taskInfo.setTargetCount(occupationTask.getCount());//计数
            taskInfo.setCondition(occupationTask.getCondition());
            taskInfo.setCompleteType(occupationTask.getComplete_type());
            builder.addTaskInfo(taskInfo);
        }
        contextManager.write(rid, CmdCode._75608, builder.build());
    }

    //占领[1]个[2]级以上的城邦
    @Subscribe
    public void listen(CityOccupyEvent event) {
        long rid = event.getRid();
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        Map<Integer, Territory> territoryInfo = roleCrusadeGroup.getTerritoryInfo();
        if (CollectionUtil.isEmpty(territoryInfo)) {
            return;
        }
        List<COccupationTask> templates_taskTyp = occupationTaskSysCache.getCOccupationTaskTemplate_taskType(TargetType.OCCUPATION_LAND_HOLD.getValue());
        List<OccupationTask> list = new ArrayList<>();
        Map<Integer, Integer> addNumMap = new HashMap<>();//统计数据 key：taskId  value：num
        //玩家当前占领的土地信息
        for (Map.Entry<Integer, Territory> entry : territoryInfo.entrySet()) {
            CCrusadeGroupMap map = crusadeGroupMapSysCache.getMap(entry.getKey());
            int buildingLevel = map.getBuilding_level();
            int areaLevel = map.getArea_level();//地皮等级
            int cityType = 2;//城市类型1=空地，2=城池
            if (buildingLevel <= 0) {
                cityType = 1;
            }
            for (COccupationTask temp : templates_taskTyp) {
                int subCondition = temp.getTask().getSubCondition();//0=不限，1=空地，2=城池
                if (subCondition > 0 && cityType != subCondition) {//当前任务是指定类型城市
                    continue;
                }
                if (subCondition == 0 || subCondition == 1) {//0不限和1空地判断 地皮等级
                    if (areaLevel < temp.getTask().getCondition()) {//城市级不满足
                        continue;
                    }
                } else {//2城池判断建筑等级
                    if (buildingLevel < temp.getTask().getCondition()) {//城市级不满足
                        continue;
                    }
                }
                int nowNum = addNumMap.getOrDefault(temp.getId(), 0);
                addNumMap.put(temp.getId(), nowNum + 1);
            }
        }
        for (Map.Entry<Integer, Integer> entry : addNumMap.entrySet()) {
            int taskId = entry.getKey();
            int num = entry.getValue();
            OccupationTask occupationTask = getOccupationTask(rid, taskId);
            long nowNum = occupationTask.getCount();
            if (nowNum == num) {//计数相同不需要通知客户端
                continue;
            }
            occupationTask.setCount(num);
            occupationTask.setCondition(0);//满足条件
            list.add(occupationTask);
        }
        sendTaskInfoMSG(rid, list);
    }

    //开垦[1]座[2]级以上的城邦
    @Subscribe
    public void listen(CityOpenEvent event) {
        long rid = event.getRid();
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        Map<Integer, Territory> territoryInfo = roleCrusadeGroup.getTerritoryInfo();
        if (CollectionUtil.isEmpty(territoryInfo)) {
            return;
        }
        List<COccupationTask> templates_taskTyp = occupationTaskSysCache.getCOccupationTaskTemplate_taskType(TargetType.OCCUPATION_LAND_OPEN.getValue());
        List<OccupationTask> list = new ArrayList<>();
        Map<Integer, Integer> addNumMap = new HashMap<>();//统计数据 key：taskId  value：num
        //玩家当前占领的土地信息
        for (Map.Entry<Integer, Territory> entry : territoryInfo.entrySet()) {
            Territory territory = entry.getValue();
            if (territory.getHeroId() <= 0) {//没有开垦
                continue;
            }
            CCrusadeGroupMap map = crusadeGroupMapSysCache.getMap(entry.getKey());
            int buildingLevel = map.getBuilding_level();
            int areaLevel = map.getArea_level();//地皮等级
            for (COccupationTask temp : templates_taskTyp) {
                if (buildingLevel < temp.getTask().getCondition()) {//城市级不满足
                    continue;
                }
                int nowNum = addNumMap.getOrDefault(temp.getId(), 0);
                addNumMap.put(temp.getId(), nowNum + 1);
            }
        }
        for (Map.Entry<Integer, Integer> entry : addNumMap.entrySet()) {
            int taskId = entry.getKey();
            int num = entry.getValue();
            OccupationTask occupationTask = getOccupationTask(rid, taskId);
            long nowNum = occupationTask.getCount();
            if (nowNum == num) {//计数相同不需要通知客户端
                continue;
            }
            occupationTask.setCount(num);
            occupationTask.setCondition(0);//满足条件
            list.add(occupationTask);
        }
        sendTaskInfoMSG(rid, list);
    }

    //获得[1]个[2]品质神兵
    @Subscribe
    public void listen(ShenBinAddEvent event) {
        long rid = event.getRid();
        Map<Integer, Long> addItem = event.getAddItem();
        if (CollectionUtil.isEmpty(addItem)) {
            return;
        }
        List<OccupationTask> list = new ArrayList<>();
        //神兵
        List<COccupationTask> templates_taskTyp = occupationTaskSysCache.getCOccupationTaskTemplate_taskType(TargetType.OCCUPATION_SHENBIN_GET.getValue());
        for (COccupationTask temp : templates_taskTyp) {
            int qualityNeed = temp.getTask().getCondition();//品质要求
            OccupationTask occupationTask = getOccupationTask(rid, temp.getId());
            for (Map.Entry<Integer, Long> entry : addItem.entrySet()) {
                int itemType = entry.getKey();
                long itemNum = entry.getValue();
                CShenBin cShenBin = shenBinSysCache.getCShenBinTemplate(itemType);
                if (cShenBin.getQuality() >= qualityNeed) {//满足品质要求
                    occupationTask.addCount(itemNum);
                    occupationTask.setCondition(0);//满足条件
                    list.add(occupationTask);
                }
            }
        }
        sendTaskInfoMSG(rid, list);
    }

    //获得[1]个圣物精华;
    @Subscribe
    public void listen(ShenBinItemAddEvent event) {
        if (event.getGameEvent() == GameEvent.SHENBIN_RESOLVE_ITEM) {//分解获得的材料不计入职级任务
            return;
        }
        long rid = event.getRid();
        long addNum = event.getAddNum();
        //精华
        List<OccupationTask> list = new ArrayList<>();
        List<COccupationTask> templates_taskTyp = occupationTaskSysCache.getCOccupationTaskTemplate_taskType(TargetType.OCCUPATION_JINGHUA_GET.getValue());
        for (COccupationTask temp : templates_taskTyp) {
            OccupationTask occupationTask = getOccupationTask(rid, temp.getId());
            occupationTask.addCount(addNum);
            occupationTask.setCondition(0);//满足条件
            list.add(occupationTask);
        }
        sendTaskInfoMSG(rid, list);
    }


    //[1]个神兵核心升到[2]级
    @Subscribe
    public void listen(ShenBinCoreUpEvent event) {
        long rid = event.getRid();
        Map<Integer, Integer> jobCoreMap = event.getJobCoreMap();
        List<COccupationTask> templates_taskTyp = occupationTaskSysCache.getCOccupationTaskTemplate_taskType(TargetType.OCCUPATION_SHENBINCORE_UP.getValue());
        List<OccupationTask> list = new ArrayList<>();
        for (COccupationTask temp : templates_taskTyp) {
            int coreLvNeed = temp.getTask().getCondition();//等级要求
            int countNum = 0;
            for (Map.Entry<Integer, Integer> entry : jobCoreMap.entrySet()) {
                int coreLv = entry.getValue();
                if (coreLv >= coreLvNeed) {//满足等级
                    countNum++;
                }
            }
            OccupationTask occupationTask = getOccupationTask(rid, temp.getId());
            if (countNum > occupationTask.getCount()) {
                occupationTask.setCount(countNum);
                occupationTask.setCondition(0);//满足条件
                list.add(occupationTask);
            }
        }
        sendTaskInfoMSG(rid, list);
    }

    //对最后boss造成单场[1]的伤害;对最后boss造成单场[1]的伤害并参与击败
    @Subscribe
    public void listen(BossHurtEvent event) {
        long rid = event.getRid();
        long bossHurt = event.getBossHurt();
        List<COccupationTask> templates_hurt = occupationTaskSysCache.getCOccupationTaskTemplate_taskType(TargetType.OCCUPATION_BOSS_HURT.getValue());
        List<COccupationTask> templates_kill = occupationTaskSysCache.getCOccupationTaskTemplate_taskType(TargetType.OCCUPATION_BOSS_KILL.getValue());
        List<OccupationTask> list = new ArrayList<>();
        //boss伤害判断
        for (COccupationTask temp : templates_hurt) {
            if (bossHurt >= temp.getTask().getTarget()) {
                OccupationTask occupationTask = getOccupationTask(rid, temp.getId());
                occupationTask.setCount(bossHurt);
                occupationTask.setCondition(0);//满足条件
                list.add(occupationTask);
            }
        }
        //boss击杀伤害判断
        for (COccupationTask temp : templates_kill) {
            if (bossHurt >= temp.getTask().getTarget()) {
                OccupationTask occupationTask = getOccupationTask(rid, temp.getId());
                occupationTask.setCount(bossHurt);
//                occupationTask.setCondition(0);//满足条件(boss击杀后才满足条件)
                list.add(occupationTask);
            }
        }
        sendTaskInfoMSG(rid, list);
    }

    //最终boss击杀
    @Subscribe
    public void listen(BossKillEvent event) {
        List<COccupationTask> templates_kill = occupationTaskSysCache.getCOccupationTaskTemplate_taskType(TargetType.OCCUPATION_BOSS_KILL.getValue());
        //击杀判断(最终boss)
        Map<Long, List<OccupationTask>> listMap = new HashMap<>();
        for (COccupationTask temp : templates_kill) {
            int taskId = temp.getId();
            List<OccupationTask> occupationTasks = getOccupationTasks_taskId(taskId);
            for (OccupationTask occupationTask : occupationTasks) {
                occupationTask.setCondition(0);//满足条件
                addUpdateTaskInfo(listMap, occupationTask);
            }
        }
        sendTaskInfoMSG(listMap);
    }


    //推送任务信息给客户
    private void sendTaskInfoMSG(Map<Long, List<OccupationTask>> listMap) {
        if (CollectionUtil.isEmpty(listMap)) {
            return;
        }
        for (Map.Entry<Long, List<OccupationTask>> entry : listMap.entrySet()) {
            long rid = entry.getKey();
            List<OccupationTask> list = entry.getValue();
            sendTaskInfoMSG(rid, list);
        }
    }

    private void addUpdateTaskInfo(Map<Long, List<OccupationTask>> listMap, OccupationTask occupationTask) {
        long rid = occupationTask.getRid();
        List<OccupationTask> list = listMap.get(rid);
        if (list == null) {
            list = new ArrayList<>();
            listMap.put(rid, list);
        }
        list.add(occupationTask);
    }
}
