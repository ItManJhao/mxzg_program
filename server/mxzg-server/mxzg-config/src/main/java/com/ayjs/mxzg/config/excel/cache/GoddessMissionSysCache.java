package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessMission;
import com.ayjs.mxzg.config.struct.TargetType;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class GoddessMissionSysCache extends BaseExcelCache<CGoddessMission> {

    private Map<TargetType, List<CGoddessMission>> taskMap = new HashMap<>();

    @Override
    public String getFileName() {
        return "goddessmission";
    }

    @Override
    protected void loadAfterReady() {
        Map<TargetType, List<CGoddessMission>> taskMap_ = new HashMap<>();

        getAll().stream().filter(cGoddessMission -> cGoddessMission.getTask().getType() != null).forEach(cGoddessMission -> {
            List<CGoddessMission> headList = taskMap_.computeIfAbsent(cGoddessMission.getTask().getType(),
                    k -> new ArrayList<>());
            headList.add(cGoddessMission);
        });
        taskMap = taskMap_;

    }

    /**
     * 获取某种类型的所有任务
     *
     * @param targetType
     * @return
     */
    public List<CGoddessMission> getGoddessMissionList(TargetType targetType) {
        return taskMap.get(targetType);
    }
}