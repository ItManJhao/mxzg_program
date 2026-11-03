/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.timer;

import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class PromotionControlTimer extends AbstractCronTask {

    @Autowired
    private PromotionControlService promotionControlService;

    @Override
    public Object identity() {
        return "PromotionControlTimer";
    }

    @Override
    public String expression() {
        return "0/2 * * * * ?";
    }

    @Override
    public void run() {
        promotionControlService.runForPromotion();
    }
}
