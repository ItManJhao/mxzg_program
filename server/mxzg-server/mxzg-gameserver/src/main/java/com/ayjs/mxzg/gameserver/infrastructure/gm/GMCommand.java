package com.ayjs.mxzg.gameserver.infrastructure.gm;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * gm命令
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface GMCommand {
    /**
     * gm命令
     *
     * @return
     */
    String command();
}
