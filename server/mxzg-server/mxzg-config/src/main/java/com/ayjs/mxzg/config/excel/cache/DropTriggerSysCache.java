package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDropTrigger;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 掉落触发器
 */
@Component
public class DropTriggerSysCache extends BaseExcelCache<CDropTrigger> {

    private Map<Integer, List<CDropTrigger>> dropGroupMap;

    @Override
    public String getFileName() {
        return "droptrigger";
    }

    @Override
    protected void loadAfterReady() {

        Map<Integer, List<CDropTrigger>> dropGroupMapTemp = fillListMap(CDropTrigger::getDrop_group);
        dropGroupMap = dropGroupMapTemp;
    }

    public List<CDropTrigger> getDropGroup(int dropGroupId) {
        return dropGroupMap.get(dropGroupId);
    }
}
