package com.ayjs.mxzg.largecross.module.countryWar.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCitySysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCity;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarServerDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarServer;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarBroadcastEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarCityChangeServerEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarDefendMaxCountEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarDefendSuccessEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarUnionEvent;
import com.ayjs.mxzg.largecross.module.countryWar.factory.CountryWarLogFactory;
import com.ayjs.mxzg.largecross.module.countryWar.service.CountryWarConnectService;
import com.ayjs.mxzg.largecross.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.largecross.servergroup.event.ServerInfoEvent;
import com.ayjs.mxzg.message.module.countryWar.CountryWarMarqueeResMessage;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/25
 **/
@Observer
public class CountryWarObserver {

    @Autowired
    private CountryWarServerDao countryWarServerDao;

    @Autowired
    private CountryWarLogFactory countryWarLogFactory;
    @Autowired
    private CountryWarService countryWarService;
    @Autowired
    private CountryWarCitySysCache countryWarCitySysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private CountryWarConnectService countryWarConnectService;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;

    private static int FIRST_OCCUPY_MARQUE = 212;
    private static int OCCUPY_MARQUE = 211;

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CountryWarCityChangeServerEvent event) {
        if (event.getDefend() != null) {
            countryWarService.serverAddLog(event.getDefend().getMainServerId(),
                    countryWarLogFactory.buildLog4(event.getAttack(), event.getDefend()));

            countryWarService.serverAddLog(event.getDefend().getMainServerId(),
                    countryWarLogFactory.buildLog5(event.getAttack(), event.getDefend(), event.getIdx()));
            countryWarService.serverAddLog(event.getAttack().getMainServerId(),
                    countryWarLogFactory.buildLog5(event.getAttack(), event.getDefend(), event.getIdx()));

            countryWarService.roleAddLog(event.getDefend(), countryWarLogFactory.buildLog6(event.getDefend()));

            countryWarService.roleAddLog(event.getAttack(), countryWarLogFactory.buildLog8(event.getDefend(), event.getIdx()));
        }
        //广播
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        CCountryWarCity config = countryWarCitySysCache.getById(event.getIdx());
        if (event.isFirstOccupy() && config.getType() == 3) {//npc城池
            List<String> param = new ArrayList<>();
            param.add(event.getAttack().getMainServerId() + "");
            param.add(languageHelper.getLanguage(config.getLan_id()[countryWarTime.getRound() - 1]));
            param.add(config.getFirst_score() + "");
            countryWarConnectService.pushByServer(event.getAttack().getMainServerId(),
                    CountryWarMarqueeResMessage.of(FIRST_OCCUPY_MARQUE, param));
        }
        List<String> param = new ArrayList<>();
        param.add(event.getAttack().getMainServerId() + "");
        param.add(event.getAttack().getCountryWarRoleInfo().getName());
        param.add(languageHelper.getLanguage(config.getLan_id()[countryWarTime.getRound() - 1]));
        if (event.getDefend() != null) {
            countryWarConnectService.sendToServer(event.getDefend().getMainServerId(),
                    CountryWarMarqueeResMessage.of(OCCUPY_MARQUE, param));
        }
        countryWarConnectService.sendToServer(event.getAttack().getMainServerId(),
                CountryWarMarqueeResMessage.of(OCCUPY_MARQUE, param));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CountryWarUnionEvent event) {
        if (event.isDissolve()) {
            event.getServerIds().forEach(serverId -> {
                countryWarService.serverAddLog(serverId, countryWarLogFactory.buildLog3());
            });
        } else {
            event.getServerIds().forEach(serverId -> {
                countryWarService.serverAddLog(serverId, countryWarLogFactory.buildLog1(event.getSoleServerId()));
            });
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CountryWarDefendSuccessEvent event) {
        countryWarService.roleAddLog(event.getDefend(), countryWarLogFactory.buildLog7(event.getAttack(), event.getIdx()));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CountryWarDefendMaxCountEvent event) {
        countryWarService.roleAddLog(event.getDefend(), countryWarLogFactory.buildLog9());
        countryWarService.serverAddLog(event.getDefend().getMainServerId(), countryWarLogFactory.buildLog2(event.getDefend()));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ServerInfoEvent event) {
        event.getServerIds().forEach(subServerId -> {
            if (subServerId != event.getSeverId()) {
                CountryWarServer server = countryWarServerDao.get(subServerId);
                if (server != null && server.isValidServer()) {
                    server.setValidServer(false);
                    countryWarServerDao.update(server);
                }
            }
        });

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CountryWarBroadcastEvent event) {
        countryWarService.broadAllRole(event.getGroupId());
        countryWarService.broadSmallAllRole(event.getGroupId(), event.getCityIds());
    }


}
