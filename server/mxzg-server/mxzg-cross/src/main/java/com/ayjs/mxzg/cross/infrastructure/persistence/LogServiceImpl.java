package com.ayjs.mxzg.cross.infrastructure.persistence;

import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.buffer.LogBuffer;
import com.ayjs.mxzg.cross.infrastructure.constant.CrossConfig;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
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

    @Autowired
    private CrossRoleService crossRoleService;
    /**
     * 日志开关
     */
    private final boolean logSwitch;

    @Autowired
    public LogServiceImpl(CrossConfig crossConfig) {
        this.logSwitch = crossConfig.isLogToDB() || crossConfig.isLogToFile();
        log.info("LOG TO DB --- {}", crossConfig.isLogToDB());
        log.info("LOG TO FILE --- {}", crossConfig.isLogToFile());
    }

    public <T extends ILog> void addLog(T entity) {
        if (logSwitch) {
            List<LogBuffer> buffers = logServiceLifecycle.getBuffers(entity);
            if (buffers != null) {
                buffers.forEach(buffer -> buffer.add(entity));
            } else {
                log.warn("{} not registered", entity.getClass());
            }
        }
    }

    public <T extends AbstractOperateLog> void addLog(T entity) {
        if (logSwitch) {
            if (crossRoleService.isCrossRole(entity.getRid())) {
                entity.setPlace(crossRoleService.getOrThrow(entity.getRid()).getPlace());
            }
            entity.setOpTime(LocalDateTime.now());

            List<LogBuffer> buffers = logServiceLifecycle.getBuffers(entity);
            if (buffers != null) {
                buffers.forEach(buffer -> buffer.add(entity));
            } else {
                log.warn("{} not registered", entity.getClass());
            }
        }
    }
}
