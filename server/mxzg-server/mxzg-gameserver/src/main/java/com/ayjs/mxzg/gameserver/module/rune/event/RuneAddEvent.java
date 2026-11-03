/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rune.event;

import java.util.List;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.rune.domain.RuneInfo;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class RuneAddEvent {
	private long rid;
	private List<RuneInfo> runes;
	private GameEvent gameEvent;
}
