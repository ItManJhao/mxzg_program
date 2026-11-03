package com.ayjs.mxzg.gameserver.log;

import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.buffer.LogBuffer;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
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
    private RoleService roleService;

    /**
     * 日志开关
     */
    private final boolean logSwitch;

    @Autowired
    public LogServiceImpl(ServerConfig serverConfig) {
        this.logSwitch = serverConfig.isLogToDB() || serverConfig.isLogToFile();
        log.info("LOG TO DB --- {}", serverConfig.isLogToDB());
        log.info("LOG TO FILE --- {}", serverConfig.isLogToFile());
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
            if (roleService.isRole(entity.getRid())) {
                entity.setPlace(roleService.getOrThrow(entity.getRid()).getPlace());
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
