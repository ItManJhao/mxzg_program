package com.ayjs.mxzg.common.agent;

import lombok.extern.slf4j.Slf4j;

import java.net.URL;
import java.net.URLClassLoader;

/**
 *
 */
@Slf4j
public class HotSwapClassloader extends URLClassLoader {

    public HotSwapClassloader(URL[] urls) {
        super(urls, ClassLoader.getSystemClassLoader().getParent());
    }

    @Override
    protected synchronized Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        final Class<?> loadedClass = findLoadedClass(name);
        if (loadedClass != null) {
            return loadedClass;
        }

        // 优先从parent（SystemClassLoader）里加载系统类，避免抛出ClassNotFoundException
        if (name != null && (name.startsWith("sun.") || name.startsWith("java."))) {
            return super.loadClass(name, resolve);
        }
        try {
            Class<?> aClass = findClass(name);
            if (resolve) {
                resolveClass(aClass);
            }
            return aClass;
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
        return super.loadClass(name, resolve);
    }
}
