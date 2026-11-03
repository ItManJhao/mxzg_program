/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.domain;

import java.util.Map;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.hero.struct.IllustratData;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "illustrat", comment = "英雄图鉴表")
@Getter
@Setter
public class Illustrat extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "heros", comment = "英雄图鉴数据", length = 10000)
	private Map<Integer, IllustratData> heros;
}
