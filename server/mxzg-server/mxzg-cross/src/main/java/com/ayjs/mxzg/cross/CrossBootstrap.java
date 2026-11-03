package com.ayjs.mxzg.cross;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleSupport;
import com.ayjs.mxzg.cross.infrastructure.persistence.DataSourceInitializer;
import lombok.extern.slf4j.Slf4j;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.LoggerContext;
import org.apache.logging.log4j.core.config.Configurator;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.dao.PersistenceExceptionTranslationAutoConfiguration;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Properties;

/**
 * 启动类
 */
@ComponentScan(basePackages = {"com.ayjs"})
@SpringBootApplication(exclude = {PersistenceExceptionTranslationAutoConfiguration.class})
@Slf4j
@EnableScheduling
public class CrossBootstrap {
    public static void main(String[] args) {
        List<Lifecycle> started = new ArrayList<>();
        try {
            SpringApplication application = new SpringApplication(CrossBootstrap.class);
            //加载配置文件数据
            application.addInitializers(new DataSourceInitializer());
            ConfigurableApplicationContext ctx = application.run(args);

            // 启动服务
            Collection<Lifecycle> services = SpringProxy.getBeansOfType(Lifecycle.class);
            LifecycleSupport.start(services, started::add);

            // jvm退出前的清理操作
            Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                // 关闭服务
                LifecycleSupport.stop(started);
                ctx.close();
                if (LogManager.getContext() instanceof LoggerContext) {
                    log.info("Shutting down log4j2");
                    Configurator.shutdown((LoggerContext) LogManager.getContext());
                }
                log.info("跨服-服务器已关闭...");
                System.out.println("Cross Server stopped...");
            }));

            log.info("跨服-服务器已启动...");
            log.info("Cross Server started...");
            log.info("------------------------------------------------------------------------");
        } catch (Exception e) {
            e.printStackTrace();
            log.info("");

            log.error("Cross Server startup failure...", e);
            // 关闭服务
            LifecycleSupport.stop(started);
            System.exit(-1);
        }
        
        listenInput();
    }
    
    /**
     * 在windows系统上运行的时候，用命令来关闭
     */
    private static void listenInput() {
        try {
        	Properties properties = System.getProperties();
        	if(!properties.get("os.name").toString().contains("Windows")) {
        		return;
        	}
        	
        	InputStream is = System.in;
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
        	while(true) {
    			String inputStr = br.readLine();
    			if("stop".equals(inputStr)) {
    				System.exit(0);
    			}
        	}
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
    
}