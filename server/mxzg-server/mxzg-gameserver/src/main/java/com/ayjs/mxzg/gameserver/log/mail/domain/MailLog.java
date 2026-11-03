/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.mail.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "mail_log", comment = "邮件日志表")
@Getter
@Setter
public class MailLog extends AbstractOperateLog {

	@Column(name = "scene_id", comment = "邮件的类型，对应枚举MailScene")
	private int sceneId;
	@ShardingId
	@Column(name = "time", comment = "发送时间", readOnly = true)
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
	
	/**
	 * 从邮件复制出邮件日志
	 * @param mail
	 * @return
	 */
	public static void copyMail(MailLog log, Mail mail) {
		log.setRid(mail.getRid());
		log.setSceneId(mail.getSceneId());
		log.setTime(mail.getTime());
		log.setIsRead(mail.getIsRead());
		log.setIsReceive(mail.getIsReceive());
		log.setTitle(mail.getTitle());
		log.setContent(mail.getContent());
		log.setGoods(mail.getGoods());
		log.setGameEvent(mail.getGameEvent());
		log.setRefuse(mail.getRefuse());
	}
}
