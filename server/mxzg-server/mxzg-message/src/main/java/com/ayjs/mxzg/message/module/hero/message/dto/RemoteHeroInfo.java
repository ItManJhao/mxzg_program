package com.ayjs.mxzg.message.module.hero.message.dto;

import com.ayjs.mxzg.config.struct.PetInfo;
import com.ayjs.mxzg.config.struct.TotemsInfo;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Builder
@Data
public class RemoteHeroInfo {
    private int heroType;//类型
    private int star;//星级
    private int stage;//品级
    private int level;//等级
    private int fighting;//战力
    private long atk;//攻击力
    private long def;//防御力
    private long hp;//血量
    private long agl;//速度
    private int fashionId;//皮肤
    private List<Integer> reiki_places ;
    private PetInfo pet;
    private TotemsInfo totemsInfo;
}
