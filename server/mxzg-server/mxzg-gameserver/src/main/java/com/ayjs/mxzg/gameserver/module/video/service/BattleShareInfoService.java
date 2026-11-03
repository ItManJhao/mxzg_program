/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.video.service;

import java.io.UnsupportedEncodingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.gameserver.module.video.constant.BattleShareType;
import com.ayjs.mxzg.gameserver.module.video.dao.BattleShareInfoDao;
import com.ayjs.mxzg.gameserver.module.video.domain.BattleShareInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;

/**
 * @author YY
 *
 */
@Service
public class BattleShareInfoService {

	@Autowired
	private BattleShareInfoDao battleShareInfoDao;
	
	
	public BattleShareInfo get(String shareId) {
		return battleShareInfoDao.get(shareId);
    }
	
	public BattleShareInfo addBattle(BattleShareType battleShareType, BattleReport battleReportMsg) {
		try {
			BattleShareInfo info = new BattleShareInfo();
			info.setId(newBattleShareId(battleShareType, battleReportMsg.getBattleId()));
			String battleReport = new String(battleReportMsg.toByteArray(), VideoConst.ISO);
			info.setBattleReport(battleReport);
			battleShareInfoDao.addOrUpdate(info);
			return info;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
	
	private String newBattleShareId(BattleShareType battleShareType, String id) {
        return battleShareType.getValue() + id;
    }
}
