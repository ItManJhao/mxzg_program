/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.pvp.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.PvpDailyRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.PvpWeeklyRewardSysCache;
import com.ayjs.mxzg.config.excel.constant.PvpConst;
import com.ayjs.mxzg.config.excel.entity.CPvpDaiLyReward;
import com.ayjs.mxzg.config.excel.entity.CPvpWeekLyReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.pvp.dao.PvpSysInfoDao;
import com.ayjs.mxzg.gameserver.module.pvp.domain.PvpSysInfo;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpDefEvent;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.ArenaRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.web.event.ServerOpenTimeResetEvent;
import com.ayjs.mxzg.protocol.PvpGMsg.PSRankPlayerData;
import com.ayjs.mxzg.template.constant.GameConstant;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Observer
@Service
public class PvpSysInfoService {

	
	@Autowired
	private PvpSysInfoDao pvpSysInfoDao;
	@Autowired
	private ServerParamService serverParamService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private PvpDailyRewardSysCache pvpDailyRewardSysCache;
	@Autowired
	private PvpWeeklyRewardSysCache pvpWeeklyRewardSysCache;
	@Autowired
	private ArenaRankService arenaRankService;
	@Autowired
	private MailService mailService;
	@Autowired
	private EventBus eventBus;
	
	
	public PvpSysInfo getSysInfo() {
		List<PvpSysInfo> list = pvpSysInfoDao.listAll();
		if(list.isEmpty()) {
			PvpSysInfo pvpSysInfo = new PvpSysInfo();
			pvpSysInfo.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			pvpSysInfo.setSeasonTime(0);
			pvpSysInfoDao.add(pvpSysInfo);
			return pvpSysInfo;
		} else {
			return list.get(0);
		}
	}
	
	/**
	 * 下一个竞技场赛季结算时间
	 * @return
	 */
	public int getNextPvpTime() {
		PvpSysInfo pvpSysInfo = getSysInfo();
		if(pvpSysInfo.getSeasonTime() == 0) {
			if(serverParamService.getServerStartTime() == 0) {
				return 0;
			} else {
				int nextPvpTime = TimeDateUtil.getSomedayZeroInt(serverParamService.getServerStartTime()) + TimeDateUtil.ONEDAYINT * 7;
				pvpSysInfo.setSeasonTime(nextPvpTime);
				pvpSysInfoDao.update(pvpSysInfo);
			}
		}
		return pvpSysInfo.getSeasonTime();
	}
	
	@Subscribe
	private void resetServerTime(ServerOpenTimeResetEvent event) {
		PvpSysInfo pvpSysInfo = getSysInfo();
		pvpSysInfo.setSeasonTime(TimeDateUtil.getSomedayZeroInt(event.getServerTime()) + TimeDateUtil.ONEDAYINT * 7);
		pvpSysInfoDao.update(pvpSysInfo);
		log.info("竞技场赛季时间重置，{}", pvpSysInfo.getSeasonTime());
	}
	
	/**
	 * 
	 */
	public void runForPvp() {
		//每日结算奖励
		pvpDailyReward();
		//赛季结算奖励
		pvpSeasonReward();
	}
	
	/**
	 * 竞技场每日结算奖励
	 */
	private void pvpDailyReward() {
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		
		PvpSysInfo pvpSysInfo = getSysInfo();
		if(nowTime < pvpSysInfo.getDailyTime()) {
			return;
		}
		
		pvpSysInfo.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
		pvpSysInfoDao.update(pvpSysInfo);
		
		List<Mail> mailList = new ArrayList<>();
		List<PSRankPlayerData> rankList = arenaRankService.showRanks(pvpDailyRewardSysCache.getMaxRank());
		for(PSRankPlayerData rankData : rankList) {
			CPvpDaiLyReward cReward = pvpDailyRewardSysCache.getReward(rankData.getRank());
			if(cReward == null) {
				continue;
			}
			Mail mail = mailService.newMailNoTitle(rankData.getPlayerId(), MailScene.PVP_DAILY_REWARD,
					MailParams.build(rankData.getRank()), cReward.getReward(), GameEvent.PVP_DAILY_REWARD);
			mailList.add(mail);
		}
		if(!mailList.isEmpty()) {
			mailService.insertMails(mailList);
		}
	}
	/**
	 * 测试每日奖励
	 */
	public void testDailyPvpReward() {
		List<Mail> mailList = new ArrayList<>();
		List<PSRankPlayerData> rankList = arenaRankService.showRanks(pvpDailyRewardSysCache.getMaxRank());
		for(PSRankPlayerData rankData : rankList) {
			CPvpDaiLyReward cReward = pvpDailyRewardSysCache.getReward(rankData.getRank());
			if(cReward == null) {
				continue;
			}
			Mail mail = mailService.newMailNoTitle(rankData.getPlayerId(), MailScene.PVP_DAILY_REWARD,
					MailParams.build(rankData.getRank()), cReward.getReward(), GameEvent.PVP_DAILY_REWARD);
			mailList.add(mail);
		}
		if(!mailList.isEmpty()) {
			mailService.insertMails(mailList);
		}
	}
	
	/**
	 * 竞技场每赛季结算奖励
	 */
	private void pvpSeasonReward() {
		PvpSysInfo pvpSysInfo = getSysInfo();
		int nextSeasonTime = getNextPvpTime();
		if(nextSeasonTime == 0) {
			return;
		}
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		if(nowTime < nextSeasonTime) {
			return;
		}
		pvpSysInfo.setSeasonTime(nextSeasonTime + TimeDateUtil.ONEDAYINT * 7);
		pvpSysInfoDao.update(pvpSysInfo);
		
		//发放竞技场赛季奖励
		List<Mail> mailList = new ArrayList<>();
		List<PSRankPlayerData> rankList = arenaRankService.showRanks(pvpWeeklyRewardSysCache.getMaxRank());
		for(PSRankPlayerData rankData : rankList) {
			CPvpWeekLyReward cReward = pvpWeeklyRewardSysCache.getReward(rankData.getRank());
			if(cReward == null) {
				continue;
			}
			Mail mail = mailService.newMailNoTitle(rankData.getPlayerId(), MailScene.PVP_SEASON_REWARD,
					MailParams.build(rankData.getRank()), cReward.getReward(), GameEvent.PVP_SEASON_REWARD);
			mailList.add(mail);
		}
		if(!mailList.isEmpty()) {
			mailService.insertMails(mailList);
		}
		
		//把竞技场中的玩家进行降积分
		//max = { 1000 , 当前积分*[1-(a*(当前积分/1000)^2+b*(当前积分/1000)+c)/100] }
        float a = PvpConst.CUP_REDUCE_FACTOR[0] * 1.0f / GameConstant.WAN;
        float b = PvpConst.CUP_REDUCE_FACTOR[1] * 1.0f / GameConstant.WAN;
        float c = PvpConst.CUP_REDUCE_FACTOR[2] * 1.0f / GameConstant.WAN;
		
		List<Role> updateList = new ArrayList<>();
		for(Role role : roleService.getAllRole()) {
			int currCup = role.getArenaScore();
			float cup = currCup / 1000.0f;
			int reduceCup = (int)(currCup * (1 - (a * cup * cup + b * cup + c) / 100.0f));
			
			int resultCup = Math.max(1000, reduceCup);
			if(role.getArenaScore() != resultCup) {
				role.setArenaScore(resultCup);
				updateList.add(role);
			}
			eventBus.post(PvpDefEvent.of(role.getId(), role.getArenaScore()));
		}
		roleService.updateRoles(updateList);
	}
	
	/**
	 * 测试每赛季奖励
	 */
	public void testWeeklyPvpReward() {
		List<Mail> mailList = new ArrayList<>();
		List<PSRankPlayerData> rankList = arenaRankService.showRanks(pvpWeeklyRewardSysCache.getMaxRank());
		for(PSRankPlayerData rankData : rankList) {
			CPvpWeekLyReward cReward = pvpWeeklyRewardSysCache.getReward(rankData.getRank());
			if(cReward == null) {
				continue;
			}
			Mail mail = mailService.newMailNoTitle(rankData.getPlayerId(), MailScene.PVP_SEASON_REWARD,
					MailParams.build(rankData.getRank()), cReward.getReward(), GameEvent.PVP_SEASON_REWARD);
			mailList.add(mail);
		}
		if(!mailList.isEmpty()) {
			mailService.insertMails(mailList);
		}
	}
	
}

