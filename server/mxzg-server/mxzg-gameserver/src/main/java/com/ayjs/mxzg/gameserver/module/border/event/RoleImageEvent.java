/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.border.event;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class RoleImageEvent {
	private long rid;
	private int imageId;
}
