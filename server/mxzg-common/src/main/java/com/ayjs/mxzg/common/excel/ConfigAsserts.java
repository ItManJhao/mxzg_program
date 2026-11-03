package com.ayjs.mxzg.common.excel;

import org.springframework.lang.Nullable;

import java.util.Collection;
import java.util.function.Supplier;

/**
 * 配置文件断言
 */
public class ConfigAsserts {

    public static void notNull(@Nullable Object object, String message) {
        if (object == null) {
            throw new ConfigNotFoundException(message);
        }
    }

    public static void notNull(@Nullable Object object, Supplier<String> messageSupplier) {
        if (object == null) {
            throw new ConfigNotFoundException(nullSafeGet(messageSupplier));
        }
    }

    public static void isTrue(boolean expression, String message) {
        if (!expression) {
            throw new ConfigNotFoundException(message);
        }
    }

    public static void isTrue(boolean expression, Supplier<String> messageSupplier) {
        if (!expression) {
            throw new ConfigNotFoundException(nullSafeGet(messageSupplier));
        }
    }

    public static void notEmpty(@Nullable Collection<?> collection, String message) {
        if (collection == null || collection.isEmpty()) {
            throw new ConfigNotFoundException(message);
        }
    }

    public static void notEmpty(@Nullable Collection<?> collection, Supplier<String> messageSupplier) {
        if (collection == null || collection.isEmpty()) {
            throw new ConfigNotFoundException(nullSafeGet(messageSupplier));
        }
    }

    private static String nullSafeGet(Supplier<String> messageSupplier) {
        return (messageSupplier != null ? messageSupplier.get() : null);
    }
}
