package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDreamlandDailyReward;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Component
public class DreamlandDailyRewardSysCache extends BaseExcelCache<CDreamlandDailyReward> {

    @Getter
    private int maxLv;

    @Override
    protected void loadAfterReady() {
        maxLv = getAll().stream().mapToInt(CDreamlandDailyReward::getIdx).max().getAsInt();
    }

    @Override
    public String getFileName() {
        return "infinitedaily";
    }
}
