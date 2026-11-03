package com.ayjs.mxzg.template.log;


import com.ayjs.mxzg.common.persistence.log.ILog;

public interface LogService {

    <T extends ILog> void addLog(T entity);

    <T extends AbstractOperateLog> void addLog(T entity);
}
