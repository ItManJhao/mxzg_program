package com.ayjs.mxzg.gameserver.module.targetCounter.service;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.targetCounter.counter.Counter;
import com.ayjs.mxzg.gameserver.module.targetCounter.counter.DefaultCounter;
import com.ayjs.mxzg.gameserver.module.targetCounter.dao.TaskTargetCountDao;
import com.ayjs.mxzg.gameserver.module.targetCounter.domain.TaskTargetCount;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.TaskCountChangeEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 活动目标service
 *
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Service
@Slf4j
public class TargetCounterService implements IRegister<Counter> {

    @Autowired
    private TaskTargetCountDao taskTargetCountDao;
    @Autowired
    private EventBus eventBus;

    @Autowired
    private DefaultCounter DEFAULT_COUNTER;

    private Map<TargetType, Counter> counterMap = new ConcurrentHashMap<>();

    private static String UPDATE_LOCK = "UPDATE_COUNT";

    @Override
    public void registerBean(Counter bean) {
        if (bean.thisType() == null) {
            return;
        }
        if (Objects.nonNull(bean)) {
            Counter old = counterMap.putIfAbsent(bean.thisType(), bean);
            if (Objects.nonNull(old)) {
                throw new RuntimeException(String.format("计数类型冲突{%s}-{%s}", old.getClass().getName(), bean.getClass().getName()));
            }
        }
    }

    /***
     * 计算玩家当前状态计算当前值
     * @param rid
     * @param targetStruct
     */
    public int calcCount(long rid, TargetStruct targetStruct) {
        Counter counter = counterMap.get(targetStruct.getType());
        if (counter == null) {
            counter = DEFAULT_COUNTER;
        }
        return counter.count(rid, targetStruct);
    }

    /***
     * 获取累计值
     * @param rid
     * @param targetStruct
     * @return
     */
    public long calcTaskCount(long rid, TargetStruct targetStruct) {
        Counter counter = counterMap.get(targetStruct.getType());
        if (counter == null) {
            counter = DEFAULT_COUNTER;
        }
        return counter.taskCount(rid, targetStruct);
    }

    /***
     * 增加计数
     * @param rid
     * @param targetType
     * @param addValue
     * @return
     */
    public long addProcess(long rid, TargetType targetType, int condition, int subCondition, long addValue) {
        long newValue = addProcessNotPost(rid, targetType, condition, subCondition, addValue);
        eventBus.post(TaskCountChangeEvent.of(rid, targetType, condition, subCondition, addValue, newValue));
        return newValue;
    }

    public long addProcess(long rid, TargetType targetType, long addValue) {
        return addProcess(rid, targetType, 0, 0, addValue);
    }

    public long addProcessNotPost(long rid, TargetType targetType, int condition, int subCondition, long addValue) {
        long newValue = 0;
        if (!targetType.isSaveDb()) {
            return calcCount(rid, TargetStruct.of(targetType, condition, subCondition));
        }
        synchronized (InternerPool.intern(UPDATE_LOCK, rid, targetType.getValue(), condition, condition)) {
            TaskTargetCount entity = load(rid, targetType, condition, subCondition);
            newValue = entity.addProcess(addValue);

            taskTargetCountDao.update(entity);
        }
        return newValue;
    }

    public TaskTargetCount getEntity(long rid, TargetType targetType, int condition, int subCondition) {
        List<TaskTargetCount> entities = taskTargetCountDao.getEntityByType(rid, targetType.getValue());
        TaskTargetCount entity = entities.stream().filter(entityTemp -> condition == entityTemp.getCondition() &&
                subCondition == entityTemp.getSubCondition()).findFirst().orElse(null);
        return entity;

    }

    /***
     * 计数值变大，当新值小于当前计数值，不会入库
     * @param rid
     * @param targetType
     * @return
     */
    public long setProcess(long rid, TargetType targetType, long newValue) {
        long addValue = setProcess(rid, targetType, 0, 0, newValue);
        return addValue;
    }

    /***
     * 计数值变小，当新值大于当前计数值，不会入库，比如最大排名
     * @param rid
     * @param targetType
     * @param value
     * @return
     */
    public long setMinProcess(long rid, TargetType targetType, int condition, int subCondition, long value) {
        long addValue = 0;
        if (!targetType.isSaveDb()) {
            int oldCount = calcCount(rid, TargetStruct.of(targetType, condition, subCondition));
            addValue = value - oldCount;
        } else {
            synchronized (InternerPool.intern(UPDATE_LOCK, rid, targetType.getValue(), condition, condition)) {
                TaskTargetCount entity = load(rid, targetType, condition, subCondition);
                addValue = value - entity.getCount();
                if (entity.getCount() != 0 && addValue > 0)
                    return 0;
                entity.setCount(value);
                taskTargetCountDao.update(entity);
            }
        }
        eventBus.post(TaskCountChangeEvent.of(rid, targetType, condition, subCondition, addValue, value));
        return addValue;
    }

    /***
     *
     * condition值越来越大
     *  设置数量
     * @param rid
     * @param newValue
     * @return
     *          增加值
     */
    public long setProcess(long rid, TargetType targetType, int condition, int subCondition, long newValue) {
        long addValue = 0;
        if (!targetType.isSaveDb()) {
            int oldCount = calcCount(rid, TargetStruct.of(targetType, condition, subCondition));
            addValue = newValue - oldCount;
        } else {
            synchronized (InternerPool.intern(UPDATE_LOCK, rid, targetType.getValue(), condition, condition)) {
                TaskTargetCount entity = load(rid, targetType, condition, subCondition);
                addValue = newValue - entity.getCount();
                if (addValue < 0)
                    return 0;
                entity.setCount(newValue);
                taskTargetCountDao.update(entity);
            }
        }
        eventBus.post(TaskCountChangeEvent.of(rid, targetType, condition, subCondition, addValue, newValue));
        return addValue;
    }

    private TaskTargetCount load(long rid, TargetType targetType, int condition, int subCondition) {
        TaskTargetCount entity = null;
        synchronized (InternerPool.intern(UPDATE_LOCK, rid, targetType.getValue(), condition, condition)) {
            entity = getEntity(rid, targetType, condition, subCondition);
            if (entity == null) {
                entity = new TaskTargetCount();
                entity.setRid(rid);
                entity.setSubCondition(subCondition);
                entity.setCondition(condition);
                if (targetType.needInit()) {
                    entity.setCount(calcCount(rid, TargetStruct.of(targetType, condition, subCondition)));
                } else {
                    entity.setCount(0);
                }
                entity.setType(targetType.getValue());
                taskTargetCountDao.add(entity);
            }
        }
        return entity;
    }

}
