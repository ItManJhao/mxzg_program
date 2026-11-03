package com.ayjs.mxzg.config.excel.cache.heroEquipSoul;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.heroEquipSoul.CHeroEquipSoulExtra;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/3/8
 **/
@Component
public class HeroEquipSoulExtraSysCache extends BaseExcelCache<CHeroEquipSoulExtra> {

    @Override
    public String getFileName() {
        return "heroequipsoulextra";
    }

    public CHeroEquipSoulExtra getConfig() {
        return getAll().size() > 0 ? getAll().get(0) : null;
    }
}
