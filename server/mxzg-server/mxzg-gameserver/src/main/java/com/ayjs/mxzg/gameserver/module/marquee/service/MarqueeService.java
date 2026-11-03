/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.marquee.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.NoticeSysCache;
import com.ayjs.mxzg.config.excel.entity.CNotice;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatService;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.marquee.struct.Marquee;
import com.ayjs.mxzg.gameserver.module.marquee.struct.ObjParam;
import com.ayjs.mxzg.protocol.MarqueeGMsg.GResMarquee;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Observer
@Slf4j
@Service
public class MarqueeService {
	
	
	@Autowired
	private NoticeSysCache noticeSysCache;
	@Autowired
	private MailService mailService;
	@Autowired
	private ChatService chatService;
	@Autowired
	private ContextManager contextManager;
	@Autowired
	private ClanService clanService;

	private AtomicInteger idGen = new AtomicInteger(0);
	/**
	 * 强制优先
	 */
	private Map<Integer, Marquee> forceMarqueeMap = new ConcurrentHashMap<>();
	/**
	 * 普通优先
	 */
	private Map<Integer, Marquee> marqueeMap = new ConcurrentHashMap<>();
	
	
	private static final int SCOPE_ALL = 0;
	private static final int SCOPE_CLAN = 1;
	
	
	public void addMarquee(int sysId, long targetId, ObjParam objParam) {
		addMarquee(sysId, targetId, 0, 0, -1,objParam);
	}
	/**
	 * 添加公告、跑马灯
	 * @param sysId
	 * @param params
	 */
	public void addMarquee(int sysId, long targetId, int loopCount, long platformId, int space,ObjParam objParam) {
		try {
			CNotice cNotice = noticeSysCache.getOrThrow(sysId);
			List<String> paramList = new ArrayList<>();
			if(objParam != null) {
				for(Object param : objParam.getParams()) {
					paramList.add(param.toString());
				}
			}
			
			String finalLamp = mailService.formatParamStr(cNotice.getLamp_lang(), cNotice.getParam(), paramList);
			String finalChat = mailService.formatParamStr(cNotice.getChat_lang(), cNotice.getParam(), paramList);
			//发跑马灯
			if(cNotice.getMarquee() == 1) {
				Marquee marquee = new Marquee();
				marquee.setId(idGen.incrementAndGet());
				marquee.setSysId(sysId);
				marquee.getParams().addAll(paramList);
				marquee.setFinalContent(finalLamp);
				marquee.setLoopCount(loopCount != 0 ? loopCount : cNotice.getLoop_count());
				marquee.setCurrCount(0);
				marquee.setSpaceTime(space == -1? cNotice.getSpace() : space);
				marquee.setNextTime(TimeDateUtil.getCurrentTimeInt());
				marquee.setScope(cNotice.getScope());
				marquee.setTargetId(targetId);
				marquee.setPlatformId(platformId);
				
				if(cNotice.getForce() == 1) {
					forceMarqueeMap.put(marquee.getId(), marquee);
				} else {
					marqueeMap.put(marquee.getId(), marquee);
				}
			}
			
			//TODO 添加各频道信息
			for(int channel : cNotice.getChannel()) {
				ChatType chatType = ChatType.valueOf(channel);
				if(chatType == null) {
					continue;
				}
				chatService.send(chatType, finalChat, 0, targetId, true, cNotice.getIdx(), paramList);
			}
		} catch (Exception e) {
			log.error("跑马灯idx为" + sysId + "未能正确播报", e);
		}
	}
	
	public void runForMarquee() {
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		sendMarquee(forceMarqueeMap, nowTime);
		sendMarquee(marqueeMap, nowTime);
	}
	
	private void sendMarquee(Map<Integer, Marquee> marqueeMap, int nowTime) {
		for(Marquee marquee : marqueeMap.values()) {
			if(marquee.getNextTime() > nowTime) {
				continue;
			}
			marquee.setCurrCount(marquee.getCurrCount() + 1);
			marquee.setNextTime(nowTime + marquee.getSpaceTime());
			
			GResMarquee.Builder builder = GResMarquee.newBuilder();
			builder.setMsg(marquee.getFinalContent());
			builder.setId(marquee.getId());
			builder.setIdx(marquee.getSysId());
			builder.addAllParams(marquee.getParams());
			
			if(marquee.getScope() == SCOPE_ALL) {
				contextManager.writeAll(CmdCode._35001, builder.build());
			} else if(marquee.getScope() == SCOPE_CLAN) {
				contextManager.writeSome(clanService.getMemberIds(marquee.getTargetId()), CmdCode._35001, builder.build());
			}
			
			if(marquee.getCurrCount() >= marquee.getLoopCount()) {
				marqueeMap.remove(marquee.getId());
			}
		}
	}
	
	/**
	 * 是否有对应的平台跑马灯
	 * @param platformId
	 * @return
	 */
	public boolean hasPlatformMarquee(long platformId) {
		for(Marquee marquee : forceMarqueeMap.values()) {
			if(marquee.getPlatformId() == platformId) {
				return true;
			}
		}
		for(Marquee marquee : marqueeMap.values()) {
			if(marquee.getPlatformId() == platformId) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 取消平台跑马灯
	 * @param platformId
	 */
	public void cancelPlatformMarquee(long platformId) {
		for(Marquee marquee : forceMarqueeMap.values()) {
			if(marquee.getPlatformId() == platformId) {
				forceMarqueeMap.remove(marquee.getId());
			}
		}
		for(Marquee marquee : marqueeMap.values()) {
			if(marquee.getPlatformId() == platformId) {
				marqueeMap.remove(marquee.getId());
			}
		}
	}
	
}
