package com.ayjs.mxzg.message.module.stagematch.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LegendInfo {
    private int server_id ;   //分区
    private String name;       //名字
    private int stage_id;    //段位
    private int rank;	    //排名
    private int fighting;    //战力
    private int image_id;    //形象id

    public static LegendInfo createOf(int server_id, String name, int stage_id, int rank, int fighting, int image_id){
        LegendInfo legendInfo = new LegendInfo();
        legendInfo.setServer_id(server_id);
        legendInfo.setName(name);
        legendInfo.setStage_id(stage_id);
        legendInfo.setRank(rank);
        legendInfo.setFighting(fighting);
        legendInfo.setImage_id(image_id);
        return legendInfo;
    }
}
