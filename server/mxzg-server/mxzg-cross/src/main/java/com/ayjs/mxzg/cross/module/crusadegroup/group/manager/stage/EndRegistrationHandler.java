package com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage;

import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.SessionManager;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrossCrusadeGroupDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeGroupRegistrationDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeSystemDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrossCrusadeGroup;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeGroupRegistration;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeSystem;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.ServerInfo;
import com.ayjs.mxzg.cross.module.crusadegroup.map.dao.CrossCrusadeGroupMapDao;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.CrossCrusadeGroupMap;
import com.ayjs.mxzg.message.module.crusadegroup.group.EndRegistrationMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.UpdateGroupMessage;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Slf4j
@Component
public class EndRegistrationHandler implements CrusadeStageHandler {

    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private CrusadeSystemDao crusadeSystemDao;
    @Autowired
    private CrossCrusadeGroupDao crossCrusadeGroupDao;
    @Autowired
    private CrossCrusadeGroupMapDao crossCrusadeGroupMapDao;
    @Autowired
    private CrusadeGroupRegistrationDao crusadeGroupRegistrationDao;

    private AtomicInteger idGenerator = new AtomicInteger(1);
    private AtomicInteger mapIdGenerator = new AtomicInteger(1);

    @Override
    public CrusadeGroupStage getStage() {
        return CrusadeGroupStage.END_REGISTRATION;
    }

    @Override
    public void handle(CCrusadeGroupCycle startCycle) {
        log.info("报名结束准备开始分组");
        regroup();
        setPosition();
        pushGroupInfo();
    }

    /**
     * 讨伐团开始重新分组
     */
    private void regroup(){
        crossCrusadeGroupDao.truncateAll();
        crossCrusadeGroupMapDao.truncateAll();

        List<CrusadeGroupRegistration> registrations = crusadeGroupRegistrationDao.listAll();

        log.info("跨服服务器数量:{}", registrations.size());

        Collections.shuffle(registrations);

        List<CrossCrusadeGroup> groups = new ArrayList<>();
        while(!registrations.isEmpty()) {
            List<ServerInfo> groupServers = new ArrayList<>();
            int activeNum = 0;
            while (!registrations.isEmpty() && activeNum < CrusadeGroupConst.GROUP_LOWER_LIMIT) {
                CrusadeGroupRegistration registration = registrations.get(0);
                groupServers.add(ServerInfo.of(registration.getId(), registration.getMembers().keySet()));
                registrations.remove(registration);
                activeNum = groupServers.stream().mapToInt(ServerInfo::getEntriesNumber).sum();
            }
            CrossCrusadeGroup crossCrusadeGroup = CrossCrusadeGroup.createOf(idGenerator.getAndIncrement(), groupServers);
            crossCrusadeGroupDao.add(crossCrusadeGroup);
            groups.add(crossCrusadeGroup);
        }

        log.info("讨伐团分组:{}", groups.size());

        while(groups.size() >= 2){
            CrossCrusadeGroup liftGroup = groups.get(0);
            CrossCrusadeGroup rightGroup = groups.get(1);
            CrossCrusadeGroupMap map = CrossCrusadeGroupMap.createOf(this.mapIdGenerator.getAndIncrement(), liftGroup, rightGroup);
            crossCrusadeGroupMapDao.add(map);
            groups.remove(liftGroup);
            groups.remove(rightGroup);
            liftGroup.setMapId(map.getId());
            rightGroup.setMapId(map.getId());
            crossCrusadeGroupDao.update(liftGroup);
            crossCrusadeGroupDao.update(rightGroup);
        }

        log.info("讨伐团分组完毕后轮空:{}", groups.size());
        if(!groups.isEmpty()){
            CrossCrusadeGroup liftGroup = groups.get(0);
            CrossCrusadeGroupMap map = CrossCrusadeGroupMap.createOf(this.mapIdGenerator.getAndIncrement(), liftGroup, null);
            crossCrusadeGroupMapDao.add(map);
            groups.remove(liftGroup);
            liftGroup.setMapId(map.getId());
            crossCrusadeGroupDao.update(liftGroup);
        }

        log.info("讨伐团地图分组:{}", this.mapIdGenerator.get());

        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        crusadeSystem.setRegroup(true);
        crusadeSystem.setLastRegroupTime(LocalDateTime.now());
        crusadeSystemDao.update(crusadeSystem);
        log.info("讨伐团分组完毕");
    }

    /**
     * 设置职位相关信息
     */
    public void setPosition(){
        log.info("设置讨伐团职位信息");
        List<CrossCrusadeGroup> groups = crossCrusadeGroupDao.listAll();
        Comparator<CrossRole> comparator = (r1, r2) -> Integer.compare(r2.getMaxFighting(), r1.getMaxFighting());
        for (CrossCrusadeGroup group : groups) {
            List<CrossRole> roles = group.getMembers().stream().map(crossRoleService::getOrThrow).filter(crossRole -> crossRole.getClanId() != 0).sorted(comparator).collect(Collectors.toList());
            CrossRole head = roles.get(0);
            int roleServerId = sessionManager.getRealServerId(head.getServerId());
            CrusadeGroupRegistration crusadeGroupRegistration = crusadeGroupRegistrationDao.get(roleServerId);
            int emblem = crusadeGroupRegistration == null ? 1 : crusadeGroupRegistration.getEmblem(head.getId());
            group.setHead(head.getId(), emblem, head.getClanName());
            Set<Long> commanderIds = new HashSet<>();
            int num = Math.min(roles.size() - 1, CrusadeGroupConst.CRUSADE_GROUP_COMMANDER);
            for(int index = 1; index <= num; index ++){
                commanderIds.add(roles.get(index).getId());
            }
            group.setCommander(commanderIds);
            crossCrusadeGroupDao.update(group);
        }
    }

    /**
     * 推送討伐團信息
     */
    public void pushGroupInfo() {
        log.info("推送讨伐团报名结束");
        messageHelper.pushToAll(EndRegistrationMessage.getInstance());
        log.info("推送讨伐团职位信息");
        List<CrossCrusadeGroup> groups = crossCrusadeGroupDao.listAll();
        for (CrossCrusadeGroup group : groups) {
            messageHelper.pushToServers(UpdateGroupMessage.valueOf(group.getHeadId(), group.getCommander()), group.getServer_id());
        }
    }
}
