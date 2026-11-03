package com.ayjs.mxzg.largecross.module.countryWar.worker;

import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarTimeSysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarServerDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.service.CountryWarConnectService;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.countryWar.CountryWarStageResMessage;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarStageTimeInfo;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
public abstract class AbstractStageWorker implements StageWorker {

    @Autowired
    protected CountryWarTimeDao countryWarTimeDao;
    @Autowired
    private CountryWarTimeSysCache countryWarTimeSysCache;
    @Autowired
    protected CountryWarConnectService countryWarConnectService;
    @Autowired
    private CountryWarServerDao countryWarServerDao;

    @Autowired
    protected MessageHelper messageHelper;

    @Override
    public void process(CCountryWarTime config) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        processBeforeChange(countryWarTime);
        countryWarTime.setStage(getStage().getValue());
        countryWarTime.setStageStartTime(LocalDateTime.now());
        countryWarTime.setConfigIdx(config.getIdx());
        countryWarTime.setRound(config.getRound());
        countryWarTimeDao.update(countryWarTime);
        processAfterChange(countryWarTime);
        pushStageChange(countryWarTime);
    }

    public void pushStageChange(CountryWarTime countryWarTime) {
        CCountryWarTime nextStage = countryWarTimeSysCache.getById(countryWarTime.getConfigIdx() + 1);
        countryWarServerDao.listAll().forEach(server -> {
            if (!server.isValidServer()) {
                return;
            }
            CountryWarStageTimeInfo timeInfo = CountryWarStageTimeInfo.of(countryWarTime.getStage(),
                    countryWarTime.getStageStartTime(),
                    nextStage.getStart_time(),
                    countryWarTime.getRound(),
                    countryWarTime.getConfigIdx(),
                    countryWarTime.getServer2Group().containsKey(server.getServerId()));
            CountryWarStageResMessage message = CountryWarStageResMessage.of(timeInfo);
            countryWarConnectService.sendToServer(server.getServerId(), message);
        });
    }

    protected abstract void processAfterChange(CountryWarTime countryWarTime);

    protected abstract void processBeforeChange(CountryWarTime countryWarTime);

}
