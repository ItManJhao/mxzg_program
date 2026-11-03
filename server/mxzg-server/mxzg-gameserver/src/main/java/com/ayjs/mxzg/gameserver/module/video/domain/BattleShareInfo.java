/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.video.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "battle_share_info", comment = "战斗分享数据")
public class BattleShareInfo extends AbstractEntity {
	@Id
    @Column(name = "id", comment = "主键ID")
    private String id;
	@Column(name = "battle_report", comment = "战斗数据，必须是iso-8859-1编码")
	private String battleReport;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBattleReport() {
		return battleReport;
	}
	public void setBattleReport(String battleReport) {
		this.battleReport = battleReport;
	}
}
