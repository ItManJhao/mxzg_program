package com.ayjs.mxzg.common.util;

import com.google.common.collect.Interner;
import com.google.common.collect.Interners;
import org.apache.commons.lang3.StringUtils;

public enum InternerPool {

    INSTANCE;

    private final Interner<String> pool = Interners.newWeakInterner();

    public static String intern(Object... args) {
        return INSTANCE.pool.intern(StringUtils.join(args, SymbolConstants.UNDERSCORE));
    }
}
