/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.mail.domain;

import java.util.Set;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.log.AbstractLog;
import com.ayjs.mxzg.gameserver.module.mail.domain.MailSome;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "mail_some_log", comment = "系统邮件日志表")
@Getter
@Setter
public class MailSomeLog extends AbstractLog {
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
	
	@ShardingId
	@Column(name = "create_time", comment = "邮件创建时间", readOnly = true)
	private long createTime;
	
	@Column(name = "expire_time", comment = "邮件创建时间")
	private long expireTime;
	
	@Column(name = "role_ids", comment = "指定玩家邮件时的角色ID列表")
	private Set<Long> roleIds;
	
	@Column(name = "goods", comment = "奖励列表，json格式", length = 500)
	private String goods;
	

	@Override
	public Long getId() {
		return id;
	}

	@Override
	public void setId(Long id) {
		this.id = id;
	}

	public static void copyMail(MailSomeLog log, MailSome mail) {
		log.setType(mail.getType());
		log.setTitle(mail.getTitle());
		log.setContent(mail.getContent());
		log.setCreateTime(mail.getCreateTime());
		log.setExpireTime(mail.getExpireTime());
		log.setRoleIds(mail.getRoleIds());
		log.setGoods(mail.getGoods());
	}
}
