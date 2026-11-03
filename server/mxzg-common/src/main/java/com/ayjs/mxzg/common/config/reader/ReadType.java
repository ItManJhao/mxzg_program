package com.ayjs.mxzg.common.config.reader;

/**
 *
 */
public enum ReadType {
    /**
     * 所有的读取
     */
    ALL_READ(3),
    /**
     * 后端读取
     */
    SERVER_READ(2),
    /**
     * 前端读取
     */
    CLIENT_READ(1),
    /**
     * 策划查看
     */
    ENGINEER_READ(0);

    private final int type;

    ReadType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }

    public static ReadType of(int type) {
        switch (type) {
            case 0:
                return ENGINEER_READ;
            case 1:
                return CLIENT_READ;
            case 2:
                return SERVER_READ;
            case 3:
                return ALL_READ;
            default:
                return null;
        }
    }
}
