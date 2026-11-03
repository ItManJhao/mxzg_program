package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanSkillResetGem;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Comparator;

@Component
public class ClanSkillResetGemSysCache extends BaseExcelCache<CClanSkillResetGem> {

    @Getter
    private int maxTimes;

    @Override
    protected void loadAfterReady() {
        maxTimes = getAll().stream().max(Comparator.comparingInt(CClanSkillResetGem::getTimes)).get().getTimes();
    }

    @Override
    public String getFileName() {
        return "clanskillresetgem";
    }
}
