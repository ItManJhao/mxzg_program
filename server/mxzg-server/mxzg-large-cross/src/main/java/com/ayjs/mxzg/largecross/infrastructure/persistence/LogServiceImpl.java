package com.ayjs.mxzg.largecross.infrastructure.persistence;

import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.buffer.LogBuffer;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import com.ayjs.mxzg.template.log.LogService;
import com.ayjs.mxzg.template.log.LogServiceLifecycle;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Component
public class LogServiceImpl implements LogService {
    @Autowired
    private LogServiceLifecycle logServiceLifecycle;

    /**
     * 日志开关
     */

    public <T extends ILog> void addLog(T entity) {
        List<LogBuffer> buffers = logServiceLifecycle.getBuffers(entity);
        if (buffers != null) {
            buffers.forEach(buffer -> buffer.add(entity));
        } else {
            log.warn("{} not registered", entity.getClass());
        }
    }

    public <T extends AbstractOperateLog> void addLog(T entity) {
        entity.setOpTime(LocalDateTime.now());

        List<LogBuffer> buffers = logServiceLifecycle.getBuffers(entity);
        if (buffers != null) {
            buffers.forEach(buffer -> buffer.add(entity));
        } else {
            log.warn("{} not registered", entity.getClass());
        }
    }
}
