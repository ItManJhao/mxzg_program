/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion049RechargeDaysSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion049RechargeDays;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion049RechargeDaysDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion049RechargeDays;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.RechargeDays;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;

/**
 * @author YY
 *
 */
@Observer
@Service
public class Promotion049RechargeDaysService {

	@Autowired
	private Promotion049RechargeDaysDao promotion049RechargeDaysDao;
	@Autowired
	private Promotion049RechargeDaysSysCache promotion049RechargeDaysSysCache;
	@Autowired
	private SystemSysCache systemSysCache;
	@Autowired
	private MailService mailService;
	
	public Promotion049RechargeDays getPromotionInfo(long rid) {
		Promotion049RechargeDays info = promotion049RechargeDaysDao.get(rid);
		if(info == null) {
			info = new Promotion049RechargeDays();
			info.setRid(rid);
			info.setCurrDay(1);
			info.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			info.setDaysMap(new HashMap<>());
			promotion049RechargeDaysDao.add(info);
		}
		if(TimeDateUtil.getCurrentTimeInt() >= info.getDailyTime()) {
			info.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			RechargeDays rechargeDays = info.getDaysMap().get(info.getCurrDay());
			if(rechargeDays != null) {
				//前一天的充值金额不足，则删除前一天的充值数量
				if(rechargeDays.getMoney() < systemSysCache.getRechargeDaysAtLeastRmb()) {
					info.getDaysMap().remove(info.getCurrDay());
				} else {
					info.setCurrDay(info.getCurrDay() + 1);
				}
			}
			promotion049RechargeDaysDao.update(info);
		}
		return info;
	}
	
	public void update(Promotion049RechargeDays info) {
		promotion049RechargeDaysDao.update(info);
	}
	
	
	@Subscribe
	public void onEvent(RechargeEvent event) {
		Promotion049RechargeDays info = getPromotionInfo(event.getRid());
		//info.getCurrDay会记录到配置表之外的天数
		if(info.getCurrDay() > promotion049RechargeDaysSysCache.getAll().size()) {
			checkSendPromotionReward(info);
			//重置活动
			info.setCurrDay(1);
			info.getDaysMap().clear();
		}
		CPromotion049RechargeDays cRechargeDays = promotion049RechargeDaysSysCache.getOrThrow(info.getCurrDay());
		if(cRechargeDays != null) {
			RechargeDays rechargeDays = info.getDaysMap().get(info.getCurrDay());
			if(rechargeDays == null) {
				rechargeDays = new RechargeDays();
				rechargeDays.setDay(info.getCurrDay());
				rechargeDays.setHasReward(0);
				rechargeDays.setMoney(0);
				info.getDaysMap().put(rechargeDays.getDay(), rechargeDays);
			}
			rechargeDays.setMoney(rechargeDays.getMoney() + event.getMoney());
		}
		update(info);
	}
	
	
	@Subscribe
    private void listen(LoginEvent event) {
		Promotion049RechargeDays promotionInfo = getPromotionInfo(event.getRid());
		checkSendPromotionReward(promotionInfo);
		
		//活动记录天数大于配置最大天数，则重置活动
        if(promotionInfo.getCurrDay() > promotion049RechargeDaysSysCache.getAll().size()) {
        	promotionInfo.setCurrDay(1);
        	promotionInfo.getDaysMap().clear();
        	this.update(promotionInfo);
        }
    }
	
	/**
	 * 检查是否需要发送活动奖励
	 * @param promotionInfo
	 */
	private void checkSendPromotionReward(Promotion049RechargeDays promotionInfo) {
		List<Mail> mails = new ArrayList<>();
		for(RechargeDays rechargeDays : promotionInfo.getDaysMap().values()) {
			if(rechargeDays.getHasReward() == 0 && promotionInfo.getCurrDay() > rechargeDays.getDay()) {
				rechargeDays.setHasReward(1);
				
				CPromotion049RechargeDays cRechargeDays = promotion049RechargeDaysSysCache.getOrThrow(rechargeDays.getDay());
				
				Mail mail = mailService.newSimpleMail(promotionInfo.getRid(), MailScene.JI_TIAN_HAO_LI, cRechargeDays.getItem(),
						GameEvent.RECHARGE_DAYS_AUTO_REWARD);
				mails.add(mail);
			}
		}
		if(!mails.isEmpty()) {
			this.update(promotionInfo);
			mailService.insertMails(mails);
		}
	}
}
