package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanLevel;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Comparator;

@Component
public class ClanLevelSysCache extends BaseExcelCache<CClanLevel> {

	@Getter
    private int maxLv = 0;

    @Override
    protected void loadAfterReady() {
        maxLv = getAll().stream().max(Comparator.comparingInt(CClanLevel::getLevel)).get().getLevel();
    }

	@Override
    public String getFileName() {
        return "clanlevel";
    }


}