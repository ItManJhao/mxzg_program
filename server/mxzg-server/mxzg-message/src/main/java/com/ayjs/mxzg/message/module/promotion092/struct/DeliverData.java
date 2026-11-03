package com.ayjs.mxzg.message.module.promotion092.struct;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Getter
@Setter
public class DeliverData {
    private int index;
    private int heroType;
    private int score;
    private LocalDateTime rankTime = LocalDateTime.of(1970, 1, 1, 0, 0);
}
