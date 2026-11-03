package com.ayjs.mxzg.tools.generate.module.server.service;

import cn.hutool.core.convert.Convert;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.CharsetUtil;
import com.ayjs.mxzg.tools.generate.module.server.dao.ServerDao;
import com.ayjs.mxzg.tools.generate.module.server.domain.ConfigValue;
import com.ayjs.mxzg.tools.generate.module.server.domain.Server;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedWriter;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
public class ServerService {
    @Autowired
    private ServerDao serverDao;

    private final static String noteChat = "#";
    private final static String equalChat = "=";

    public Server getServer(long serverId) {
        return serverDao.getOne(serverId);
    }

    public List<Server> findAll() {
        return serverDao.findAll();
    }

    /**
     * 生成application-release.properties
     */
    public void generateFile(long serverId) throws Exception {
        Server server = getServer(serverId);
        if (Objects.isNull(server)) {
            return;
        }
        List<ConfigValue> configs = new ArrayList<>();
        configs.add(ConfigValue.of("server.debug", Boolean.TRUE, "debug开关"));
        configs.add(ConfigValue.of("gm.cmd.open", Boolean.FALSE, "gm命令开关"));
        configs.add(ConfigValue.of("server.id", server.getId(), "#服务器id"));
        configs.add(ConfigValue.of("network.tcpSocket.port", server.getGame_port(), "#tcpsocket绑定的端口"));
        configs.add(ConfigValue.of("server.port", server.getHttp_port(), "# web配置"));
        configs.add(ConfigValue.of("center.server.host", "127.0.0.1", "#中心服地址"));
        configs.add(ConfigValue.of("center.server.port", "20001", "#中心服端口"));
        configs.add(ConfigValue.of(null, null, null));
        configs.add(ConfigValue.of("server.platformId", 100, "#服务器平台ID"));
        configs.add(ConfigValue.of("server.platformSonId", 10001, "#服务器子平台ID"));

        configs.add(ConfigValue.of(null, null, null));
        configs.add(ConfigValue.of(null, null, "################redis基础配置#################"));
        configs.add(ConfigValue.of("spring.redis.database", 0, null));
        configs.add(ConfigValue.of("spring.redis.host", "127.0.0.1", null));
        configs.add(ConfigValue.of("spring.redis.password", "^-^ayjsgame!@#redis&201912", null));
        configs.add(ConfigValue.of("spring.redis.port", "11001", null));
        configs.add(ConfigValue.of("spring.redis.timeout", "3000", "连接超时时间 单位 ms（毫秒）"));

        String filePath = "e:/application-release.properties";
        File file = new File(filePath);
        if (!file.exists()) {
            file.createNewFile();
        }
        writeToFile(file, configs);
    }

    public void writeToFile(File file, List<ConfigValue> configValues) {
        try {
            BufferedWriter writer = FileUtil.getWriter(file, CharsetUtil.CHARSET_UTF_8, true);
            configValues.forEach(configValue -> {
                try {
                    if (Objects.nonNull(configValue.getDesc())) {
                        writer.newLine();
                        writer.write(noteChat);
                        writer.write(configValue.getDesc());
                    }
                    if (Objects.nonNull(configValue.getKey())) {
                        writer.newLine();
                        writer.write(configValue.getKey());
                        writer.write(equalChat);
                        writer.write(Convert.toStr(configValue.getValue()));
                    }
                    if (Objects.isNull(configValue.getDesc()) && Objects.isNull(configValue.getKey())) {
                        writer.newLine();
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
            writer.flush();
            writer.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
