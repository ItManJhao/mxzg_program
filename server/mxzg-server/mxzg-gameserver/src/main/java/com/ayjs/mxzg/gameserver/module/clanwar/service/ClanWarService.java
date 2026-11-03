/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanWarAllRewardSysCache;
import com.ayjs.mxzg.config.excel.constant.ClanWarConst;
import com.ayjs.mxzg.config.excel.entity.CClanWarAllReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqClanWarStageMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqClanWarStageMessage.ReqClanWarStageMessageBuilder;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarResult;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author YY
 *
 */
@Slf4j
@Observer
@Service
public class ClanWarService {

	@Autowired
	private ClanWarAllRewardSysCache clanWarAllRewardSysCache;
	@Autowired
	private MailService mailService;
	@Autowired
	private MessageDispatcher messageDispatcher;
	@Autowired
	private ServerConfig serverConfig;
    @Autowired
    private ServerParamService serverParamService;
	
	private int roundEndTime;
	private Map<Long, Long> battlingClans = new ConcurrentHashMap<>();
	
	/**
	 * 是否公会战活动期间
	 * @return
	 */
	public boolean isDuringClanWar() {
		return roundEndTime > TimeDateUtil.getCurrentTimeInt();
	}

    /**
     * 是否已开启公会战
     *
     * @return
     */
    public boolean isStartClanWar() {
        int nowTime = TimeDateUtil.getCurrentTimeInt();

        int clanWarFirstTime = TimeDateUtil.getSomedayZeroInt(serverParamService.getServerStartTime())
                + TimeDateUtil.ONEDAYINT * ClanWarConst.OPEN_DAY;
        return nowTime >= clanWarFirstTime;
    }

	/**
	 * 公会是否参加公会战
	 * @param clanId
	 * @return true:参加，false:没参加
	 */
	public boolean isJoinClanWar(long clanId) {
		return battlingClans.containsKey(clanId);
	}
	
	@Subscribe(async = Subscribe.AsyncType.Async)
	private void listen(CrossConnectedEvent event) {
		ReqClanWarStageMessageBuilder builder = ReqClanWarStageMessage.builder();
		builder.serverId(serverConfig.getServerId());
		messageDispatcher.dispatch(builder.build());
	}
	
	/**
	 * 更新公会战阶段信息
	 * @param message
	 */
	public void updateStageInfo(int roundEndTime, List<Long> clanIds) {
		log.info("连接跨服成功后收到跨服返回的公会战阶段数据");
		this.roundEndTime = roundEndTime;
		this.battlingClans.clear();
		if(clanIds != null) {
			for(Long clanId : clanIds) {
				this.battlingClans.put(clanId, clanId);
			}
		}
	}
	
	public void testForEndReward(long rid) {
		List<Mail> mailList = new ArrayList<>();
		CClanWarAllReward reward1 = clanWarAllRewardSysCache.getOrThrow(ClanWarResult.WIN.getValue());
		Mail mail1 = mailService.newSimpleMail(rid, MailScene.CLAN_WAR_WIN, reward1.getReward(),
				GameEvent.CLANWAR_JOIN);

		CClanWarAllReward reward2 = clanWarAllRewardSysCache.getOrThrow(ClanWarResult.LOSE.getValue());
		Mail mail2 = mailService.newSimpleMail(rid, MailScene.CLAN_WAR_LOSE, reward2.getReward(),
				GameEvent.CLANWAR_JOIN);
		mailList.add(mail1);
		mailList.add(mail2);
		mailService.insertMails(mailList);
	}
}
