package com.ayjs.mxzg.gameserver.module.timeLimitItem.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.TimeLimitItemSysCache;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.CTimeLimitItem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.constant.TimeLimitItemType;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.dao.WeeksCardInfoDao;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.domain.LimitItemInfo;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.domain.WeeksCardInfo;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.event.TimeLimitItemEvent;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.event.WeeksCardEvent;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 周卡道具
 *
 * @author hyx
 */
@Service
@Observer
public class WeeksCardInfoService {

    @Autowired
    private WeeksCardInfoDao weeksCardInfoDao;
    @Autowired
    private TimeLimitItemSysCache timeLimitItemSysCache;
    @Autowired
    private MailService mailService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;

    private List<WeeksCardInfo> selectList(long rid) {
        return weeksCardInfoDao.list("rid", rid);
    }

    private void addList(List<LimitItemInfo> list) {
        List<WeeksCardInfo> weeksCardInfos = new ArrayList<>();
        long rid = list.get(0).getRid();
        for (LimitItemInfo limitItemInfo : list) {
            WeeksCardInfo weeksCardInfo = new WeeksCardInfo();
            weeksCardInfo.setRid(rid);
            weeksCardInfo.setItemType(limitItemInfo.getItemType());
            weeksCardInfo.setEndTime(limitItemInfo.getEndTime());
            weeksCardInfo.setActiveTime(limitItemInfo.getActiveTime());
            weeksCardInfos.add(weeksCardInfo);
        }
        weeksCardInfoDao.add(weeksCardInfos);

        this.sendMail(rid, weeksCardInfos);

        eventBus.post(WeeksCardEvent.of(rid, weeksCardInfos));
    }

    private void deleteList(List<WeeksCardInfo> weeksCardInfoList) {
        weeksCardInfoDao.remove(weeksCardInfoList);
    }

    private void updateList(List<WeeksCardInfo> list) {
        weeksCardInfoDao.update(list);
    }

    private void update(WeeksCardInfo info) {
        weeksCardInfoDao.update(info);
    }

    private void cleanWeeksCard(long rid) {
        List<WeeksCardInfo> list = selectList(rid).stream().filter(weeksCardInfo -> weeksCardInfo.getEndTime() <= DateTimeUtil.currentSecond()).collect(Collectors.toList());

        List<Mail> mailList = new ArrayList<>();

        for (WeeksCardInfo weeksCardInfo : list) {
            CTimeLimitItem cTimeLimitItem = timeLimitItemSysCache.getOrThrow(weeksCardInfo.getItemType());
            if (weeksCardInfo.getRewardCount() < cTimeLimitItem.getValid_time()) {

                int addCount = cTimeLimitItem.getValid_time() - weeksCardInfo.getRewardCount();
                Mail mail = mailService.newMail(rid, MailScene.WEEKS_CARD_REWARD, MailParams.build(getNoteLanguage(cTimeLimitItem.getItem_id())),
                        MailParams.build(getNoteLanguage(cTimeLimitItem.getItem_id())), ImmutableThingUtil.multiplyThing(cTimeLimitItem.getReward(), addCount), GameEvent.WEEKS_CARD_REWARD);
                mailList.add(mail);

            }
        }

        if (!mailList.isEmpty()) {
            mailService.insertMails(mailList);
        }

        deleteList(list);
    }

    @Subscribe
    public void listen(TimeLimitItemEvent event) {

        if (event.getAddItemList() != null) {
            List<LimitItemInfo> list = event.getAddItemList().stream().filter(limitItemInfo ->
                    limitItemInfo.getType() == TimeLimitItemType.WEEKS_CARD.getType()).collect(Collectors.toList());
            if (!list.isEmpty()) {
                this.addList(list);
            }
        }
        if (event.getDelItemList() != null) {
            List<LimitItemInfo> list = event.getDelItemList().stream().filter(limitItemInfo ->
                    limitItemInfo.getType() == TimeLimitItemType.WEEKS_CARD.getType()).collect(Collectors.toList());
            if (!list.isEmpty()) {
                this.cleanWeeksCard(event.getRid());
            }
        }
    }


    private void sendMail(long rid, List<WeeksCardInfo> weeksCardInfos) {
        List<Mail> mailList = new ArrayList<>();
        for (WeeksCardInfo weeksCardInfo : weeksCardInfos) {

            CTimeLimitItem cTimeLimitItem = timeLimitItemSysCache.getOrThrow(weeksCardInfo.getItemType());
            if (weeksCardInfo.getDailyTime() >= DateTimeUtil.dayBreak() ||
                    weeksCardInfo.getRewardCount() >= cTimeLimitItem.getValid_time()) {
                continue;
            }

            weeksCardInfo.setDailyTime(DateTimeUtil.dayBreak());
            weeksCardInfo.setRewardCount(weeksCardInfo.getRewardCount() + 1);

            Mail mail = mailService.newMail(rid, MailScene.WEEKS_CARD_REWARD, MailParams.build(getNoteLanguage(cTimeLimitItem.getItem_id())),
                    MailParams.build(getNoteLanguage(cTimeLimitItem.getItem_id())), cTimeLimitItem.getReward(), GameEvent.WEEKS_CARD_REWARD);

            mailList.add(mail);
        }

        if (!mailList.isEmpty()) {
            mailService.insertMails(mailList);
            this.updateList(weeksCardInfos);
        }

    }

    @Subscribe
    public void listen(ZeroTimeEvent event) {
        List<WeeksCardInfo> cardInfoList = this.selectList(event.getRid());
        this.sendMail(event.getRid(), cardInfoList);
    }

    @Subscribe
    public void listen(LoginEvent event) {

        List<Mail> mailList = new ArrayList<>();
        for (WeeksCardInfo weeksCardInfo : selectList(event.getRid())) {

            CTimeLimitItem cTimeLimitItem = timeLimitItemSysCache.getOrThrow(weeksCardInfo.getItemType());
            if (weeksCardInfo.getDailyTime() >= DateTimeUtil.dayBreak() ||
                    weeksCardInfo.getRewardCount() >= cTimeLimitItem.getValid_time()) {
                continue;
            }

            int day = DateTimeUtil.apartDay(weeksCardInfo.getDailyTime(), DateTimeUtil.currentSecond());
            if (day + weeksCardInfo.getRewardCount() > cTimeLimitItem.getValid_time()) {
                day = cTimeLimitItem.getValid_time() - weeksCardInfo.getRewardCount();
            }

            Mail mail = mailService.newMail(event.getRid(), MailScene.WEEKS_CARD_REWARD, MailParams.build(getNoteLanguage(cTimeLimitItem.getItem_id())),
                    MailParams.build(getNoteLanguage(cTimeLimitItem.getItem_id())), ImmutableThingUtil.multiplyThing(cTimeLimitItem.getReward(), day), GameEvent.WEEKS_CARD_REWARD);
            mailList.add(mail);

            weeksCardInfo.setDailyTime(DateTimeUtil.dayBreak());
            weeksCardInfo.setRewardCount(weeksCardInfo.getRewardCount() + day);

            this.update(weeksCardInfo);

        }

        if (!mailList.isEmpty()) {
            mailService.insertMails(mailList);
        }

    }

    public String getNoteLanguage(int timeLimitItemId){
        String key = "";
        if (timeLimitItemId == 902025){ // 先知周卡
            key = "702025";
        } else if(timeLimitItemId == 902026){ // 召唤周卡
            key = "702026";
        } else if (timeLimitItemId == 902027){ // 精灵周卡
            key = "702027";
        }

        CLanguage cLanguage = languageSysCache.getByKey(key);
        if (Objects.nonNull(cLanguage)){
            return languageHelper.getLanguageBy(cLanguage);
        } else {
            return "";
        }
    }
}
