package com.ayjs.mxzg.largecross.module.countryWar.worker;

import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarSettleDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarSettle;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarDamageWarRankService;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarHeroWarRankService;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarKillRankService;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarScoreWarRankService;
import com.ayjs.mxzg.largecross.module.countryWar.service.CountryWarConnectService;
import com.ayjs.mxzg.message.module.countryWar.CountryWarSettleRecordResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Service
@Slf4j
public class SettleWorker extends AbstractStageWorker {

    @Autowired
    private CountryWarConnectService countryWarConnectService;
    @Autowired
    private CountryWarSettleDao countryWarSettleDao;
    @Autowired
    private CountryWarScoreWarRankService countryWarScoreWarRankService;
    @Autowired
    private CountryWarHeroWarRankService countryWarHeroWarRankService;
    @Autowired
    private CountryWarKillRankService countryWarKillRankService;
    @Autowired
    private CountryWarDamageWarRankService countryWarDamageWarRankService;


    @Override
    public CountryWarStage getStage() {
        return CountryWarStage.SETTLE;
    }


    @Override
    protected void processAfterChange(CountryWarTime countryWarTime) {
        if (!countryWarTime.isHadSettle()) {
            settle();
            countryWarTime.setHadSettle(true);
        }
    }

    private void settle() {
        CountryWarTime time = countryWarTimeDao.getSingle();
        CountryWarSettle settle = countryWarSettleDao.get(time.getRound());
        settle.getServer2Group().putAll(time.getServer2Group());
        time.getServer2Group().values().forEach((group) -> {
            List<RankData> list = countryWarScoreWarRankService.showRanks(group, CrossRankType.COUNTRY_WAR_SCORE.getRankCount());
            settle.getScoreRank().put(group, list);
            List<RankData> list2 = countryWarHeroWarRankService.showRanks(group, CrossRankType.COUNTRY_WAR_HERO.getRankCount());
            settle.getHeroRank().put(group, list2);
            List<RankData> list3 = countryWarKillRankService.showRanks(group, CrossRankType.COUNTRY_WAR_KILL.getRankCount());
            settle.getKillRank().put(group, list3);
            List<RankData> list4 = countryWarDamageWarRankService.showRanks(group, CrossRankType.COUNTRY_WAR_DAMAGE.getRankCount());
            settle.getDamageRank().put(group, list4);
        });

        countryWarSettleDao.update(settle);

        settle.getServer2Group().values().forEach(groupId -> {
            CountryWarSettleRecordResMessage res = new CountryWarSettleRecordResMessage();
            res.setMaxRound(settle.getRound());
            List<RankData> damageRank = settle.getDamageRank().get(groupId);
            if (damageRank != null) {
                res.getDamageRank().addAll(damageRank);
            }
            List<RankData> killRank = settle.getKillRank().get(groupId);
            if (killRank != null) {
                res.getKillRank().addAll(killRank);
            }
            List<RankData> herRank = settle.getHeroRank().get(groupId);
            if (herRank != null) {
                res.getHeroRank().addAll(herRank);
            }
            List<RankData> scoreRank = settle.getScoreRank().get(groupId);
            if (scoreRank != null) {
                res.getScoreRank().addAll(scoreRank);
            }
            countryWarConnectService.push(groupId, res);
        });


        //TODO 结算
    }


    @Override
    protected void processBeforeChange(CountryWarTime countryWarTime) {

    }
}
