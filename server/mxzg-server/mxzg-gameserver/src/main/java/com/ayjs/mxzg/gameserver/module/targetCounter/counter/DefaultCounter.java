package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.targetCounter.dao.TaskTargetCountDao;
import com.ayjs.mxzg.gameserver.module.targetCounter.domain.TaskTargetCount;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 默认计数器，返回0值
 *
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Service
public class DefaultCounter implements Counter {

    @Autowired
    private TaskTargetCountDao taskTargetCountDao;

    @Override
    public TargetType thisType() {
        return null;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        return 0;
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        Asserts.isTrue(targetStruct != null && targetStruct.getType() != null, String.format("任务目标结构不能为空！{%s}", JsonUtil.toJson(targetStruct)));
        List<TaskTargetCount> entityByType = taskTargetCountDao.getEntityByType(rid, targetStruct.getType().getValue());
        return entityByType.stream().filter(entity ->
                TargetType.getType(entity.getType()).check(targetStruct, entity.getCondition(), entity.getSubCondition()))
                .mapToLong(TaskTargetCount::getCount).sum();
    }

}
