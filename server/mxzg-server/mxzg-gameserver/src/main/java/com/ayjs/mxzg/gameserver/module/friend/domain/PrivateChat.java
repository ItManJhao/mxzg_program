/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.friend.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "private_chat", comment = "好友私聊表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class PrivateChat extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id", comment = "")
	private long id;
	@Column(name = "rid", comment = "消息所有者ID", readOnly = true)
	private long rid;
	@Column(name = "firend_rid", comment = "好友ID")
	private long firendRid;
	@Column(name = "manage_id", comment = "消息发送者ID")
	private long manageId;
	@Column(name = "time", comment = "发送时间")
	private int time;
	@Column(name = "chat_content", comment = "聊天内容", length = 500)
	private String chatContent;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public long getFirendRid() {
		return firendRid;
	}
	public void setFirendRid(long firendRid) {
		this.firendRid = firendRid;
	}
	public long getManageId() {
		return manageId;
	}
	public void setManageId(long manageId) {
		this.manageId = manageId;
	}
	public int getTime() {
		return time;
	}
	public void setTime(int time) {
		this.time = time;
	}
	public String getChatContent() {
		return chatContent;
	}
	public void setChatContent(String chatContent) {
		this.chatContent = chatContent;
	}
}
