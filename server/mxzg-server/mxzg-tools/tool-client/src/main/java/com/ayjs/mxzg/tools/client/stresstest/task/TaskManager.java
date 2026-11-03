package com.ayjs.mxzg.tools.client.stresstest.task;

import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ProtocolRegistry;
import com.google.protobuf.Message;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

/**
 * 压测任务管理器
 *
 * @author tangyangbo 2019/8/30 20:53
 */
@Slf4j
public class TaskManager {


    @Getter
    private static List<TaskEntity> tasks = new ArrayList<>();
    @Getter
    private static int taskLength;
    // 任务开始时间
    private static long startTime;

    private static Set<Integer> ignoreRequestId = new HashSet<>();

    static {
        ignoreRequestId.add(ClientCMD.PLAYER_LOGIN_CMD);
        ignoreRequestId.add(ClientCMD.PLAYER_REG_CMD);
        ignoreRequestId.add(ClientCMD.HEART_BEAT);
    }

    public TaskManager() {

    }

    public static synchronized void init(String filePath) {
        if (org.apache.commons.lang3.StringUtils.isBlank(filePath)) {
            filePath = TaskManager.class.getClassLoader().getResource("").getPath() + "../../src/main/resources/message.txt";
        }
        log.error(">>>>>message script:{}", filePath);
        try {
            FileInputStream inputStream = new FileInputStream(filePath);
            InputStreamReader reader = new InputStreamReader(inputStream);
            loadMessageData(reader);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        taskLength = tasks.size();
    }

    /**
     * 生成任务实体
     *
     * @param context 示例：10001=时间戳毫秒={"idx": [35]}
     * @return
     */
    public static TaskEntity generateTaskEntity(String context) {
        TaskEntity taskEntity = null;
        try {
            String[] temp = context.split("=");
            int messageId = Integer.parseInt(temp[0]);
            if (ignoreRequestId.contains(messageId)) {
                return null;
            }
            Message reqMessage = ProtocolRegistry.getReqMessage(messageId);
            long requestDateTime = Long.parseLong(temp[1]);
            if (startTime <= 0) {
                startTime = requestDateTime;
            }
            if (Objects.nonNull(reqMessage)) {
                String reqJsonStr = temp[2];
                Message.Builder messageBuilder = reqMessage.newBuilderForType();
                MessageUtils.jsonToMessage(reqJsonStr, messageBuilder);

//                log.info("send {} message, context:{}",
//                        messageId, MessageUtils.formatMessage(messageBuilder.build()));

                taskEntity = new TaskEntity(messageId, requestDateTime, messageBuilder);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return taskEntity;
    }

    public static void loadMessageData(InputStreamReader input) {
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(input);
            String line = null;
            while ((line = reader.readLine()) != null) {
                if (!StringUtils.isEmpty(line)) {
                    TaskEntity taskEntity = generateTaskEntity(line);
                    if (Objects.nonNull(taskEntity)) {
                        tasks.add(taskEntity);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (null != reader) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (null != input) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        log.debug("task size:{}", tasks.size());
    }

    public static long getStartTime() {
        return startTime;
    }

    public static void loadMessageData(String fileName) {
        loadMessageData(new InputStreamReader(ClassLoader.getSystemResourceAsStream(fileName)));
    }
}
