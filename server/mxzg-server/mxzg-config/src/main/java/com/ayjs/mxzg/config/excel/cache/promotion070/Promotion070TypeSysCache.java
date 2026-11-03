package com.ayjs.mxzg.config.excel.cache.promotion070;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070Type;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Component
public class Promotion070TypeSysCache extends BaseExcelCache<CPromotion070Type> {

    @Getter
    private int totalNum;

    @Override
    protected void loadAfterReady() {
        totalNum = getAll().stream().mapToInt(CPromotion070Type::getNum).sum();
    }

    @Override
    public String getFileName() {
        return "promotion070type";
    }
}
