/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class RoleExpProcessor implements ThingProcessor {

	@Autowired
	private RoleService roleService;
	
	@Override
	public ThingType thingType() {
		return ThingType.ROLE_EXP;
	}

	@Override
    public long getCount(long rid, int thingType) {
        return getCount(rid);
    }

    private long getCount(long rid) {
        Role role = roleService.getOrThrow(rid);
        return role.getExp();
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long totalExp = combine(thingSet);
        roleService.addExp(rid, totalExp, gameEvent);
        return Rewards.of(thingSet);
	}

	@Override
    public ThingSet prepareCost(long rid, ThingSet costList, GameEvent gameEvent) {
		throw new UnsupportedOperationException("不能扣除角色经验");
	}

	@Override
    public void cost(long rid, ThingSet costList, GameEvent gameEvent) {
		throw new UnsupportedOperationException("不能扣除角色经验");
	}

	@Override
    public ErrorCode notEnoughCode() {
		throw new UnsupportedOperationException("不能扣除角色经验");
	}

}
