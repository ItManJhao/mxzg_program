package com.ayjs.mxzg.common.util;

import com.google.protobuf.Descriptors;
import com.google.protobuf.Message;
import com.google.protobuf.MessageLite;
import com.googlecode.protobuf.format.FormatFactory;
import com.googlecode.protobuf.format.JsonFormat;
import com.googlecode.protobuf.format.ProtobufFormatter;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.handler.codec.http.websocketx.BinaryWebSocketFrame;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Objects;

@Slf4j
public class MessageUtils {

    private final static FormatFactory FORMAT_FACTORY = new FormatFactory();
    private final static ProtobufFormatter PROTOBUF_FORMATTER = FORMAT_FACTORY.createFormatter(FormatFactory.Formatter.JSON);

    public static <T extends MessageLite> String formatMessageLite(T t) {
        if (Objects.isNull(t)) {
            log.error("message is null");
            return "";
        }
        return t.toString().trim().replace("\n", "\n\t");
    }

    public static String formatMessage(Message message, boolean prettyPrinting) {
        String json = new JsonFormat().printToString(message);

        if (prettyPrinting) {
            json = prettyFormatJson(json);
        }
        return json;
    }

    public static String formatMessage(Message message) {
        return formatMessage(message, true);
    }

    private static String prettyFormatJson(String jsonStr) {
        if (null == jsonStr || "".equals(jsonStr)) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        char last;
        char current = '\0';
        int indent = 0;
        for (int i = 0; i < jsonStr.length(); i++) {
            last = current;
            current = jsonStr.charAt(i);
            // 遇到{ [换行，且下一行缩进
            switch (current) {
                case '{':
                case '[':
                    sb.append(current);
                    sb.append('\n');
                    indent++;
                    addIndentBlank(sb, indent);
                    break;
                // 遇到} ]换行，当前行缩进
                case '}':
                case ']':
                    sb.append('\n');
                    indent--;
                    addIndentBlank(sb, indent);
                    sb.append(current);
                    break;
                // 遇到,换行
                case ',':
                    sb.append(current);
                    if (last != '\\') {
                        sb.append('\n');
                        addIndentBlank(sb, indent);
                    }
                    break;
                default:
                    sb.append(current);
            }
        }
        return sb.toString();
    }

    private static void addIndentBlank(StringBuilder sb, int indent) {
        for (int i = 0; i < indent; i++) {
            sb.append('\t');
        }
    }

    public static void jsonToMessage(String json, Message.Builder builder) {
        try {
            InputStream is = IOUtils.toInputStream(json, StandardCharsets.UTF_8.name());
            PROTOBUF_FORMATTER.merge(is, builder);
        } catch (Exception e) {
            log.error("jsonToMessage json:{}", json);
            throw new RuntimeException("jsonFillMessage异常: " + e.getMessage(), e);
        }
    }


    public static BinaryWebSocketFrame getFrame(MessageLite proto) {
        byte[] bytes = proto.toByteArray();
        ByteBuf buf = Unpooled.copiedBuffer(bytes);
        return new BinaryWebSocketFrame(buf);
    }

    /**
     * 设置Builder字段值
     *
     * @param builder
     * @param fieldName
     * @param value
     */
    public static void setMessageBuilderFieldValue(Message.Builder builder, String fieldName, Object value) {
        Map<Descriptors.FieldDescriptor, Object> allFields = builder.getAllFields();
        for (Map.Entry<Descriptors.FieldDescriptor, Object> entry : allFields.entrySet()) {
            Descriptors.FieldDescriptor fieldDescriptor = entry.getKey();
            if (fieldName.equals(fieldDescriptor.getName())) {
                builder.setField(entry.getKey(), value);
            }
        }
    }

    /**
     * 设置Builder字段值
     *
     * @param builder
     * @param fieldName
     */
    public static Object getMessageBuilderFieldValue(Message.Builder builder, String fieldName) {
        Map<Descriptors.FieldDescriptor, Object> allFields = builder.getAllFields();
        for (Map.Entry<Descriptors.FieldDescriptor, Object> entry : allFields.entrySet()) {
            Descriptors.FieldDescriptor fieldDescriptor = entry.getKey();
            if (fieldName.equals(fieldDescriptor.getName())) {
                return builder.getField(entry.getKey());
            }
        }
        return null;
    }


}