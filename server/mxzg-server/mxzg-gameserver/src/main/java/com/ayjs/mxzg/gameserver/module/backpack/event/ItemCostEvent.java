/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.backpack.event;

import java.util.List;
import java.util.Map;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class ItemCostEvent {
	private long rid;
	private List<ImmutableThing> costList;
	private GameEvent gameEvent;
	private Map<Integer, Long> currMap;
}
