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
@Table(name = "relationship_req", comment = "好友申请表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class RelationshipReq extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id", comment = "")
	private long id;
	@Column(name = "rid", comment = "被请求的玩家的角色id", readOnly = true)
	private long rid;
	@Column(name = "request_rid", comment = "请求的玩家的角色id")
	private long requestRid;
	@Column(name = "req_time", comment = "请求时间")
	private int reqTime;
	@Column(name = "validate", comment = "0未读，1通过，2未通过")
	private int validate;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public long getRequestRid() {
		return requestRid;
	}
	public void setRequestRid(long requestRid) {
		this.requestRid = requestRid;
	}
	public int getReqTime() {
		return reqTime;
	}
	public void setReqTime(int reqTime) {
		this.reqTime = reqTime;
	}
	public int getValidate() {
		return validate;
	}
	public void setValidate(int validate) {
		this.validate = validate;
	}
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
}
