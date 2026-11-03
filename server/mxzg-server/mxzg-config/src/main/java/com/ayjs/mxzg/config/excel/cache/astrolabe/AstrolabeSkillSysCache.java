package com.ayjs.mxzg.config.excel.cache.astrolabe;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.astrolabe.CAstrolabeSkill;
import org.springframework.stereotype.Component;

/**
 * 星盘
 *
 * @Author: CWJ
 * @Date: 2020/4/28
 **/
@Component
public class AstrolabeSkillSysCache extends BaseExcelCache<CAstrolabeSkill> {

    @Override
    public String getFileName() {
        return "astrolabeskill";
    }
}
