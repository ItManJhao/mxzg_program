package com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage;

import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeGroupRegistrationDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeSystemDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeGroupRegistration;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeSystem;
import com.ayjs.mxzg.cross.module.crusadegroup.group.manager.CrusadeGroupDataManager;
import com.ayjs.mxzg.cross.module.crusadegroup.map.dao.CrossCrusadersDao;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.CrossCrusaders;
import com.ayjs.mxzg.message.module.crusadegroup.group.StartBattleMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 开始战斗
 */
@Slf4j
@Component
public class StartBattleHandler implements CrusadeStageHandler {

    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrossCrusadersDao crossCrusadersDao;
    @Autowired
    private CrusadeGroupRegistrationDao crusadeGroupRegistrationDao;
    @Autowired
    private CrusadeGroupDataManager crusadeGroupDataManager;
    @Autowired
    private CrusadeSystemDao crusadeSystemDao;

    @Override
    public CrusadeGroupStage getStage() {
        return CrusadeGroupStage.START_BATTLE;
    }

    @Override
    public void handle(CCrusadeGroupCycle startCycle) {
        log.info("准备开启讨伐团战斗");
        log.info("开始生成领地元素类型");
        crusadeGroupDataManager.generateElement();
        crusadeGroupDataManager.generateNpc();
        crusadeGroupDataManager.generateBirthplace();
        crusadeGroupDataManager.loadData();

        CrusadeSystem crusadeSystem = crusadeSystemDao.get();

        log.info("开始推送讨伐团开战信息到游戏服");
        List<CrusadeGroupRegistration> allRegistration = crusadeGroupRegistrationDao.listAll();
        for (CrusadeGroupRegistration registration : allRegistration) {
            Map<Long, Territory> birthplace = new HashMap<>();
            for (Long member : registration.getMembers().keySet()) {
                CrossCrusaders crossCrusaders = crossCrusadersDao.getOrCreate(member);
                if (crossCrusaders.getBirthplace_id() == 0) {
                    continue;
                }
                int element = crusadeSystem.getElement(crossCrusaders.getBirthplace_id());
                Territory territory = Territory.valueOf(crossCrusaders.getBirthplace_id(), member, element, 0);
                birthplace.put(member, territory);
            }
            messageHelper.pushToMessage(StartBattleMessage.valueOf(registration.getId(), birthplace));
            log.info("推送开团消息到分区{}总共{}个讨伐者", registration.getId(), birthplace.size());
        }
    }

}
