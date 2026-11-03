package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion068SpaceTimeTreasureDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion068SpaceTimeTreasure;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion068SpacetimeTreasureConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author hyx
 */
@Observer
@Service
public class Promotion068SpaceTimeTreasureService extends BasePromotionService<Promotion068SpaceTimeTreasure> {

    @Autowired
    private Promotion068SpaceTimeTreasureDao promotion068SpaceTimeTreasureDao;
    @Autowired
    private MailService mailService;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.SHI_KONG_YI_DAO;
    }

    @Override
    public IRepository<Promotion068SpaceTimeTreasure> getRepository() {
        return promotion068SpaceTimeTreasureDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion068SpaceTimeTreasure promotion, PromotionControl control) {
        promotion.setChooseTime(0);
        promotion.getIdxList().clear();
    }

    public List<Promotion068SpacetimeTreasureConfig> getConfigList() {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        Collection<Promotion068SpacetimeTreasureConfig> configs = control.getAllConfig(Promotion068SpacetimeTreasureConfig.class);
        return new ArrayList<>(configs);
    }

    public Map<Integer, Promotion068SpacetimeTreasureConfig> getConfigMap() {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        Collection<Promotion068SpacetimeTreasureConfig> configs = control.getAllConfig(Promotion068SpacetimeTreasureConfig.class);

        int day = getDay();

        Map<Integer, Promotion068SpacetimeTreasureConfig> map = new HashMap<>();
        configs.stream().filter(config -> config.getDay() == day).forEach(config -> {
            map.put(config.getIdx(), config);
        });
        return map;
    }


    public int getDay() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return DateTimeUtil.apartDay(DateTimeUtil.theDayBreak(promotionControl.getStartTime()), DateTimeUtil.dayBreak()) + 1;
    }

    public void update(Promotion068SpaceTimeTreasure promotion) {
        getRepository().update(promotion);
    }

    @Override
    public Promotion068SpaceTimeTreasure getPromotionInfo(long rid) {
        Promotion068SpaceTimeTreasure promotion = super.getPromotionInfo(rid);
        if (promotion.getChooseTime() > 0 && promotion.getChooseTime() < DateTimeUtil.dayBreak() && !promotion.getIdxList().isEmpty()) {

            List<ImmutableThing> rewardList = new ArrayList<>();
            for (Promotion068SpacetimeTreasureConfig config : getConfigList()) {
                if (promotion.getIdxList().contains(config.getId())) {
                    rewardList.addAll(config.getRewardThings());
                }
            }

            Mail mail = mailService.newMailNoTitle(rid, MailScene.SPACE_TIME_TREASURE, null, rewardList,
                    GameEvent.PROMOTION_SPACE_TIME_TREASURE_REWARD);
            mailService.insert(mail);

            promotion.setChooseTime(0);
            promotion.getIdxList().clear();
            this.update(promotion);
        }
        return promotion;
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        for (Promotion068SpaceTimeTreasure promotion : getRepository().listAll()) {
            this.getPromotionInfo(promotion.getRid());
        }
    }
}
