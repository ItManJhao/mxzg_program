/**
 *
 */
package com.ayjs.mxzg.gameserver.web.api;

import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.domain.MailSome;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailSomeService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@RestController
@RequestMapping("/mail")
public class MailApi {

    private static Logger log = LoggerFactory.getLogger(MailApi.class);

    @Autowired
    private MailSomeService mailSomeService;
    @Autowired
    private MailService mailService;

    /**
     * /mail/sendSysMail
     * @param type 1全服邮件，2指定玩家的邮件
     * @param title 邮件标题
     * @param content 邮件内容
     * @param roleIds 指定的玩家，[100001,100002,100003,...]
     * @param goods 附件[{"item_type":100001,"item_num":99},{"item_type":100002,"item_num":99},...]
     * @return
     */
    @RequestMapping(value = "/sendSysMail", method = RequestMethod.GET)
    public String sendSysMail(@RequestParam("type") int type, @RequestParam("title") String title,
                              @RequestParam("content") String content, @RequestParam(name = "roleIds", required = false) String roleIds,
                              @RequestParam("goods") String goods) {
        boolean success = mailSomeService.saveNewMail(type, title, content, roleIds, goods);
        if (success) {
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
        } else {
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), ""));
        }
    }

    @RequestMapping(value = "/deleteSysMail", method = RequestMethod.POST)
    public String deleteMail(@RequestParam("mailIds") String mailIds) {
        try {
            List<Long> mailIdList = JsonUtil.getList(mailIds, Long.class);
            List<MailSome> mails = mailSomeService.getAllMail().stream().filter(mail -> mailIdList.contains(mail.getId()))
                    .collect(Collectors.toList());
            if (mails.size() > 0) {
                mailSomeService.deleteList(mails);
            }
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), "删除系统邮件成功"));
        } catch (Exception e) {
            log.error("删除系统邮件失败！", e);
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), "", "删除系统邮件,请求参数：" + mailIds));
        }
    }

    @RequestMapping(value = "/deletePersonalMail", method = RequestMethod.POST)
    public String deletePersonalMail(@RequestParam("mailIds") String mailIds) {
        try {

            List<Long> mailIdList = JsonUtil.getList(mailIds, Long.class);
            List<Mail> mails = new ArrayList<>();
            for (Long mailId : mailIdList) {
                mails.add(mailService.get(mailId));
            }
            mails = mails.stream().filter(mail -> mailIdList.contains(mail.getId())).collect(Collectors.toList());
            if (mails.size() > 0) {
                mailService.removeMailAll(mails);
            }
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), "删除系统邮件成功"));
        } catch (Exception e) {
            log.error("删除系统邮件失败！", e);
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), "", "删除系统邮件，请求参数：" + mailIds));
        }
    }
}
