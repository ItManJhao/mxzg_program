package com.ayjs.mxzg.config.struct;

import lombok.Getter;

/**
 * 语言枚举类 和配置表languagetype 同步
 */
@Getter
public enum Language {

    /**
     * 默认
     */
    DEFAULT(0, "value"),

    /**
     * 简体中文
     */
    CN(1, "value") {
        @Override
        public String getLanguage(LanguageConfig config) {
            return config.getValue();
        }
    },

    /**
     * 繁体中文
     */
    CN_TRAD(2, "CN_TRAD") {
        @Override
        public String getLanguage(LanguageConfig config) {
            return config.getCn_trad();
        }
    },

    /**
     * 印度尼西亚
     */
    IDN(3, "IDN") {
        @Override
        public String getLanguage(LanguageConfig config) {
            return config.getIdn();
        }
    },

    /**
     * 英文
     */
    EN(4, "EN") {
        @Override
        public String getLanguage(LanguageConfig config) {
            return config.getEn();
        }
    },

    /**
     * 日文
     */
    JPN(5, "JPN") {
        @Override
        public String getLanguage(LanguageConfig config) {
            return config.getJpn();
        }
    },

    /**
     * 韩文
     */
    KOR(6, "KOR") {
        @Override
        public String getLanguage(LanguageConfig config) {
            return config.getKor();
        }
    },

    /**
     * 越南
     */
    VN(7, "VN") {
        @Override
        public String getLanguage(LanguageConfig config) {
            return config.getVn();
        }
    },
    /**
     * 泰国
     */
    THAI(8, "THAI") {
        @Override
        public String getLanguage(LanguageConfig config) {
            return config.getThai();
        }
    },
    ;

    private int code;

    private String fieldName;

    private Language(int code, String fieldName) {
        this.code = code;
        this.fieldName = fieldName;
    }

    public String getLanguage(LanguageConfig config) {
        return config.getValue();
    }

    public static Language valueOf(int scope) {
        if (scope >= Language.class.getEnumConstants().length) {
            return CN;
        }
        return Language.class.getEnumConstants()[scope];
    }


}
