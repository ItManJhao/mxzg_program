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
 * 精灵删除事件
 */
@Value(staticConstructor = "of")
public class RuneDeleteEvent {
	private List<RuneInfo> runes;
	private GameEvent gameEvent;
}
