/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.task.dao.SigndayDao;
import com.ayjs.mxzg.gameserver.module.task.domain.Signday;

/**
 * @author YY
 *
 */
@Observer
@Service
public class SigndayService {

	@Autowired
	private SigndayDao signdayDao;
	
	/**
	 * 获取签到数据
	 * @param rid
	 * @return
	 */
	public Signday getSignday(long rid) {
		Signday signday = signdayDao.get(rid);
		if(signday == null) {
			signday = new Signday();
			signday.setRid(rid);
			signdayDao.add(signday);
		}
		long nowTime = TimeDateUtil.getCurrentTime();
		boolean needUpdate = false;
		if(nowTime > signday.getDailyTime()) {
			signday.setTodaySign(0);
			signday.setTodayCharge(0);
			signday.setDailyTime(TimeDateUtil.getTomorrowZeroTime());
			needUpdate = true;
		}
		if(nowTime > signday.getMonthTime()) {
			signday.setDay(0);
			signday.setMonthTime(TimeDateUtil.getNextMonthZeroTime());
			needUpdate = true;
		}
		if(needUpdate) {
			signdayDao.update(signday);
		}
		return signday;
	}
	
	/**
	 * 更新
	 * @param signday
	 */
	public void updateSignday(Signday signday) {
		signdayDao.update(signday);
	}
	
	@Subscribe
	public void onEvent(RechargeEvent event) {
		Signday signday = getSignday(event.getRid());
		if(signday.getTodayCharge() == 0) {
			signday.setTodayCharge(1);
			updateSignday(signday);
		}
	}
}
