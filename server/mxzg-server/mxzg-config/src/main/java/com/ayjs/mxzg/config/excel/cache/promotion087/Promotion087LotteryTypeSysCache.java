package com.ayjs.mxzg.config.excel.cache.promotion087;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion087.CPromotion087LotteryType;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Component
public class Promotion087LotteryTypeSysCache extends BaseExcelCache<CPromotion087LotteryType> {
    @Getter
    private int minType;
    @Getter
    private int maxType;

    @Override
    protected void loadAfterReady() {
        minType = getAll().stream().mapToInt(CPromotion087LotteryType::getIdx).min().getAsInt();
        maxType = getAll().stream().mapToInt(CPromotion087LotteryType::getIdx).max().getAsInt();
    }

    @Override
    public String getFileName() {
        return "promotion087lotterytype";
    }
}
