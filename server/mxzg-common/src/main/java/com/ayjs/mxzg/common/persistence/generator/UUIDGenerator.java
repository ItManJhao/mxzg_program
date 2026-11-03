package com.ayjs.mxzg.common.persistence.generator;

import java.util.UUID;

/**
 * UUID 生成器
 */
public enum UUIDGenerator implements IdGenerator {
    INSTANCE;
    private final static String HYPHEN = "-";
    private final static String EMPTY = "";

    @Override
    public String nextId() {
        return UUID.randomUUID().toString().replaceAll(HYPHEN, EMPTY);
    }
}