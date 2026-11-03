/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clan.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.clan.dao.ClanMemberDonateDao;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMemberDonate;
import com.ayjs.mxzg.protocol.ClanGMsg.GResQuitClanTime;

/**
 * @author YY
 * 
 */
@Service
public class ClanMemberDonateService {

	@Autowired
	private ClanMemberDonateDao clanMemberDonateDao;
	@Autowired
	private ContextManager contextManager;
	
	/**
     * 查询玩家公会捐献
     *
     * @param rid
     * @return
     */
    public ClanMemberDonate getDonate(long rid) {
        ClanMemberDonate donate = clanMemberDonateDao.get(rid);
        if (donate == null) {
        	donate = new ClanMemberDonate();
        	donate.setRid(rid);
            clanMemberDonateDao.add(donate);
        }
        if(TimeDateUtil.getCurrentTimeInt() > donate.getDailyTime()) {
        	donate.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
        	donate.setDonateThing(0);
        	donate.getDonateReward().clear();
        	clanMemberDonateDao.update(donate);
        }
        return donate;
    }

    /**
     * 更新玩家公会捐献
     *
     * @param clanMemberDonate
     */
    public void updateDonate(ClanMemberDonate donate) {
        clanMemberDonateDao.update(donate);
    }

    public int getQuitClanTime(long rid) {
    	ClanMemberDonate clanMemberDonate = getDonate(rid);
    	return clanMemberDonate.getQuitClanTime();
    }

    protected void updateQuitClanTime(long rid, int nowTime) {
    	ClanMemberDonate donate = getDonate(rid);
    	donate.setQuitClanTime(nowTime);
    	clanMemberDonateDao.update(donate);
    }

    /**
     * 发送下一次允许加入公会协议
     *
     * @param rid
     */
    public void sendQuitClanTime(long rid) {
        GResQuitClanTime.Builder builder = GResQuitClanTime.newBuilder();
        builder.setTime(getQuitClanTime(rid));
        contextManager.write(rid, CmdCode._7000, builder.build());
    }
    
}
