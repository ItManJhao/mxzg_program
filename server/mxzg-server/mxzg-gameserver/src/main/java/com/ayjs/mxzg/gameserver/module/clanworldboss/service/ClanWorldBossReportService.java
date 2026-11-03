/**
 *
 */
package com.ayjs.mxzg.gameserver.module.clanworldboss.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.clanworldboss.dao.ClanWorldBossReportDao;
import com.ayjs.mxzg.gameserver.module.clanworldboss.domain.ClanWorldBossReport;

import java.util.List;

/**
 * @author YY
 *
 */
@Service
public class ClanWorldBossReportService {
    @Autowired
    private ClanWorldBossReportDao clanWorldBossReportDao;

    public List<ClanWorldBossReport> getByRound(int round) {
        return clanWorldBossReportDao.list("round", round);
    }

    public void insert(ClanWorldBossReport report) {
        clanWorldBossReportDao.add(report);
    }
}
