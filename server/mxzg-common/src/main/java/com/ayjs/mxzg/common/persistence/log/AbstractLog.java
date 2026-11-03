package com.ayjs.mxzg.common.persistence.log;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.Entity;

/**
 * 抽象日志
 */
public abstract class AbstractLog extends AbstractEntity implements ILog, Entity<Long> {
}
