package com.ayjs.mxzg.message.module.hero.message;

import java.util.List;

import com.ayjs.mxzg.message.module.hero.message.dto.RemoteEquipInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteGodEquip;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteHeroInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteJewelInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteRuneInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteTalentInfo;
import com.ayjs.rpc.RemoteMessage;

import lombok.Getter;
import lombok.Setter;

/**
 * 跨服去目标服务器获取跨服英雄数据，第二步，1/2
 */
@Getter
@Setter
public class ResRemoteHeroMessage implements RemoteMessage {
    /**
     * 英雄数据
     */
    private RemoteHeroInfo heroInfo;
    /**
     * 装备列表
     */
    private List<RemoteEquipInfo> equipInfos;
    /**
     * 符文列表
     */
    private List<RemoteRuneInfo> runeInfos;
    /**
     * 宝石信息
     */
    private List<RemoteJewelInfo> jewels;
    /**
     * 天赋信息
     */
    private List<RemoteTalentInfo> talents;
    /**
     * 神装信息
     */
    private List<RemoteGodEquip> godEquips;

    /**
     * 灵器
     */
    private List<Integer> reikiEquips;
}
