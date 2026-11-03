package com.ayjs.mxzg.common.persistence.hook.invoker;

import com.ayjs.mxzg.common.persistence.hook.DailyReset;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 *
 */
@Slf4j
@Component
public class DailyResetInvoker implements HookInvoker<DailyReset> {

    @Override
    public boolean invoke(DailyReset entity) {
        if (entity.getLastResetDateTime() == null) {
            synchronized (entity) {
                if (entity.getLastResetDateTime() == null) {
                    entity.setLastResetDateTime(LocalDateTime.now());
                    return true;
                }
                return false;
            }
        }

        if (needReset(entity)) {
            synchronized (entity) {
                if (needReset(entity)) {
                    try {
                        entity.reset();
                    } catch (Exception e) {
                        log.error(String.format("%s daily reset failed. message: %s", entity, e.getMessage()), e);
                    } finally {
                        entity.setLastResetDateTime(LocalDateTime.now());
                    }
                    return true;
                }
            }
        }
        return false;
    }

    private boolean needReset(DailyReset entity) {
        int resetTimeSecond = entity.getResetTime().toSecondOfDay();
        LocalDateTime lastResetDateTime = entity.getLastResetDateTime();
        LocalDateTime lastResetDateFixedOffset = lastResetDateTime.minusSeconds(resetTimeSecond);
        LocalDateTime nowDateTimeOffset = LocalDateTime.now().minusSeconds(resetTimeSecond);
        return !LocalDateTimeUtil.isSameDay(lastResetDateFixedOffset, nowDateTimeOffset);
    }
}
