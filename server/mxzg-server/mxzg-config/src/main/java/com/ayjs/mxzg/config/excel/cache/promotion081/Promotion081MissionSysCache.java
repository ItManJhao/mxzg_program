package com.ayjs.mxzg.config.excel.cache.promotion081;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion081.CPromotion081Mission;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
@Slf4j
public class Promotion081MissionSysCache extends BaseExcelCache<CPromotion081Mission> {
    @Override
    public String getFileName() {
        return "promotion081mission";
    }

    @Override
    protected void loadAfterReady() {
        getAll().forEach(config -> {
            if (config.getTarget().getType() == null)
                throw new RuntimeException(String.format("配置表{%s}，idx:{%s}不存在该任务类型", getFileName(), config.getIdx()));
        });

    }
}


