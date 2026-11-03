package com.ayjs.mxzg.common.util;

import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

/**
 * 带名字的线程
 */
public class NamesThreadFactory implements ThreadFactory {

    private final String name;
    private final ThreadFactory threadFactory;

    public NamesThreadFactory(String name) {
        this.name = name;
        this.threadFactory = Executors.defaultThreadFactory();
    }

    @Override
    public Thread newThread(Runnable r) {
        Thread thread = threadFactory.newThread(r);
        thread.setName(name + " " + thread.getName().toUpperCase());
        return thread;
    }
}
