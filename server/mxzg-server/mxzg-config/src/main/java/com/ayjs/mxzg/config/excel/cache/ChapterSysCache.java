package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CChapter;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class ChapterSysCache extends BaseExcelCache<CChapter> implements MonsterTeamCheck {

    @Override
    public String getFileName() {
        return "chapter";
    }

    /**
     * 获取关卡怪物列表
     *
     * @param missionId
     * @param modeId
     * @param chapterId
     * @return
     */
    public List<CChapter> getChapter(int missionId, int modeId, int chapterId) {
        List<CChapter> all = getAll();
        return all.stream().filter(chapter -> missionId == chapter.getMission_id() && modeId == chapter.getMode_id() && chapterId == chapter.getChapter_id())
                .collect(Collectors.toList());
    }


    @Override
    public List<List<CChapter>> getAllTeams() {
        Map<String, List<CChapter>> collect = getAll().stream().collect(Collectors.groupingBy(chapter ->
                chapter.getMission_id() + "-" + chapter.getMode_id() + "-" + chapter.getChapter_id()));
        return ImmutableList.copyOf(collect.values());
    }
}