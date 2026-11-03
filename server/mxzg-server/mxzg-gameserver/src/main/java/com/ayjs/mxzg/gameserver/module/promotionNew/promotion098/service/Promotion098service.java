package com.ayjs.mxzg.gameserver.module.promotionNew.promotion098.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion098.dao.Promotion098Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion098.domain.Promotion098;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion098ActiveJumpConfig;
import com.ayjs.mxzg.protocol.Promotion098GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
public class Promotion098service extends BasePromotionService<Promotion098> {

    @Autowired
    private Promotion098Dao promotion098Dao;
    @Autowired
    private RoleService roleService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ACTIVE_JUMP;
    }

    @Override
    public IRepository<Promotion098> getRepository() {
        return promotion098Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion098 promotion, PromotionControl control) {
    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public List<Promotion098ActiveJumpConfig> getAllConfigInfo() {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        return new ArrayList<>(control.getAllConfig(Promotion098ActiveJumpConfig.class));
    }

    public List<Promotion098GMsg.ActiveItemInfo> getPbDataByPlace(long rid, String place) {
        List<Promotion098GMsg.ActiveItemInfo> list = new ArrayList<>();
        if (Objects.isNull(place)) return list;
        Role role = roleService.getOrThrow(rid);
        int serverId = role.getServerId();
        String name = role.getNick();
        getAllConfigInfo().stream().filter(activityItem -> place.equals(activityItem.getCanal()) && activityItem.getState() == 1).forEach(activityItem -> {
            Promotion098GMsg.ActiveItemInfo.Builder item = Promotion098GMsg.ActiveItemInfo.newBuilder();
            item.setActiveId(activityItem.getIdx());
            item.setState(activityItem.getState());
            item.setUrl(activityItem.getUrl() + "?serverId=" + serverId + "&roleId=" + rid + "&name=" + name);
            list.add(item.build());
        });
        return list;
    }
}
