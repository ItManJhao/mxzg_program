/**
 *
 */
package com.ayjs.mxzg.gameserver.module.mail.service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.log.mail.observer.MailLogObserver;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.dao.MailSomeDao;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.domain.MailSome;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import com.ayjs.mxzg.gameserver.module.role.service.RoleParamService;
import com.ayjs.mxzg.protocol.MailGMsg.GResNewMail;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;


/**
 * @author YY
 *
 */
@Service
@Slf4j
public class MailSomeService implements Lifecycle {

    @Autowired
    private MailSomeDao mailSomeDao;
    @Autowired
    private RoleParamService roleParamService;
    @Autowired
    private MailService mailService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private MailLogObserver mailLogObserver;

    public List<MailSome> getAllMail() {
        return mailSomeDao.listAll();
    }

    public void deleteList(List<MailSome> deleteList) {
        mailSomeDao.remove(deleteList);
    }

    /**
     * 检查玩家是否有未拉取的系统邮件
     * @param rid
     */
    public void checkUnTakeMail(long rid) {
        List<MailSome> someList = getAllMail();
        //如果在玩家创号之前有补偿邮件，则对新创号的玩家不进行发放
        RoleParam roleParam = roleParamService.getOrCreate(rid, RoleParamType.MAIL_LAST_TIME, () -> {
            long maxExpireTime = 0;
            for (MailSome mailSome : someList) {
                if (mailSome.getExpireTime() > maxExpireTime) {
                    maxExpireTime = mailSome.getExpireTime();
                }
            }
            return maxExpireTime;
        });
        long lastTime = roleParam.parseJson(Long.class);

        List<Mail> mailList = new ArrayList<>();

        long newLastTime = 0;

        for (MailSome mailSome : someList) {
            if (mailSome.getExpireTime() <= lastTime) {
                continue;
            }

            if (mailSome.getType() == 1) {
                //全服邮件
            } else if (mailSome.getType() == 2 && mailSome.getRoleIds().contains(rid)) {
                //指定玩家的邮件
            } else {
                continue;
            }

            ImmutableList<ImmutableThing> rewardList = null;
            if (mailSome.getGoods() != null && !"".equals(mailSome.getGoods())) {
                rewardList = ImmutableThingUtil.fromJson(mailSome.getGoods());
            }
            Mail mail = mailService.newMail(rid, MailScene.SYS_MAIL, MailParams.build(mailSome.getTitle()),
                    MailParams.build(mailSome.getContent()), rewardList, GameEvent.MAIL_FROM_SYS);
            mailList.add(mail);

            if (mailSome.getExpireTime() > newLastTime) {
                newLastTime = mailSome.getExpireTime();
            }
        }
        if (!mailList.isEmpty()) {
            roleParam.saveJson(newLastTime);
            roleParamService.update(roleParam);
            mailService.insertMailsSilent(mailList);
        }
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.LOW, Ordinal._48, "MailSomeService");
    }

    @Override
    public void start() throws Exception {
        List<MailSome> someList = getAllMail();
        //开服的时候删除已经过期的系统邮件
        long nowTime = TimeDateUtil.getCurrentTime();
        List<MailSome> deleteList = new ArrayList<>();
        for (MailSome mail : someList) {
            if (mail.getExpireTime() <= nowTime) {
                deleteList.add(mail);
            }
        }
        if (!deleteList.isEmpty()) {
            mailSomeDao.remove(deleteList);
            //将删除掉的系统邮件保存在日志表中
            mailLogObserver.deleteMailSome(deleteList);
        }
    }

    /**
     * @param type 邮件类型
     * @param title 邮件标题
     * @param content 邮件内容
     * @param roleIds 发送给的指定玩家
     * @param goods 附件
     */
    public boolean saveNewMail(int type, String title, String content, String roleIds, String goods) {
        try {
            //验证后台传过来的goods内容是否可以转化为奖励列表，如果无法转化，这里会抛出异常
            ImmutableThingUtil.fromJson(goods);

            MailSome mailSome = new MailSome();
            mailSome.setType(type);
            mailSome.setTitle(title);
            mailSome.setContent(content);
            mailSome.setCreateTime(TimeDateUtil.getCurrentTime());
            //TODO
            mailSome.setExpireTime(mailSome.getCreateTime() + 10 * TimeDateUtil.ONEDAY);
            mailSome.setRoleIds(new HashSet<>());
            List<Long> rids = JsonUtil.getList(roleIds, Long.class);
            mailSome.getRoleIds().addAll(rids);
            mailSome.setGoods(goods);
            mailSomeDao.add(mailSome);

            //给在线的玩家推送新邮件
            if (mailSome.getType() == 1) {
                //全服邮件
                contextManager.writeAll(CmdCode._15002, GResNewMail.getDefaultInstance());
            } else if (mailSome.getType() == 2) {
                //指定玩家的邮件
                contextManager.writeSome(mailSome.getRoleIds(), CmdCode._15002, GResNewMail.getDefaultInstance());
            }
            return true;
        } catch (Exception e) {
            log.error("邮件发送失败", e);
            return false;
        }
    }


}
