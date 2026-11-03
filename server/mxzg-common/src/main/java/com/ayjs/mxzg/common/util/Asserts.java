package com.ayjs.mxzg.common.util;

import com.ayjs.mxzg.common.exception.ErrorCodeException;
import org.springframework.lang.Nullable;
import org.springframework.util.Assert;

import java.util.Collection;
import java.util.Map;
import java.util.function.Supplier;

/**
 * Assert工具类，断言失败抛出{@link ErrorCodeException}
 */
public class Asserts extends Assert {

	public static interface AssertCode {
		int getCode();
	}
	
    public static void state(boolean expression, int errorCode, String message) {
        if (!expression) {
            throw new ErrorCodeException(errorCode, message);
        }
    }

    public static void state(boolean expression, int errorCode, Supplier<String> messageSupplier) {
        if (!expression) {
            throw new ErrorCodeException(errorCode, nullSafeGet(messageSupplier));
        }
    }

    public static void isTrue(boolean expression, AssertCode assertCode, String message) {
        if (!expression) {
            throw new ErrorCodeException(assertCode.getCode(), message);
        }
    }
    
    public static void isTrue(boolean expression, int errorCode, String message) {
        if (!expression) {
            throw new ErrorCodeException(errorCode, message);
        }
    }

    public static void isTrue(boolean expression, int errorCode, Supplier<String> messageSupplier) {
        if (!expression) {
            throw new ErrorCodeException(errorCode, nullSafeGet(messageSupplier));
        }
    }

    public static void notEmpty(@Nullable Object[] array, int errorCode, String message) {
        if (array == null || array.length == 0) {
            throw new ErrorCodeException(errorCode, message);
        }
    }

    public static void notEmpty(@Nullable Object[] array, int errorCode, Supplier<String> messageSupplier) {
        if (array == null || array.length == 0) {
            throw new ErrorCodeException(errorCode, nullSafeGet(messageSupplier));
        }
    }

    public static void noNullElements(Object[] array, int errorCode, String message) {
        if (array != null) {
            for (Object element : array) {
                if (element == null) {
                    throw new ErrorCodeException(errorCode, message);
                }
            }
        }
    }

    public static void noNullElements(@Nullable Object[] array, int errorCode, Supplier<String> messageSupplier) {
        if (array != null) {
            for (Object element : array) {
                if (element == null) {
                    throw new ErrorCodeException(errorCode, nullSafeGet(messageSupplier));
                }
            }
        }
    }

    public static void notEmpty(@Nullable Collection<?> collection, int errorCode, String message) {
        if (collection == null || collection.isEmpty()) {
            throw new ErrorCodeException(errorCode, message);
        }
    }

    public static void notEmpty(Collection<?> collection, int errorCode, Supplier<String> messageSupplier) {
        if (collection == null || collection.isEmpty()) {
            throw new ErrorCodeException(errorCode, nullSafeGet(messageSupplier));
        }
    }

    public static void notEmpty(@Nullable Map<?, ?> map, int errorCode, String message) {
        if (map == null || map.isEmpty()) {
            throw new ErrorCodeException(errorCode, message);
        }
    }

    public static void notEmpty(@Nullable Map<?, ?> map, int errorCode, Supplier<String> messageSupplier) {
        if (map == null || map.isEmpty()) {
            throw new ErrorCodeException(errorCode, nullSafeGet(messageSupplier));
        }
    }

    public static void isNull(@Nullable Object object, int errorCode, String message) {
        if (object != null) {
            throw new ErrorCodeException(errorCode, message);
        }
    }

    public static void isNull(@Nullable Object object, int errorCode, Supplier<String> messageSupplier) {
        if (object != null) {
            throw new ErrorCodeException(errorCode, nullSafeGet(messageSupplier));
        }
    }

    public static void notNull(@Nullable Object object, int errorCode, String message) {
        if (object == null) {
            throw new ErrorCodeException(errorCode, message);
        }
    }

    public static void notNull(@Nullable Object object, int errorCode, Supplier<String> messageSupplier) {
        if (object == null) {
            throw new ErrorCodeException(errorCode, nullSafeGet(messageSupplier));
        }
    }

    private static String nullSafeGet(Supplier<String> messageSupplier) {
        return (messageSupplier != null ? messageSupplier.get() : null);
    }
}
