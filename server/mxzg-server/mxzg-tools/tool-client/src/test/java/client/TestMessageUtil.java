package client;

import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.protocol.LoginGMsg;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class TestMessageUtil {
    public static void main(String[] args) {
        LoginGMsg.GReqInit.Builder builder = LoginGMsg.GReqInit.newBuilder();
        builder.setNick("你好");
        builder.setPlatform(10);
        builder.setLang(1);

        System.out.println(MessageUtils.formatMessage(builder.build(), true));
        MessageUtils.setMessageBuilderFieldValue(builder, "nick", "好好");
        System.out.println(MessageUtils.formatMessage(builder.build(), true));
    }
}
