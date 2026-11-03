/**
 * 
 */
package com.ayjs.mxzg.message.module.clan;

import com.ayjs.mxzg.message.cross.CrossMessage;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Builder
@Getter
@Setter
public class MemberChangeClanMessage implements CrossMessage {
	private long rid;
	private long newClanId;
    private long oldClanId;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public long getNewClanId() {
		return newClanId;
	}
	public void setNewClanId(long newClanId) {
		this.newClanId = newClanId;
	}
	public long getOldClanId() {
		return oldClanId;
	}
	public void setOldClanId(long oldClanId) {
		this.oldClanId = oldClanId;
	}
}
