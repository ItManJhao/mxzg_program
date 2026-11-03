package com.ayjs.mxzg.config.excel.cache;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CAchievementTest;
import com.ayjs.mxzg.config.struct.ExcelCheckUtil;

import lombok.Getter;

/***
 * 新版成就
 */
@Component
public class AchievementTestSysCache extends BaseExcelCache<CAchievementTest> {

    //    private Map<Integer, Integer> prevTask = new HashMap<>();
    @Getter
    private Map<Integer, List<Integer>> subTask = new HashMap<>();
    //每条任务线的第一个任务
    @Getter
    private Set<Integer> firstTask = new HashSet<>();

    @Override
    protected void loadAfterReady() {
        Map<Integer, List<Integer>> subTaskTemp = new HashMap<>();
        Set<Integer> firstTaskTemp = new HashSet<>();
        getAll().forEach(config -> {
            if (config.getPrev_task() == 0) {
                firstTaskTemp.add(config.getIdx());
                return;
            }
            List<Integer> sub = subTaskTemp.computeIfAbsent(config.getPrev_task(), key -> new ArrayList<>());
            sub.add(config.getIdx());
        });
        subTask = subTaskTemp;
        firstTask = firstTaskTemp;
    }

    @Autowired
    private ExcelCheckUtil excelCheckUtil;

    @Override
    public String getFileName() {
        return "achievement";
    }

    @Override
    public boolean check(CAchievementTest cAchievement) {
        boolean result = excelCheckUtil.checkImmutableThing(cAchievement.getReward(), cAchievement.getIdx(), getFileName());
        return result;
    }
}