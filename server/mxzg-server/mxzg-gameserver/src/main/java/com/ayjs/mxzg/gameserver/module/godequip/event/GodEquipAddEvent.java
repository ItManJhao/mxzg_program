/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.godequip.event;

import java.util.List;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class GodEquipAddEvent {
	private List<GodEquip> equips;
	private GameEvent gameEvent;
}
