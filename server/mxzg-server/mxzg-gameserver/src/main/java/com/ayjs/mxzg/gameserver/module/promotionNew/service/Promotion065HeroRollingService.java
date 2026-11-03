/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion065HeroRollingDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion065HeroRolling;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion065HeroRollingConfig;
import com.ayjs.mxzg.template.constant.ErrorCode;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class Promotion065HeroRollingService extends BasePromotionService<Promotion065HeroRolling> {

	@Autowired
	private Promotion065HeroRollingDao promotion065HeroRollingDao;
	@Autowired
	private MailService mailService;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.HERO_ROLLING;
	}

	@Override
	public IRepository<Promotion065HeroRolling> getRepository() {
		return promotion065HeroRollingDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion065HeroRolling promotion, PromotionControl control) {
		promotion.setSummonIndex(0);
		promotion.setHisNum(0);
		promotion.setSummonNum(0);
		promotion.getRewards().clear();
		promotion.setCheatState(0);
		//王严加的需求，在230到250之间做一次作弊
		promotion.setCheatNum(RandomUtil.getRandomInt(230, 250));
	}
	
	/**
     * @param productId
     * @return
     */
    public Promotion065HeroRollingConfig getReward(int idx) {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        Collection<Promotion065HeroRollingConfig> configList = promotionControl.getAllConfig(Promotion065HeroRollingConfig.class);
        
        Promotion065HeroRollingConfig rewardConfig = null;
        for (Promotion065HeroRollingConfig config : configList) {
            if (config.getIdx() == idx) {
            	rewardConfig = config;
                break;
            }
        }
        Asserts.notNull(rewardConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("活动不存在该奖励:{%s}", idx));
        return rewardConfig;
    }

	@Override
	public void handleOnPromotionClear(PromotionControl control) {
        Collection<Promotion065HeroRollingConfig> configList = control.getAllConfig(Promotion065HeroRollingConfig.class);
        if (Objects.isNull(configList) || configList.size() == 0) {
            return;
        }
        log.info("正在发放活动{}的补发邮件", thisPromotionType());
        List<Mail> mailList = new ArrayList<>();
        List<Promotion065HeroRolling> promotion065List = getAllPromotionInfo();
        
        for(Promotion065HeroRolling promotionInfo : promotion065List) {
        	for(Promotion065HeroRollingConfig config : configList) {
        		if(promotionInfo.getHisNum() < config.getTask_count()) {
        			continue;
        		}
        		if(promotionInfo.getRewards().contains(config.getIdx())) {
        			continue;
        		}
        		//TODO 策划配邮件
        		Mail mail = mailService.newMailNoTitle(promotionInfo.getRid(), MailScene.NEW_HERO_ROLLING,
                        null, ImmutableThingUtil.fromJson(config.getBox_reward()), GameEvent.PROMOTION_NHA_MAIL);
                mailList.add(mail);
        	}
        }
        if (!mailList.isEmpty()) {
        	mailService.insertMails(mailList);
        }
	}
}
