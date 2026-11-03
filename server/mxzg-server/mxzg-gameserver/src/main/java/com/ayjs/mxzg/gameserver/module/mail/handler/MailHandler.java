package com.ayjs.mxzg.gameserver.module.mail.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.global.platform.PlatformSupport;
import com.ayjs.mxzg.gameserver.module.mail.domain.ExchangeCodeResponseData;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailSomeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.support.PlatformHttpResult;
import com.ayjs.mxzg.protocol.CodeGMsg;
import com.ayjs.mxzg.protocol.LoginGMsg;
import com.ayjs.mxzg.protocol.MailGMsg.GReqDealWithMail;
import com.ayjs.mxzg.protocol.MailGMsg.GReqDeleteAllMail;
import com.ayjs.mxzg.protocol.MailGMsg.GReqMailList;
import com.ayjs.mxzg.protocol.MailGMsg.GReqReceiveAllMail;
import com.ayjs.mxzg.protocol.MailGMsg.GResDealWithMail;
import com.ayjs.mxzg.protocol.MailGMsg.GResDeleteAllMail;
import com.ayjs.mxzg.protocol.MailGMsg.GResMailList;
import com.ayjs.mxzg.protocol.MailGMsg.GResReceiveAllMail;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
public class MailHandler extends ProtocolHandler {

    @Autowired
    private MailService mailService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private MailSomeService mailSomeService;
    @Autowired
    private PlatformSupport platformSupport;
    @Autowired
    private SystemSysCache systemSysCache;

    /**
     * 邮件列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._15000)
    public void mailList(PlayerContext playerContext, GReqMailList msg) {
        GResMailList.Builder builder = GResMailList.newBuilder();
        //拉取系统邮件
        mailSomeService.checkUnTakeMail(playerContext.getId());

        List<Mail> mails = mailService.getAll(playerContext.getId());
        List<Mail> deleteMails = new ArrayList<>();
        int deleteTime = TimeDateUtil.getCurrentTimeInt() - systemSysCache.getMailDeleteDay() * TimeDateUtil.ONEDAYINT;
        for (Mail mail : mails) {
            if (mail.getIsReceive() == 1 && mail.getTime() < deleteTime) {
                deleteMails.add(mail);
            }
        }
        if (!deleteMails.isEmpty()) {
            mailService.removeMailAll(deleteMails);
            mails = mailService.getAll(playerContext.getId());
        }
        for (Mail mail : mails) {
            builder.addList(mailService.serializeMail(mail));
        }
        playerContext.write(CmdCode._15000, builder.build());
    }

    /**
     * 邮件操作
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._15001)
    public void dealWithMail(PlayerContext playerContext, GReqDealWithMail msg) {
        if (msg.getMailId() <= 0) {
            //TODO 参数错误
            return;
        }
        Mail mail = mailService.get(playerContext.getId(), msg.getMailId());
        if (mail == null) {
            //TODO 未找到该邮件
            return;
        }
        if (msg.getType() == 0) {
            //阅读
            if (mail.getIsRead() != 1) {
                mail.setIsRead(1);
                mailService.updateMail(mail);
            }
        } else if (msg.getType() == 1) {
            //领取
            if (mail.getIsReceive() == 0) {
                List<ImmutableThing> rewardList = ImmutableThingUtil.fromJson(mail.getGoods());
                mail.setIsReceive(1);
                mailService.updateMail(mail);

                if (rewardList != null && !rewardList.isEmpty()) {
                    thingService.add(playerContext.getId(), rewardList, GameEvent.of(mail.getGameEvent()));
                }
            }
        } else if (msg.getType() == 2) {
            //删除
            mailService.removeMail(mail);
        }
        GResDealWithMail.Builder builder = GResDealWithMail.newBuilder();
        builder.setMailId(msg.getMailId());
        builder.setType(msg.getType());
        playerContext.write(CmdCode._15001, builder.build());
    }

    @CMD(id = CmdCode._15003)
    public void receiveAllMail(PlayerContext playerContext, GReqReceiveAllMail msg) {
        List<Mail> mailList = mailService.getAll(playerContext.getId());

        GResReceiveAllMail.Builder builder = GResReceiveAllMail.newBuilder();
        List<Mail> receiveMails = new ArrayList<>();
        List<ImmutableThing> rewardList = new ArrayList<>();
        for (Mail mail : mailList) {
            if (mail.getIsReceive() == 0) {
                if (!mail.getGoods().equals("")) {
                    rewardList.addAll(ImmutableThingUtil.fromJson(mail.getGoods()));
                }
                mail.setIsRead(1);
                mail.setIsReceive(1);
                receiveMails.add(mail);
                builder.addMailIds(mail.getId());
            }
        }
        if (!receiveMails.isEmpty()) {
            mailService.updateMailAll(receiveMails);
        }
        rewardList = ImmutableThingUtil.mergeThing(rewardList);
        long allItemNums = ImmutableThingUtil.getAllItemNums(rewardList);
        if (allItemNums > 0) {
            thingService.add(playerContext.getId(), rewardList, GameEvent.MAIL_GET_ALL);
        }

        playerContext.write(CmdCode._15003, builder.build());
    }


    @CMD(id = CmdCode._15004)
    public void deleteMails(PlayerContext playerContext, GReqDeleteAllMail msg) {

        List<Mail> mailList = mailService.getAll(playerContext.getId());

        GResDeleteAllMail.Builder builder = GResDeleteAllMail.newBuilder();

        List<Mail> deleteMails = new ArrayList<>();
        for (Mail mail : mailList) {
            if (mail.getIsRead() == 1 && mail.getIsReceive() == 1) {
                deleteMails.add(mail);
                builder.addMailIds(mail.getId());
            }
        }
        if (!deleteMails.isEmpty()) {
            mailService.removeMailAll(deleteMails);
        }

        playerContext.write(CmdCode._15004, builder.build());

    }

    /**
     * 使用兑换码
     *
     * @param playerContext
     * @param reqCdk
     */
    @CMD(id = CmdCode._15010)
    public void exchangeCode(PlayerContext playerContext, CodeGMsg.GReqCdk reqCdk) {

        Asserts.isTrue(StringUtils.isNotBlank(reqCdk.getCdk()), ErrorCode.EXCHANGE_CODE_ERROR.getValue()
                , () -> String.format("code is null or empty"));

        Role role = roleService.getOrThrow(playerContext.getId());

        Map<String, Object> params = new HashMap<>();
        params.put("action", "Game.checkCode");
        params.put("role_id", role.getId());
        params.put("code", reqCdk.getCdk());
        PlatformHttpResult result = platformSupport.sendToPlatform(params);

        List<ExchangeCodeResponseData> exchangeCodeResponse = GJsonUtils.fromJson(result.getData(), new TypeToken<List<ExchangeCodeResponseData>>() {
        });

        CodeGMsg.GResCdk.Builder builder = CodeGMsg.GResCdk.newBuilder();
        if (result.getCode() == 200) {
            if (CollectionUtil.isNotEmpty(exchangeCodeResponse)) {
                thingService.add(role.getId(), exchangeCodeResponse.get(0).getGift_item(), GameEvent.EXCHANGE_CODE);
            }
            builder.setIsSuccess(1);
        } else {
            // 转换成对应的消息
            LoginGMsg.GResError.Builder errorBuilder = LoginGMsg.GResError.newBuilder();
            ErrorCode errorCode = ErrorCode.valueOf(result.getCode());
            if (Objects.isNull(errorCode)) {
                errorCode = ErrorCode.EXCHANGE_CODE_ERROR;
            }
            errorBuilder.setError(errorCode.getValue());
            playerContext.write(CmdCode._1005, errorBuilder.build());
            builder.setIsSuccess(-1);
        }
        playerContext.write(CmdCode._15010, builder.build());
    }
}
