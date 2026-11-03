/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.mail.domain;

import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 * 全服邮件
 */
@Entity
@Table(name = "mail_some", comment = "全服邮件表")
@Getter
@Setter
public class MailSome extends AbstractEntity {

	@Id
	@Column(name = "id", comment = "邮件ID")
	@LongIdGenerate
	private long id;
	
	@Column(name = "type", comment = "邮件类型，1全服，2指定玩家邮件")
	private int type;
	
	@Column(name = "title", comment = "邮件标题")
	private String title;
	
	@Column(name = "content", comment = "邮件内容")
	private String content;
	
	@Column(name = "create_time", comment = "邮件创建时间")
	private long createTime;
	
	@Column(name = "expire_time", comment = "邮件过期时间")
	private long expireTime;
	
	@Column(name = "role_ids", comment = "指定玩家邮件时的角色ID列表")
	private Set<Long> roleIds;
	
	@Column(name = "goods", comment = "奖励列表，json格式", length = 500)
	private String goods;
	
}
