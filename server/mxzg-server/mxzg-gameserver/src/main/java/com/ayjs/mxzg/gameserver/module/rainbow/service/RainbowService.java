/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rainbow.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.RainbowSysCache;
import com.ayjs.mxzg.config.excel.constant.RainbowConst;
import com.ayjs.mxzg.config.excel.entity.CRainbow;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.rainbow.dao.RainbowRecordDao;
import com.ayjs.mxzg.gameserver.module.rainbow.dao.RainbowSlotDao;
import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowRecord;
import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowSlot;
import com.ayjs.mxzg.gameserver.module.rainbow.event.RainbowChallengeEvent;
import com.ayjs.mxzg.template.constant.ErrorCode;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Observer
@Service
public class RainbowService implements Lifecycle {

	@Autowired
	private RainbowSysCache rainbowSysCache;
	@Autowired
	private RainbowSlotDao rainbowSlotDao;
	@Autowired
	private RainbowRecordDao rainbowRecordDao;
	@Autowired
	private MailService mailService;
	@Autowired
	private HeroService heroService;
	
	@Override
	public LifecycleInfo getInfo() {
		return LifecycleInfo.valueOf("RainbowService");
	}

	@Override
	public void start() throws Exception {
		List<RainbowSlot> slotList = rainbowSlotDao.listAll();
		Map<Integer, Map<Integer, RainbowSlot>> typePosMap = ListMapUtil.fillTwoLayerMap(slotList, RainbowSlot::getType, RainbowSlot::getPos);
		
		List<RainbowSlot> newList = new ArrayList<>();
		//初始化数据
		for(CRainbow cRainbow : rainbowSysCache.getAll()) {
			Map<Integer, RainbowSlot> posMap = typePosMap.get(cRainbow.getRainbow_type());
			if(posMap == null) {
				posMap = new HashMap<>();
				typePosMap.put(cRainbow.getRainbow_type(), posMap);
			}
			for(int i = 0; i < cRainbow.getNum(); i++) {
				RainbowSlot slot = posMap.get(i + 1);
				if(slot == null) {
					slot = new RainbowSlot();
					slot.setType(cRainbow.getRainbow_type());
					slot.setLevel(0);
					slot.setPos(i + 1);
					newList.add(slot);
				}
			}
		}
		if(!newList.isEmpty()) {
			rainbowSlotDao.add(newList);
		}
	}
	
	public RainbowSlot getRainbowSlot(long id) {
		RainbowSlot rainbowSlot = rainbowSlotDao.get(id);
		Asserts.notNull(rainbowSlot, ErrorCode.RAINBOW_ERROR.getValue(), "彩虹圣殿数据不存在，id=" + id);
		return rainbowSlot;
	}
	
	public List<RainbowSlot> getAllSlot() {
		return rainbowSlotDao.listAll();
	}
	
	public void updateSlot(RainbowSlot slot) {
		rainbowSlotDao.update(slot);
	}
	
	public List<RainbowRecord> getRainbowRecord(long id) {
		return rainbowRecordDao.list("slotId", id);
	}
	
	public void addRecord(RainbowRecord record) {
		List<RainbowRecord> recordList = getRainbowRecord(record.getSlotId());
		if(recordList.size() > RainbowConst.RECORD_COUNT) {
			recordList.sort(Comparator.comparingInt(RainbowRecord::getTime));
			while(recordList.size() > RainbowConst.RECORD_COUNT) {
				RainbowRecord oldRecord = recordList.remove(0);
				rainbowRecordDao.remove(oldRecord);
			}
		}
		rainbowRecordDao.add(record);
	}
	
	@Subscribe(async = AsyncType.Async)
	private void listen(RainbowChallengeEvent event) {
		heroService.computeStrengthBiggerThenFiveStar(event.getRid(), GameEvent.RAINBOW_TAKE);
		if(event.getOldRid() > 0) {
			Mail mail = mailService.newMailNoTitle(event.getOldRid(), MailScene.RAINBOW_LOSS,
					MailParams.build(event.getNewSlot().getType()), null, GameEvent.RAINBOW_LOSS);
			mailService.insert(mail);
			//重算战斗力
			heroService.computeStrengthBiggerThenFiveStar(event.getOldRid(), GameEvent.RAINBOW_LOSS);
		}
	}
	
	
	public void runForRainbow() {
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		List<RainbowSlot> updateList = new ArrayList<>();
		for(RainbowSlot slot : this.getAllSlot()) {
			if(slot.getRid() <= 0 || slot.getEndTime() > nowTime) {
				continue;
			}
			
			synchronized (slot) {
				if(slot.getRid() <= 0 || slot.getEndTime() > nowTime) {
					continue;
				}
				log.info("彩虹圣殿位置" + slot.getType() + " - " + slot.getPos() + "失效");
				long rid = slot.getRid();
				slot.setRid(0);
				slot.setEndTime(0);
				updateList.add(slot);
				
				Mail mail = mailService.newMailNoTitle(rid, MailScene.RAINBOW_END, MailParams.build(slot.getType()), null, GameEvent.RAINBOW_END);
				mailService.insert(mail);
				//重算战斗力
				heroService.computeStrengthBiggerThenFiveStar(rid, GameEvent.RAINBOW_END);
			}
		}
		if(!updateList.isEmpty()) {
			rainbowSlotDao.update(updateList);
		}
	}
	
	/**
	 * 获取玩家在彩虹圣殿上占领的神位，没有占据或失效则返回null
	 * @param rid
	 * @return
	 */
	public RainbowSlot getRoleSlot(long rid) {
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		for(RainbowSlot slot : this.getAllSlot()) {
			if(slot.getRid() == rid && slot.getEndTime() > nowTime) {
				return slot;
			}
		}
		return null;
	}
}
