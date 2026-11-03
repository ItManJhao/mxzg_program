package com.ayjs.mxzg.gameserver.module.mail.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.CrossServerNameSysCache;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.MailSysCache;
import com.ayjs.mxzg.config.excel.cache.RainbowSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.CMail;
import com.ayjs.mxzg.config.excel.entity.CRainbow;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.hero.struct.SummonType;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.dao.MailDao;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.event.MailDeleteEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.MailGMsg.GResMailList;
import com.ayjs.mxzg.protocol.MailGMsg.GResNewMail;
import com.ayjs.mxzg.protocol.MailGMsg.ResMailData;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class MailService {

    @Autowired
    private MailDao mailDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private MailSysCache mailSysCache;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ClanService clanService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CrossServerNameSysCache crossServerNameSysCache;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private RainbowSysCache rainbowSysCache;


    /**
     * 查询玩家所有邮件
     *
     * @param rid
     * @return
     */
    public List<Mail> getAll(long rid) {
        return mailDao.list("rid", rid);
    }

    /***
     * 根据邮件id获取mailId
     * @param mailId
     * @return
     */
    public Mail get(long mailId) {
        return mailDao.get(mailId);
    }

    /**
     * 查询玩家单个邮件
     *
     * @param rid
     * @param id
     * @return
     */
    public Mail get(long rid, long id) {
        Mail mail = null;
        List<Mail> list = getAll(rid);
        for (Mail model : list) {
            if (id == model.getId()) {
                mail = model;
            }
        }
        return mail;
    }

    /**
     * 查询未领取邮件
     *
     * @param rid
     * @return
     */
    public List<Mail> getNotReceiveMail(long rid) {
        List<Mail> list = getAll(rid);
        List<Mail> list2 = new ArrayList<>();
        for (Mail mail : list) {
            if (mail.getIsReceive() == 0) {
                list2.add(mail);
            }
        }
        return list2;
    }

    /**
     * 更新邮件
     *
     * @param mail
     */
    public void updateMail(Mail mail) {
        mailDao.update(mail);
    }

    /**
     * 批量更新邮件
     *
     * @param mail
     */
    public void updateMailAll(List<Mail> mail) {
        mailDao.update(mail);
    }

    /**
     * 删除邮件
     *
     * @param mail
     */
    public void removeMail(Mail mail) {
        mailDao.remove(mail);
        eventBus.post(MailDeleteEvent.of(Collections.singletonList(mail)));
    }

    /**
     * 删除已读已领取邮件
     */
    public void removeMailAll(List<Mail> list) {
        mailDao.remove(list);
        eventBus.post(MailDeleteEvent.of(list));
    }

    public void insertMails(List<Mail> list) {
        List<Mail> sendMails = new ArrayList<>();
        List<Mail> refuseMails = new ArrayList<>();

        int nowTime = TimeDateUtil.getCurrentTimeInt();
        int unsendTime = nowTime - systemSysCache.getMailRefuseLossDay() * TimeDateUtil.ONEDAYINT;

        for (Mail mail : list) {
            Role role = roleService.getOrThrow(mail.getRid());
            //最后登录时间或最后离线时间在14天内才进行邮件发送
            if (role.getLastOfflineTime() / 1000 > unsendTime
                    || role.getLastLoginTime() / 1000 > unsendTime) {
                sendMails.add(mail);
            } else {
                mail.setRefuse(1);
                refuseMails.add(mail);
            }
        }
        if (!sendMails.isEmpty()) {
            mailDao.add(sendMails);
            Set<Long> rids = new HashSet<>();
            for (Mail mail : sendMails) {
                rids.add(mail.getRid());
            }
            contextManager.writeSome(rids, CmdCode._15002, GResNewMail.getDefaultInstance());
        }
        if (!refuseMails.isEmpty()) {
            //记录因离线太久而没有发送的邮件
            System.out.println("refuse");
            eventBus.post(MailDeleteEvent.of(refuseMails));
        }
    }

    public void insert(Mail mail) {
        insertMails(Collections.singletonList(mail));
    }

    public void insertMailsSilent(List<Mail> list) {
        mailDao.add(list);
    }

    /**
     * 发送没有标题参数的邮件
     *
     * @param rid
     * @param mailScene
     * @param content
     * @param rewards
     * @param gameEvent
     * @return
     */
    public Mail newMailNoTitle(long rid, MailScene mailScene, Object[] content, List<ImmutableThing> rewards,
                               GameEvent gameEvent) {
        return newMail(rid, mailScene, null, content, rewards, gameEvent);
    }

    /**
     * 发送没有标题参数、没有内容参数的邮件
     *
     * @param rid
     * @param mailScene
     * @param rewards
     * @param gameEvent
     * @return
     */
    public Mail newSimpleMail(long rid, MailScene mailScene, List<ImmutableThing> rewards, GameEvent gameEvent) {
        return newMail(rid, mailScene, null, null, rewards, gameEvent);
    }

    /**
     * @param rid
     * @param mailScene 邮件发送的场景，邮件配置表的ID
     * @param title     标题的参数
     * @param content   内容的参数
     * @param rewards   附件奖励
     * @param gameEvent 邮件发出时的游戏事件
     * @return
     */
    public Mail newMail(long rid, MailScene mailScene, Object[] title, Object[] content, List<ImmutableThing> rewards,
                        GameEvent gameEvent) {
        Mail mail = new Mail();
        mail.setRid(rid);
        mail.setSceneId(mailScene.getId());
        mail.setTime(TimeDateUtil.getCurrentTimeInt());
        mail.setIsRead(0);
        mail.setIsReceive(0);
        mail.setGameEvent(gameEvent.getValue());
        if (title != null) {
            for (Object param : title) {
                mail.getTitleParam().add(param.toString());
            }
        }
        if (content != null) {
            for (Object param : content) {
                mail.getContentParam().add(param.toString());
            }
        }
        CMail cmail = mailSysCache.getOrThrow(mailScene.getId());
        if (cmail != null) {
            mail.setTitle(formatParamStr(cmail.getTitle_lang(), cmail.getTitle_param(), mail.getTitleParam()));
            mail.setContent(formatParamStr(cmail.getContent_lang(), cmail.getContent_param(), mail.getContentParam()));
        } else {
            mail.setTitle("");
            mail.setContent("");
        }
        if (rewards != null) {
            mail.setGoods(GsonUtils.toJson(rewards));
        } else {
            mail.setGoods("");
        }
        return mail;
    }

    public String formatParamStr(String languageKey, int[] paramPattern, List<String> params) {
        CLanguage language = languageSysCache.getByKey(languageKey);
        if (language == null) {
            return "";
        }
        if (paramPattern == null || params == null) {
            return languageHelper.getLanguageBy(language);
        }
        String str = languageHelper.getLanguageBy(language);
        for (int i = 0; i < paramPattern.length && i < params.size(); i++) {
            String param = params.get(i);
            int pattern = paramPattern[i];
            //参数填充位从1开始
            str = str.replace("[" + (i + 1) + "]", formatParam(pattern, param));
        }
        return str;
    }

    private String formatParam(int pattern, String param) {
        if (pattern == 0 || pattern == 1) {
            //字符串、数字类型的处理
            return param;
        } else if (pattern == 2) {
            //秒数转日期字符串的处理，一个转化例子
            return TimeDateUtil.time2String(Integer.parseInt(param) * 1000l);
        } else if (pattern == 3) {
            //英雄类型转英雄名字
            int heroType = Integer.parseInt(param);
            CItem cItem = itemSysCache.getOrThrow(heroType);
            CLanguage cLanguage = languageSysCache.getByKey(cItem.getName());
            return languageHelper.getLanguageBy(cLanguage);
        } else if (pattern == 4) {
            //玩家ID转玩家昵称
            long rid = Long.parseLong(param);
            return roleService.getOrThrow(rid).getNick();
        } else if (pattern == 5) {
            //公会ID转公会名
            long clanId = Long.parseLong(param);
            return clanService.getOrThrow(clanId).getClanName();
        } else if (pattern == 6) {
            int type = Integer.parseInt(param);
            SummonType summonType = SummonType.valueOf(type);
            CLanguage cLanguage = languageSysCache.getByKey(summonType.getLangKey());
            return languageHelper.getLanguageBy(cLanguage);
        } else if (pattern == 7) {
            return TimeDateUtil.time2String(Integer.parseInt(param) * 1000l, TimeDateUtil.FORMAT_HHMM);
//        } else if (pattern == 8) {
//            //服务器长ID转短ID
//            int diff = crossServerNameSysCache.getByPlatform(serverConfig.getServerPlatformId(), serverConfig.getServerPlatformSonId());
//            int serverId = Integer.parseInt(param) - diff;
//            return serverId + "";
        } else if (pattern == 9) {
            //英雄类型转英雄名字
            int heroType = Integer.parseInt(param);
            CItem cItem = itemSysCache.getOrThrow(heroType);
            CLanguage cLanguage = languageSysCache.getByKey(cItem.getName());
            return languageHelper.getLanguageBy(cLanguage);
        } else if (pattern == 10) {
            int type = Integer.parseInt(param);
            CRainbow cRainbow = rainbowSysCache.getOrThrow(type);
            CLanguage cLanguage = languageSysCache.getByKey(cRainbow.getName_lang());
            return languageHelper.getLanguageBy(cLanguage);
        } else if (pattern == 11) {
            CLanguage cLanguage = languageSysCache.getByKey(param);
            return languageHelper.getLanguageBy(cLanguage);
        } else {
            //默认都是当字符串处理
            return param;
        }
    }


    /**
     * 请求邮件列表
     *
     * @param rid
     */
    public void getMailList(long rid) {
        GResMailList.Builder builder = GResMailList.newBuilder();
        for (Mail mail : getAll(rid)) {
            builder.addList(serializeMail(mail));
        }
        contextManager.write(rid, CmdCode._15000, builder.build());
    }

    public ResMailData serializeMail(Mail mail) {
        ResMailData.Builder builder = ResMailData.newBuilder();
        builder.setMailId(mail.getId());
        builder.setIsRead(mail.getIsRead());
        builder.setIsReceive(mail.getIsReceive());
        builder.setTime(mail.getTime());
        builder.setStrTitle(mail.getTitle());
        builder.setStrContent(mail.getContent());
        ImmutableList<ImmutableThing> rewards = ImmutableThingUtil.fromJson(mail.getGoods());
        if (rewards != null) {
            builder.addAllVecReward(PbUtil.buildReward(rewards));
        }
        return builder.build();
    }


//	public void platform()

}
