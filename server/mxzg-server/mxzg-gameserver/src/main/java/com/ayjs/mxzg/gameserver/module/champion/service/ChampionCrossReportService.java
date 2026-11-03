/**
 *
 */
package com.ayjs.mxzg.gameserver.module.champion.service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.champion.dao.ChampionCrossReportDao;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCrossReport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author YY
 *
 */
@Service
public class ChampionCrossReportService {

    @Autowired
    private ChampionCrossReportDao championCrossReportDao;

    public ChampionCrossReport getReport(int round, int serverId) {
        ChampionCrossReport report = championCrossReportDao.list("round", round).stream()
                .filter(entity -> entity.getServerId() == serverId).findFirst().orElse(null);
        if (report == null) {
            report = new ChampionCrossReport();
            report.setRound(round);
            report.setCreateTime(TimeDateUtil.getCurrentTimeInt());
            report.setServerId(serverId);
            championCrossReportDao.add(report);
        }
        return report;
    }

    public void updateReport(ChampionCrossReport report) {
        championCrossReportDao.update(report);
    }
}
