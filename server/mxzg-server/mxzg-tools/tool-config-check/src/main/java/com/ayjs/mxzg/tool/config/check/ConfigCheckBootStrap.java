package com.ayjs.mxzg.tool.config.check;

import com.ayjs.mxzg.common.excel.ExcelLoader;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.dao.PersistenceExceptionTranslationAutoConfiguration;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.LocalDateTime;


/**
 * @author LY
 * @date 2020/9/28 14:19
 * @Time 14:19
 */
@Slf4j
@ComponentScan(basePackages = {"com.ayjs.mxzg.tool", "com.ayjs.mxzg.config", "com.ayjs.mxzg.common"})
@SpringBootApplication(exclude = {PersistenceExceptionTranslationAutoConfiguration.class})
@Component
public class ConfigCheckBootStrap {
    public static void main(String[] args) {
        ConfigurableApplicationContext ctx = null;
        try {
            ctx = SpringApplication.run(ConfigCheckBootStrap.class, args);
//            CheckConfig bean = ctx.getBean(CheckConfig.class);
//            System.out.println("配置文件路径:"+bean.getConfigPath());
//            args[0] = "D:\\project\\mxzg\\svn\\idle_plan\\doc\\gameconfig\\config-hk-test";
//            args = new String[1];
            log.info("args:{}", args);
            if (args == null) {
                log.error("请输入配置文件路径！");
            } else {
                LocalDateTime startTime = LocalDateTime.now();
                ExcelLoader.load(args[0]);
                LocalDateTime endTime = LocalDateTime.now();
                Duration between = Duration.between(startTime, endTime);
                log.info("配置文件加载完成！ Millis:{}", between.toMillis());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ctx.close();
        }
    }
}
