package com.ayjs.mxzg.tools.generate;

import com.ayjs.mxzg.tools.generate.module.server.domain.Server;
import com.ayjs.mxzg.tools.generate.module.server.service.ServerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.dao.PersistenceExceptionTranslationAutoConfiguration;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.ComponentScan;

import java.util.List;

/**
 * 生成服务器配置文件
 */
@ComponentScan(basePackages = {"com.ayjs"})
@SpringBootApplication(exclude = {PersistenceExceptionTranslationAutoConfiguration.class})
@Slf4j
public class GenerateProperties {

    public static void main(String[] args) throws Exception {

        SpringApplication application = new SpringApplication(GenerateProperties.class);
        ConfigurableApplicationContext ctx = application.run(args);

        // 2.获取服务器列表
        ServerService serverService = ctx.getBean(ServerService.class);
        List<Server> servers = serverService.findAll();
        servers.forEach(server -> log.info("server:{}", server));
        log.info("server 1001:{}", serverService.getServer(1001));
        // 3.生成application-release.properties
        serverService.generateFile(1001);
        // 4.生成database-game.properties

        // 5.生成database-log.properties

        // 6.

        // 7.

        // 8.
    }
}
