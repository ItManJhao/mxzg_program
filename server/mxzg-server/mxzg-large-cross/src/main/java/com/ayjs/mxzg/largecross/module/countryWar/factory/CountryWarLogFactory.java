package com.ayjs.mxzg.largecross.module.countryWar.factory;

import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCitySysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarLogType;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarLogInfo;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Component
public class CountryWarLogFactory {

    @Autowired
    private CountryWarCitySysCache countryWarCitySysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;

    public CountryWarLogInfo buildLog1(int serverId) {
        CountryWarLogInfo info = new CountryWarLogInfo();
        info.setType(CountryWarLogType.LOG_1.getValue());
        info.setLogTime(LocalDateTime.now());
        info.getParams().add(serverId + "");
        info.getParams().add(serverId + "");
        return info;
    }

    public CountryWarLogInfo buildLog2(CountryWarRole countryWarRole) {
        CountryWarLogInfo info = new CountryWarLogInfo();
        info.setType(CountryWarLogType.LOG_2.getValue());
        info.setLogTime(LocalDateTime.now());
        info.getParams().add(countryWarRole.getCountryWarRoleInfo().getServerId() + "");
        info.getParams().add(countryWarRole.getCountryWarRoleInfo().getName());
        return info;
    }

    public CountryWarLogInfo buildLog3() {
        CountryWarLogInfo info = new CountryWarLogInfo();
        info.setType(CountryWarLogType.LOG_3.getValue());
        info.setLogTime(LocalDateTime.now());
        return info;
    }

    public CountryWarLogInfo buildLog4(CountryWarRole attack, CountryWarRole defend) {
        CountryWarLogInfo info = new CountryWarLogInfo();
        info.setType(CountryWarLogType.LOG_4.getValue());
        info.setLogTime(LocalDateTime.now());
        info.getParams().add(defend.getCountryWarRoleInfo().getServerId() + "");
        info.getParams().add(defend.getCountryWarRoleInfo().getName());
        info.getParams().add(attack.getCountryWarRoleInfo().getServerId() + "");
        info.getParams().add(attack.getCountryWarRoleInfo().getName());
        return info;
    }

    public CountryWarLogInfo buildLog5(CountryWarRole attack, CountryWarRole defend, int cityId) {
        CountryWarLogInfo info = new CountryWarLogInfo();
        info.setType(CountryWarLogType.LOG_5.getValue());
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        String cityName = languageHelper.getLanguage(countryWarCitySysCache.getById(cityId).getLan_id()[countryWarTime.getRound() - 1]);
        info.setLogTime(LocalDateTime.now());
        info.getParams().add(attack.getCountryWarRoleInfo().getServerId() + "");
        info.getParams().add(attack.getCountryWarRoleInfo().getName());
        info.getParams().add(cityName);
        info.getParams().add(defend.getCountryWarRoleInfo().getServerId() + "");
        info.getParams().add(defend.getCountryWarRoleInfo().getName());
        info.getParams().add(cityName);
        return info;
    }

    public CountryWarLogInfo buildLog6(CountryWarRole defend) {
        CountryWarLogInfo info = new CountryWarLogInfo();
        info.setType(CountryWarLogType.LOG_6.getValue());
        info.setLogTime(LocalDateTime.now());
        info.getParams().add(defend.getCountryWarRoleInfo().getServerId() + "");
        info.getParams().add(defend.getCountryWarRoleInfo().getName());
        return info;
    }

    public CountryWarLogInfo buildLog7(CountryWarRole attack, int cityId) {
        CountryWarLogInfo info = new CountryWarLogInfo();
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        info.setType(CountryWarLogType.LOG_7.getValue());
        info.setLogTime(LocalDateTime.now());
        info.getParams().add(attack.getCountryWarRoleInfo().getServerId() + "");
        info.getParams().add(attack.getCountryWarRoleInfo().getName());
        info.getParams().add(languageHelper.getLanguage(countryWarCitySysCache.getById(cityId).getLan_id()[countryWarTime.getRound() - 1]));
        return info;
    }

    public CountryWarLogInfo buildLog8(CountryWarRole defend, int cityId) {
        CountryWarLogInfo info = new CountryWarLogInfo();
        info.setType(CountryWarLogType.LOG_8.getValue());
        info.setLogTime(LocalDateTime.now());
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        String cityName = languageHelper.getLanguage(countryWarCitySysCache.getById(cityId).getLan_id()[countryWarTime.getRound() - 1]);
        info.getParams().add(cityName);
        info.getParams().add(defend.getCountryWarRoleInfo().getServerId() + "");
        info.getParams().add(defend.getCountryWarRoleInfo().getName());
        info.getParams().add(cityName);
        return info;
    }

    public CountryWarLogInfo buildLog9() {
        CountryWarLogInfo info = new CountryWarLogInfo();
        info.setType(CountryWarLogType.LOG_9.getValue());
        info.setLogTime(LocalDateTime.now());
        return info;
    }
}
