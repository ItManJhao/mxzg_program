package com.ayjs.mxzg.gameserver.module.mail.domain;

import java.util.ArrayList;
import java.util.List;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.MappedSuperclass;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "mail", comment = "邮件表", indexes = { @Index(name = "rid", columnList = { "rid" }) }, cache = {
		@Cache(columns = "rid") })
@Getter
@Setter
@MappedSuperclass
public class Mail extends AbstractEntity {

	@Id
	@Column(name = "id", comment = "邮件ID")
	@LongIdGenerate
	private long id;

	@Column(name = "rid", readOnly = true, comment = "玩家ID")
	private long rid;

	@Column(name = "scene_id", comment = "邮件的类型，对应枚举MailScene")
	private int sceneId;
	
	@Column(name = "time", comment = "发送时间")
	private int time;

	@Column(name = "is_read", comment = "是否已读")
	private int isRead;

	@Column(name = "is_receive", comment = "是否已经领取奖励")
	private int isReceive;

	@Column(name = "title_param", comment = "邮件标题参数，json格式", length = 500)
	private List<String> titleParam = new ArrayList<>();

	@Column(name = "content_param", comment = "邮件内容参数，json格式", length = 500)
	private List<String> contentParam = new ArrayList<>();

	@Column(name = "goods", comment = "奖励列表，json格式", length = 500)
	private String goods;
	
	@Column(name = "game_event", comment = "游戏事件，流水类型")
	private int gameEvent;
	
	@Column(name = "title", comment = "经过参数拼接的标题", length = 1000)
	private String title;
	
	@Column(name = "content", comment = "经过参数拼接的内容", length = 1000)
	private String content;
	
	@Column(name = "refuse", comment = "是否因为长时间没登录而没有发送的邮件，0不是，1是")
	private int refuse;
}
