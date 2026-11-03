/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseRankablePormotion;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
public abstract class BaseRankablePromotionService<T extends BaseRankablePormotion> extends BasePromotionService<T> {

    @Autowired
    protected EventBus eventBus;
    @Autowired
    protected MailService mailService;

    protected abstract AbstractRankService<?> thisRankService();

    @Override
    public void handleOnPromotionNewTurns(PromotionControl control) {
        thisRankService().clear();
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
    	log.info("正在进行活动{}的结算处理", thisPromotionType());
        List<Mail> mailList = new ArrayList<>();
        
        for (T promotionInfo : getAllPromotionInfo()) {
        	try {
        		//没有参与本轮活动的跳过
                if (promotionInfo.getTurns() != control.getTurns() || promotionInfo.getTurnsTime() != control.getTurnsTime()
                        || promotionInfo.getRankCount() == 0) {
                    continue;
                }
                int rank = thisRankService().getRank(promotionInfo.getRid());

                Mail mail = createPromotionRankMail(promotionInfo, rank);
                if (mail != null) {
                    mailList.add(mail);
                }
			} catch (Exception e) {
				e.printStackTrace();
			}
        }
        if (!mailList.isEmpty()) {
            mailService.insertMails(mailList);
        }
        log.info("正在进行活动{}的结算处理，发放邮件{}封", thisPromotionType(), mailList.size());
    }

    protected abstract Mail createPromotionRankMail(T promotionInfo, int rank);
}
