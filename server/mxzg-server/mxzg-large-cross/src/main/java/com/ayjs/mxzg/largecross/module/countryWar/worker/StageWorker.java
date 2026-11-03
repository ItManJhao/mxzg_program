package com.ayjs.mxzg.largecross.module.countryWar.worker;

import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarTime;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
public interface StageWorker {

    CountryWarStage getStage();

    void process(CCountryWarTime config);

    /***
     * 启动时调用接口
     */
    default void start() {
    }
}
