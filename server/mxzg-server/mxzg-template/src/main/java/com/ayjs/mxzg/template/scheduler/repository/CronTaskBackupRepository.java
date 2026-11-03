package com.ayjs.mxzg.template.scheduler.repository;

import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.template.scheduler.domain.CronTaskBackup;
import org.springframework.stereotype.Repository;

/**
 *
 */
@Repository
@CRepository(source = "data")
public class CronTaskBackupRepository extends BaseRepository<CronTaskBackup> {

}
