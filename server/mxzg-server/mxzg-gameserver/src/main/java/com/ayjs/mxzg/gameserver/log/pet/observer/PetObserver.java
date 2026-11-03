package com.ayjs.mxzg.gameserver.log.pet.observer;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.log.pet.domain.PetLog;
import com.ayjs.mxzg.gameserver.log.pet.domain.PetUpLevelLog;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import com.ayjs.mxzg.gameserver.module.pet.event.PetAddEvent;
import com.ayjs.mxzg.gameserver.module.pet.event.PetDelEvent;
import com.ayjs.mxzg.gameserver.module.pet.event.PetUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.pet.service.PetService;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;


@Observer
public class PetObserver {

    @Autowired
    private PetService petService;
    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void listen(PetDelEvent petDelEvent) {
        for (Pet pet : petDelEvent.getPets()) {
            PetLog petLog = getLog(pet, petDelEvent.getGameEvent(), 0);
            logService.addLog(petLog);
        }
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void listen(PetAddEvent petAddEvent) {
        for (Pet pet : petAddEvent.getPetList()) {
            PetLog petLog = getLog(pet, petAddEvent.getGameEvent(), 1);
            logService.addLog(petLog);
        }
    }

    private PetLog getLog(Pet pet, GameEvent gameEvent, int type) {
        PetLog petLog = logEntityFactory.create(PetLog.class);
        petLog.setRid(pet.getRid());
        petLog.setSys_id(pet.getSysId());
        petLog.setPetLevel(pet.getLevel());
        petLog.setTime(DateTimeUtil.currentSecond());
        petLog.setEvent(gameEvent.getValue());
        petLog.setEventDesc(gameEvent.getRemark());
        petLog.setType(type);
        return petLog;
    }

    @Subscribe
    public void listen(PetUpLevelEvent event) {
        Pet pet = petService.getPet(event.getRid(), event.getPetId());
        if (pet != null) {
            PetUpLevelLog petUpLevelLog = logEntityFactory.create(PetUpLevelLog.class);
            petUpLevelLog.setRid(event.getRid());
            petUpLevelLog.setPetId(pet.getId());
            petUpLevelLog.setNewLevel(pet.getLevel());
            petUpLevelLog.setSysId(pet.getSysId());
            petUpLevelLog.setTime(DateTimeUtil.currentSecond());
            logService.addLog(petUpLevelLog);
        }
    }


}
