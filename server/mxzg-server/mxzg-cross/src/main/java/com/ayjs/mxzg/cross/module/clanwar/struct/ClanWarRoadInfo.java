/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.struct;

import java.util.ArrayList;
import java.util.List;

import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarRecord;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarTeam;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSHisBattleDetail;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarResult;
import com.ayjs.mxzg.protocol.ClanWarGMsg.PSHisBattleDetail;

/**
 * @author YY
 *
 */
public class ClanWarRoadInfo {
	private final int road;
	
	private ClanWarTeam currBattleTeam;
	
	private ClanWarRecord currWarRecord;
	
	private CSHisBattleDetail currBattleDetail;
	
	private List<ClanWarTeam> teams = new ArrayList<>();
	//历史战况
	private List<CSHisBattleDetail> hisDetailList = new ArrayList<>();
	//胜负结果
	private ClanWarResult result = ClanWarResult.NONE;
	
	public ClanWarRoadInfo(int road) {
		this.road = road;
	}
	public int getRoad() {
		return road;
	}
	public List<ClanWarTeam> getTeams() {
		return teams;
	}
	public List<CSHisBattleDetail> getHisDetailList() {
		return hisDetailList;
	}
	/**
	 * 获取某一路第一个还存活的队伍
	 * @param warRoad
	 * @return
	 */
	public ClanWarTeam getFirstAliveTeam() {
		for(ClanWarTeam team : teams) {
			if(team.getAlive() == 1) {
				return team;
			}
		}
		return null;
	}
	
	/**
	 * 战路是否已经被摧毁
	 * @return
	 */
	public boolean isRoadDestory() {
		boolean destory = true;
		for(ClanWarTeam team : teams) {
			if(team.getAlive() == 1) {
				destory = false;
				break;
			}
		}
		return destory;
	}
	
	
	public ClanWarResult getResult() {
		return result;
	}
	public void setResult(ClanWarResult result) {
		this.result = result;
	}
	public void setTeams(List<ClanWarTeam> teams) {
		throw new UnsupportedOperationException("不该被调用的函数");
	}
	public void setHisDetailList(List<PSHisBattleDetail> hisDetailList) {
		throw new UnsupportedOperationException("不该被调用的函数");
	}
	public CSHisBattleDetail getCurrBattleDetail() {
		return currBattleDetail;
	}
	public void setCurrBattleDetail(CSHisBattleDetail currBattleDetail) {
		this.currBattleDetail = currBattleDetail;
	}
	public ClanWarRecord getCurrWarRecord() {
		return currWarRecord;
	}
	public void setCurrWarRecord(ClanWarRecord currWarRecord) {
		this.currWarRecord = currWarRecord;
	}
	public ClanWarTeam getCurrBattleTeam() {
		return currBattleTeam;
	}
	public void setCurrBattleTeam(ClanWarTeam currBattleTeam) {
		this.currBattleTeam = currBattleTeam;
	}
}
