package com.ayjs.mxzg.tools.client.client.base;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.ReUtil;
import com.ayjs.mxzg.common.util.scanner.PackageScanner;
import com.ayjs.mxzg.protocol.RoleGMsg;
import com.ayjs.mxzg.tools.client.stresstest.StressTestConfig;
import com.esotericsoftware.reflectasm.MethodAccess;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.protobuf.Message;
import com.google.protobuf.MessageLite;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.FileFilter;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Objects;
import java.util.regex.Pattern;


/**
 * 协议注册
 * 1,解析BaseHandler的子类
 * 2,解析proto文件
 *
 * @author tangyangbo 2019/8/6 17:05
 */
@Slf4j
public class ProtocolRegistry {


    @Getter
    private static final BiMap<Integer, Message> reqProtocolMap = HashBiMap.create();
    @Getter
    private static final BiMap<Integer, Message> respProtocolMap = HashBiMap.create();

    private static final String CLASS_PATH = "/target/classes/";
    private static final String PROTO_PATH = "/protofiles/game/";

    private static final String REQ_MSG = "GReq";
    private static final String RSP_MSG = "GRes";
    private static final String BC = "BC";
    private static final String MESSAGE = "message";

    /**
     * 初始化协议号和协议类的关系
     */
    public static void init() {
        // 读协议类所在的目录，缺点是服务器主动推送的BC消息解析不到
//        Set<Class<BaseHandler>> classes = PackageScanner.scanPackages(
//                clazz -> TypeUtils.isAssignable(clazz, BaseHandler.class), BaseConfig.SCAN_PACKAGE_NAME);
//
//        classes.forEach(clazz -> {
//            HandlerAnnotation handlerAnnotation = clazz.getAnnotation(HandlerAnnotation.class);
//            int messageId = handlerAnnotation.messageId();
//            Class<MessageLite> messageType = getReqType(clazz);
//
//            reqProtocolMap.put(messageId, methodAccess(messageType));
//
//            String responseName = messageType.getName().replace(REQ_MSG, RSP_MSG);
//            Message respMessage = getMessageByClassName(responseName);
//            if (Objects.nonNull(respMessage)) {
//                respProtocolMap.put(messageId, respMessage);
//            }
//        });
        // 解析协议文件方式
        String protoFile = StressTestConfig.getProtoFile();
        if (StringUtils.isBlank(protoFile)) {
            String cmdPlayerPath = RoleGMsg.class.getResource("").getPath();
            String classPath = PackageScanner.resolveBasePackage(RoleGMsg.class.getPackage().getName());
            // 特殊处理了
            protoFile = cmdPlayerPath.replace(classPath, "").replace(CLASS_PATH, PROTO_PATH);
        }
        log.error(">>>>>proto file：" + protoFile);
        resolverProto(protoFile);

        log.error("Protocol Registry request size:{} response seize:{}", reqProtocolMap.size(), respProtocolMap.size());
    }

    private static Message methodAccess(Class<MessageLite> messageLiteClass) {
        MethodAccess methodAccess = MethodAccess.get(messageLiteClass);
        return (Message) methodAccess.invoke(null, "getDefaultInstance");
    }

    private static Message getMessageByClassName(String messageName) {
        Class<MessageLite> clazz = null;
        Message respMessage = null;
        try {
            clazz = (Class<MessageLite>) Class.forName(messageName);
            respMessage = methodAccess(clazz);
        } catch (Exception e) {
            // 尝试寻找，有可能找不到，打印也没什么用
//            e.printStackTrace();
        }
        return respMessage;
    }

    public static Message getReqMessage(int messageId) {
        return reqProtocolMap.get(messageId);
    }

    public static Message getRspMessage(int messageId) {
        return respProtocolMap.get(messageId);
    }

    /**
     * 正则：Proto 中的协议号
     */
    public static final Pattern PROTO_PATTERN = Pattern.compile("(\\d+)", Pattern.CASE_INSENSITIVE);
    /**
     * 正则：Message 中的协议号
     */
//    public static final Pattern MESSAGE_PATTERN = Pattern.compile("message\\s?(.*?)", Pattern.CASE_INSENSITIVE);
    /**
     * 类名
     */
    public static final Pattern CLASS_NAME_PATTERN = Pattern.compile("\"(.*?)\"", Pattern.CASE_INSENSITIVE);

    public static final String PACKAGE_PATH = "com.ayjs.mxzg.protocol.";

    public static void resolverProto(String filePath) {
        List<File> protos = FileUtil.loopFiles(filePath, new FileFilter() {
            @Override
            public boolean accept(File pathname) {
                return pathname.getName().endsWith("proto");
            }
        });

        for (File file : protos) {
            List<String> protoContext = FileUtil.readLines(file, StandardCharsets.UTF_8);
            int lastProto = 0;
            int lastIndex = 0;
            int i = 0;
            String className = "";
            for (String lineContext : protoContext) {
                i++;
                String protoStr = "";
                if (lineContext.contains("option java_outer_classname")) {
                    className = ReUtil.getGroup1(CLASS_NAME_PATTERN, lineContext) + "$";

                    continue;
                }
                if (lineContext.startsWith("//")) {
                    protoStr = ReUtil.getGroup1(PROTO_PATTERN, lineContext);
                }
                if (StringUtils.isNotEmpty(protoStr)) {
                    lastProto = Integer.parseInt(protoStr);
                    lastIndex = i;
                    continue;
                }
                if (i - lastIndex > 1) {
                    lastProto = 0;
                    continue;
                }
                if (!lineContext.contains(MESSAGE)) {
                    continue;
                }
                lineContext = lineContext.replace("}", "");
                lineContext = lineContext.replace("{", "");
                String messageStr = lineContext.substring(7, lineContext.length()).trim();

                if (messageStr.contains(REQ_MSG)) {
                    Message reqMessage = getMessageByClassName(PACKAGE_PATH + className + messageStr);
                    if (Objects.nonNull(reqMessage)) {
                        reqProtocolMap.put(lastProto, reqMessage);
//                        log.info("proto:{}, req:{}", lastProto, reqMessage.getClass().getSimpleName());
                    }
                } else if (messageStr.contains(RSP_MSG)) {
                    Message resMessage = getMessageByClassName(PACKAGE_PATH + className + messageStr);
                    if (Objects.nonNull(resMessage)) {
                        respProtocolMap.put(lastProto, resMessage);
//                        log.info("proto:{}, req:{}", lastProto, resMessage.getClass().getSimpleName());
                    }
                }
                if (messageStr.contains(BC)) {
                    Message bcMessage = getMessageByClassName(PACKAGE_PATH + className + messageStr);
                    if (Objects.nonNull(bcMessage)) {
                        respProtocolMap.put(lastProto, bcMessage);
//                        log.info("proto:{}, req:{}", lastProto, bcMessage.getClass().getSimpleName());
                    }
                }
            }
        }
    }
}
