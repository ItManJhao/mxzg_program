package com.ayjs.mxzg.template.scheduler.service;

import com.ayjs.mxzg.common.scheduler.CronSequenceGenerator;
import com.ayjs.mxzg.common.scheduler.ICronTask;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.template.scheduler.domain.CronTaskBackup;
import com.ayjs.mxzg.template.scheduler.repository.CronTaskBackupRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.Objects;

/**
 * 定时任务
 */
@Slf4j
public abstract class AbstractCronTask implements ICronTask {

    @Autowired
    private CronTaskBackupRepository cronTaskBackupRepository;

    protected CronTaskBackup getCronTaskBackup() {
        CronTaskBackup cronTaskBackup = cronTaskBackupRepository.get("identity", identity());
        if (cronTaskBackup == null) {
            cronTaskBackup = new CronTaskBackup();
            cronTaskBackup.setIdentity((String) identity());
            cronTaskBackup.setExpression(expression());
            Date next = new CronSequenceGenerator(expression()).next(new Date());

            LocalDateTime nextTime = LocalDateTimeUtil.date2LocalDateTime(next);
            cronTaskBackup.setLastScheduledExecutionTime(nextTime);
            cronTaskBackupRepository.add(cronTaskBackup);
        } else if (!Objects.equals(cronTaskBackup.getExpression(), expression())) {
            cronTaskBackup.setExpression(expression());
            Date next = new CronSequenceGenerator(expression()).next(new Date());
            LocalDateTime nextTime = LocalDateTimeUtil.date2LocalDateTime(next);
            cronTaskBackup.setLastScheduledExecutionTime(nextTime);
            cronTaskBackup.setLastActualExecutionTime(null);
            cronTaskBackup.setLastCompletionTime(null);
            cronTaskBackupRepository.update(cronTaskBackup);
        }
        return cronTaskBackup;
    }

    @Override
    public final LocalDateTime lastScheduledExecutionTime() {
        return getCronTaskBackup().getLastScheduledExecutionTime();
    }

    @Override
    public final LocalDateTime lastActualExecutionTime() {
        return getCronTaskBackup().getLastActualExecutionTime();
    }

    @Override
    public final LocalDateTime lastCompletionTime() {
        return getCronTaskBackup().getLastCompletionTime();
    }

    @Override
    public final void onDetermineNextExecutionTime(LocalDateTime nextExecutionTime) {
        if (log.isTraceEnabled()) {
            log.trace(String.format("Task [%s] next execution time [%s]", identity(), nextExecutionTime));
        }
    }

    @Override
    public final void onUpdate(LocalDateTime lastScheduledExecutionTime, LocalDateTime lastActualExecutionTime, LocalDateTime lastCompletionTime) {
        CronTaskBackup cronTaskBackup = getCronTaskBackup();
        cronTaskBackup.setLastScheduledExecutionTime(lastScheduledExecutionTime);
        cronTaskBackup.setLastActualExecutionTime(lastActualExecutionTime);
        cronTaskBackup.setLastCompletionTime(lastCompletionTime);
        cronTaskBackupRepository.update(cronTaskBackup);
    }
}
