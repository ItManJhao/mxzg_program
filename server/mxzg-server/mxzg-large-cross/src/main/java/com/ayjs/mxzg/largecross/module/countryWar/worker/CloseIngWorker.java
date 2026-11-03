package com.ayjs.mxzg.largecross.module.countryWar.worker;

import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Service
public class CloseIngWorker extends AbstractStageWorker {


    @Override
    public CountryWarStage getStage() {
        return CountryWarStage.CLOSE_ING;
    }


    @Override
    protected void processAfterChange(CountryWarTime countryWarTime) {

    }

    @Override
    protected void processBeforeChange(CountryWarTime countryWarTime) {
        if (!countryWarTime.isHadSettle()) {
            settle();
            countryWarTime.setHadSettle(true);
        }

    }

    private void settle() {

    }
}
