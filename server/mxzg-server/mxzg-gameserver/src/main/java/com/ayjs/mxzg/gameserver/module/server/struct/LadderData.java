package com.ayjs.mxzg.gameserver.module.server.struct;

import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRank;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 天梯活动时间
 *
 * @Author: CWJ
 * @Date: 2020/1/4
 **/
@Getter
@Setter
public class LadderData {

    private int startTime;
    private int endTime;
    private int lastEndDateTime;

    private int rankMailTime;


    public boolean isOpen(int time) {
        return startTime <= time & time <= endTime;
    }
}
