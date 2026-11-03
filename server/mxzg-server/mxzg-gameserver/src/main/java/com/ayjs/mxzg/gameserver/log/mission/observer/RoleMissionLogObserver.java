package com.ayjs.mxzg.gameserver.log.mission.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChapterrewardSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.entity.CChapterreward;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.gameserver.log.mission.domain.RoleMissionLog;
import com.ayjs.mxzg.gameserver.module.battle.constant.MainBattleConstant;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterBattleEvent;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;

@Observer
public class RoleMissionLogObserver {

	@Autowired
	private LogEntityFactory logEntityFactory;
	@Autowired
    private LogService logService;
	@Autowired
    private ChapterrewardSysCache chapterrewardSysCache;
	@Autowired
	private LanguageSysCache languageSysCache;
	@Autowired
	private LanguageHelper languageHelper;
	
	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void listen(ChapterBattleEvent event) {
		RoleMissionLog log = logEntityFactory.create(RoleMissionLog.class);
        log.setRid(event.getRid());
        log.setRidFighting(event.getFighting());
        log.setRidLevel(event.getLevel());
        log.setResult(event.isWin());
        
        CChapterreward cChapterreward = chapterrewardSysCache.getOrThrow(event.getMissionId());
        CLanguage cLanguage = languageSysCache.getByKey(String.valueOf(MainBattleConstant.LANGUAGE_BASE_ID + cChapterreward.getChapter_id()));
        String mosterName = String.format("%s%s", languageHelper.getLanguageBy(cLanguage), cChapterreward.getIdx());
        
        log.setChapter_id(cChapterreward.getChapter_id());
        log.setMissionId(cChapterreward.getIdx());
        log.setMissionName(mosterName);
        log.setDateTime(LocalDateTime.now());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        logService.addLog(log);
	}
}
