package com.ayjs.mxzg.common.scheduler;

import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.TimeZone;

public class CronTrigger {

    private final CronSequenceGenerator sequenceGenerator;

    /**
     * Build a {@link CronTrigger} from the pattern provided in the default time zone.
     *
     * @param expression a space-separated list of time fields, following cron
     *                   expression conventions
     */
    public CronTrigger(String expression) {
        this.sequenceGenerator = new CronSequenceGenerator(expression);
    }

    /**
     * Build a {@link CronTrigger} from the pattern provided in the given time zone.
     *
     * @param expression a space-separated list of time fields, following cron
     *                   expression conventions
     * @param timeZone   a time zone in which the trigger times will be generated
     */
    public CronTrigger(String expression, TimeZone timeZone) {
        this.sequenceGenerator = new CronSequenceGenerator(expression, timeZone);
    }

    /**
     * Return the cron pattern that this trigger has been built with.
     */
    public String getExpression() {
        return this.sequenceGenerator.getExpression();
    }

    /**
     * Determine the next execution time according to the given trigger context.
     * <p>Next execution times are calculated based on the
     * {@linkplain TriggerContext#lastCompletionTime completion time} of the
     * previous execution; therefore, overlapping executions won't occur.
     */
    public LocalDateTime nextExecutionTime(TriggerContext triggerContext) {
        LocalDateTime date = triggerContext.lastCompletionTime();
        if (date != null) {
            LocalDateTime scheduled = triggerContext.lastScheduledExecutionTime();
            if (scheduled != null && date.isBefore(scheduled)) {
                // Previous task apparently executed too early...
                // Let's simply use the last calculated execution time then,
                // in order to prevent accidental re-fires in the same second.
                date = scheduled;
            }
        } else {
            LocalDateTime scheduled = triggerContext.lastScheduledExecutionTime();
            if (scheduled != null) {
                return scheduled;
            }
            date = LocalDateTime.now();
        }
        Date date1 = LocalDateTimeUtil.localDateTime2Date(date);
        Date next = this.sequenceGenerator.next(date1);
        return LocalDateTimeUtil.date2LocalDateTime(next);
    }

    @Override
    public boolean equals(Object other) {
        return this == other ||
                (other instanceof CronTrigger && this.sequenceGenerator.equals(((CronTrigger) other).sequenceGenerator));
    }

    @Override
    public int hashCode() {
        return this.sequenceGenerator.hashCode();
    }

    @Override
    public String toString() {
        return this.sequenceGenerator.toString();
    }

}
