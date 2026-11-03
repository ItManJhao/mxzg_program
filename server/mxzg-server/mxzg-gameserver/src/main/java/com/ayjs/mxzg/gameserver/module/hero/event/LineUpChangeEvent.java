/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;

import lombok.Value;

/**
 * @author YY
 * 布阵发生变化时抛出的事件
 */
@Value(staticConstructor = "of")
public class LineUpChangeEvent {
	private HeroLineUp heroLineUp;
}
