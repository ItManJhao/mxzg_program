package com.ayjs.mxzg.largecross.web.support;


import java.util.Collection;
import java.util.function.Supplier;


/**
 * web的断言
 */
public class WebAsserts {

    public static void notNull(Object object, int errorCode, String message) {
        if (object == null) {
            throw new WebErrorCodeException(message, errorCode);
        }
    }

    public static void notNull(Object object, int errorCode, Supplier<String> messageSupplier) {
        if (object == null) {
            throw new WebErrorCodeException(nullSafeGet(messageSupplier), errorCode);
        }
    }

    public static void notEmpty(Collection<?> collection, int errorCode, String message) {
        if (collection == null || collection.size() <= 0) {
            throw new WebErrorCodeException(message, errorCode);
        }
    }

    public static void isTrue(boolean expression, int errorCode, String message) {
        if (!expression) {
            throw new WebErrorCodeException(message, errorCode);
        }
    }

    private static String nullSafeGet(Supplier<String> messageSupplier) {
        return (messageSupplier != null ? messageSupplier.get() : null);
    }
}
