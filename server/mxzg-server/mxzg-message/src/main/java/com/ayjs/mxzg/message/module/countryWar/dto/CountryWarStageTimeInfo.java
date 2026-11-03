package com.ayjs.mxzg.message.module.countryWar.dto;

import lombok.Value;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Value(staticConstructor = "of")
public class CountryWarStageTimeInfo {

    private int stage;
    private LocalDateTime stageStartTime;
    private LocalDateTime nextStageTime;
    private int round;
    private int idx;
    private boolean join;
}
