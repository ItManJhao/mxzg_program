package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 幻境之塔历史最高层
 * @author hyx
 */
@Controller
public class DreamlandMaxLv implements Counter {

    @Autowired
    private DreamlandService dreamlandService;

    @Override
    public TargetType thisType() {
        return TargetType.INFINITE_LEVEL;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        return dreamlandService.loadAndRefresh(rid).getMaxLv();
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        return count(rid, targetStruct);
    }

}
