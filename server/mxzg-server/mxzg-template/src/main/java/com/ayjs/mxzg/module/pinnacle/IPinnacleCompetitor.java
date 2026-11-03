/**
 * 
 */
package com.ayjs.mxzg.module.pinnacle;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;

/**
 * @author YY
 *
 */
public interface IPinnacleCompetitor {
	long getRid();
	void setRid(long rid);
	int getPoint();
	void setPoint(int point);
	int getKnockoutWin();
	void setKnockoutWin(int knockoutWin);
	int getOriPoint();
	void setOriPoint(int oriPoint);
	int getTrialsGroup();
	void setTrialsGroup(int trialsGroup);
	int getTrialsPos();
	void setTrialsPos(int trialsPos);
	int getTrialsIndex();
	void setTrialsIndex(int trialsIndex);
	int getChaosGroup();
	void setChaosGroup(int chaosGroup);
	int getChaosIndex();
	void setChaosIndex(int chaosIndex);
	int getKnockoutGroup();
	void setKnockoutGroup(int knockoutGroup);
	int getKnockoutIndex();
	void setKnockoutIndex(int knockoutIndex);
	BattlerVo getBattlerVo();
	void setBattlerVo(BattlerVo battlerVo);
	int getFighting();
	void setFighting(int fighting);
	int getRobot();
	void setRobot(int robot);
	int getCrossGroup();
	
	
	public String getName();
	public void setName(String name);
	public int getLevel();
	public void setLevel(int level);
	public int getHeadId();
	public void setHeadId(int headId);
	public int getBorderId();
	public void setBorderId(int borderId);
	public int getServerId();
	public void setServerId(int serverId);
}
