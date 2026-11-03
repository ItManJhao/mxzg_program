package com.ayjs.mxzg.common.agent;

import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.lang.instrument.Instrumentation;
import java.net.URLDecoder;

/**
 *
 */
@Slf4j
public class AgentBootstrap {

    // 全局持有classloader用于隔离 Arthas 实现
    private static volatile ClassLoader hotSwapClassLoader;

    private int pid;
    private Instrumentation instrumentation;

    public static void premain(String args, Instrumentation inst) {
        main(args, inst);
    }

    public static void agentmain(String args, Instrumentation inst) {
        main(args, inst);
    }

    private static synchronized void main(String args, final Instrumentation inst) {
        try {
            log.info("Arthas server agent start...");
            // 传递的args参数分两个部分:agentJar路径和agentArgs, 分别是Agent的JAR包路径和期望传递到服务端的参数
            args = decodeArg(args);
            int index = args.indexOf(';');
            String agentJar = args.substring(0, index);
            final String agentArgs = args.substring(index);

            File agentJarFile = new File(agentJar);
            if (!agentJarFile.exists()) {
                log.info("Agent jar file does not exist: " + agentJarFile);
                return;
            }

//            File spyJarFile = new File(agentJarFile.getParentFile(), ARTHAS_SPY_JAR);
//            if (!spyJarFile.exists()) {
//                log.info("Spy jar file does not exist: " + spyJarFile);
//                return;
//            }

            /**
             * Use a dedicated thread to run the binding logic to prevent possible memory leak. #195
             */
            final ClassLoader agentLoader = getClassLoader(inst, agentJarFile);
//            initSpy(agentLoader);

            Thread bindingThread = new Thread() {
                @Override
                public void run() {
                    try {
                        bind(inst, agentLoader, agentArgs);
                    } catch (Throwable throwable) {
                        log.error("binding error", throwable);
                        throwable.printStackTrace();
                    }
                }
            };

            bindingThread.setName("arthas-binding-thread");
            bindingThread.start();
            bindingThread.join();
        } catch (Throwable t) {
            log.error("AgentBootstrap start error", t);
            t.printStackTrace();
            throw new RuntimeException(t);
        }
    }

    private static ClassLoader loadOrDefineClassLoader(File agentJar) throws Throwable {
        if (hotSwapClassLoader == null) {
//            hotSwapClassLoader = new HotSwapClassloader(new URL[]{agentJar.toURI().toURL()});
        }
        return hotSwapClassLoader;
    }

    private static ClassLoader getClassLoader(Instrumentation inst, File agentJarFile) throws Throwable {
        // 将Spy添加到BootstrapClassLoader
//        inst.appendToBootstrapClassLoaderSearch(new JarFile(spyJarFile));

        // 构造自定义的类加载器，尽量减少Arthas对现有工程的侵蚀
        return loadOrDefineClassLoader(agentJarFile);
    }

    private static void bind(Instrumentation inst, ClassLoader agentLoader, String args) throws Throwable {

//        Configure configure = Configure.toConfigure(args);
//        int javaPid = configure.getJavaPid();
//        AgentBootstrap bootstrap = AgentBootstrap.getInstance(javaPid, inst);

//        Class<?> classOfConfigure = agentLoader.loadClass(ARTHAS_CONFIGURE);
//        Object configure = classOfConfigure.getMethod(TO_CONFIGURE, String.class).invoke(null, args);
//        int javaPid = (Integer) classOfConfigure.getMethod(GET_JAVA_PID).invoke(configure);
//        Class<?> bootstrapClass = agentLoader.loadClass(ARTHAS_BOOTSTRAP);
//        Object bootstrap = bootstrapClass.getMethod(GET_INSTANCE, int.class, Instrumentation.class).invoke(null, javaPid, inst);
//        boolean isBind = (Boolean) bootstrapClass.getMethod(IS_BIND).invoke(bootstrap);
//        if (!isBind) {
//            try {
//                log.info("Arthas start to bind...");
//                bootstrapClass.getMethod(BIND, classOfConfigure).invoke(bootstrap, configure);
//                log.info("Arthas server bind success.");
//                return;
//            } catch (Exception e) {
//                log.info("Arthas server port binding failed! Please check $HOME/logs/arthas/arthas.log for more details.");
//                throw e;
//            }
//        }
        log.info("Arthas server already bind.");
    }

    private static String decodeArg(String arg) {
        try {
            return URLDecoder.decode(arg, "utf-8");
        } catch (UnsupportedEncodingException e) {
            log.error(e.getMessage(), e);
            return arg;
        }
    }
}
