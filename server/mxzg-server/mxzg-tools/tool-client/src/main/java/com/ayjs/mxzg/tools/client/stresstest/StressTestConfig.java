package com.ayjs.mxzg.tools.client.stresstest;

import cn.hutool.setting.dialect.Props;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * 压测配置
 *
 * @author tangyangbo 2019/8/27 20:24
 */
@Slf4j
public class StressTestConfig {

    @Setter
    public static Properties prop;

    public static List<String> chatContext = new ArrayList<>();

    public static void init(String propFile) {
        setProp(Props.getProp(propFile));
    }

    /**
     * openId 前缀
     */
    public static String getPrefix() {
        return ConvertUtils.toString(prop.get("prefix"));
    }

    /**
     * 测试的服务器id
     */
    public static int getServerId() {
        return ConvertUtils.toInt(prop.get("serverId"));
    }

    /**
     * 测试的服务器IP
     */
    public static String getIp() {
        return ConvertUtils.toString(prop.get("ip"));
    }

    /**
     * 测试的服务器 端口
     */
    public static int getPort() {
        return ConvertUtils.toInt(prop.get("port"));
    }

    /**
     * 0，IOS，1，安卓
     */
    public static int getDriveType() {
        return ConvertUtils.toInt(prop.get("driveType"));
    }

    /**
     * 渠道标识
     */
    public static int getChannelId() {
        return ConvertUtils.toInt(prop.get("channelId"));
    }

    /**
     * 子渠道标识
     */
    public static int getChannelSubId() {
        return ConvertUtils.toInt(prop.get("channelSubId"));
    }

    /**
     * 测试数量
     */
    public static int getTestNumbers() {
        return ConvertUtils.toInt(prop.get("testNumber"));
    }

    /**
     * 策划配置文件目录（暂时没用到）
     */
    public static String getConfigPath() {
        return ConvertUtils.toString(prop.get("configPath"));
    }

    /**
     * 登陆间隔
     */
    public static int getConnectPerTime() {
        return ConvertUtils.toInt(prop.get("connectPerTime"));
    }

    /**
     * 请求间隔
     */
    public static int getRequestPerTime() {
        return ConvertUtils.toInt(prop.get("requestPerTime"));
    }

    /**
     * 聊天间隔
     */
    public static int getChatPerTime() {
        return ConvertUtils.toInt(prop.get("chatPerTime"));
    }

    /**
     * 聊天内容
     */
    public static String getChatContext() {
        return ConvertUtils.toString(prop.get("chatContext"));
    }

    public static String getPlatformUrL() {
        return ConvertUtils.toString(prop.get("platformUrL"));
    }

    public static String getMessageScript() {
        return ConvertUtils.toString(prop.get("messageScript"));
    }

    public static String getProtoFile() {
        if (prop == null)
            return "";
        return ConvertUtils.toString(prop.get("protoFile"));
    }

    public static String getChatPath() {
        return ConvertUtils.toString(prop.get("chatPath"));
    }

    public static void initChatContext(String filePath) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            file = new File(StressTestConfig.class.getClassLoader().getResource("chat-context.txt").getFile());
            if (!file.exists()) {
                chatContext.add("聊天测试");
                return;
            }
        }
        log.error(">>>>>chat context：" + filePath);
        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line = null;
        while ((line = reader.readLine()) != null) {
            chatContext.add(line);
        }

    }
}
