package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGodRelic;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 诸神遗迹
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class GodRelicSysCache extends BaseExcelCache<CGodRelic> {

    public Map<Integer, List<CGodRelic>> chapterMap;

    @Override
    protected void loadAfterReady() {
        chapterMap = getAll().stream().collect(Collectors.groupingBy(CGodRelic::getChapter));
    }

    public List<CGodRelic> getByChapter(int chapter) {
        return chapterMap.get(chapter);
    }

    @Override
    public String getFileName() {
        return "godrelic";
    }
}
