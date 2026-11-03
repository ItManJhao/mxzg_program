package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionMission;
import com.ayjs.mxzg.config.struct.TargetType;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/***
 * 皮肤任务
 */
@Component
public class GoddessFashionMissionSysCache extends BaseExcelCache<CGoddessFashionMission> {

    private Map<TargetType, List<CGoddessFashionMission>> taskMap = new HashMap<>();
    private Map<Integer, List<Integer>> fashionTypeTaskMap = new HashMap<>();


    @Override
    public String getFileName() {
        return "goddessfashionmission";
    }

    @Override
    protected void loadAfterReady() {
        Map<TargetType, List<CGoddessFashionMission>> taskMap_ = new HashMap<>();

        getAll().stream().filter(cGoddessMission -> cGoddessMission.getTask().getType() != null).forEach(cGoddessMission -> {
            List<CGoddessFashionMission> headList = taskMap_.computeIfAbsent(cGoddessMission.getTask().getType(),
                    k -> new ArrayList<>());
            headList.add(cGoddessMission);
        });
        taskMap = taskMap_;

        Map<Integer, List<Integer>> fashionTypeTaskMap_ = new HashMap<>();

        getAll().stream().filter(cGoddessMission -> cGoddessMission.getTask().getType() != null).forEach(cGoddessMission -> {
            List<Integer> headList = fashionTypeTaskMap_.computeIfAbsent(cGoddessMission.getFashion_type(),
                    k -> new ArrayList<>());
            headList.add(cGoddessMission.getIdx());
        });
        fashionTypeTaskMap = fashionTypeTaskMap_;

    }

    /**
     * 获取某种类型的所有任务
     *
     * @param targetType
     * @return
     */
    public List<CGoddessFashionMission> getMissionBy(TargetType targetType) {
        return taskMap.get(targetType);
    }

    /**
     * 获取某种类型的所有任务
     *
     * @return
     */
    public List<Integer> getByFashionType(int evolveType) {
        return fashionTypeTaskMap.getOrDefault(evolveType, Collections.emptyList());
    }
}