/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleReport;
import org.springframework.stereotype.Repository;


@Repository
public class PinnacleReportDao extends BaseRepository<PinnacleReport> {

    private static int UNIQUE_ID = 1;

    public PinnacleReport getReport() {
        PinnacleReport report = get(UNIQUE_ID);
        if(report == null) {
            report = new PinnacleReport();
            report.setId(UNIQUE_ID);
            add(report);
        }
        return report;
    }

}
