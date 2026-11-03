/**
 * 
 */
package com.ayjs.mxzg.cross.module.clan.event;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class ClanChangeEvent {
	private long rid;
    private long newClanId;
    private long oldClanId;
}
