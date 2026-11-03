/**
 *
 */
package com.ayjs.mxzg.config.struct;

import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.common.util.IThing;
import lombok.Value;

/**
 * @author YY
 * 初始化之后就不可改变的奖励对象
 */
@Value(staticConstructor = "of")
public class ImmutableThing implements IThing, IDrop {
    private int item_type;
    private long item_num;
    private int chance;

    public static ImmutableThing of(int item_type, long item_num) {
        return of(item_type, item_num, 0);
    }

    @Override
    public int getThingId() {
        return item_type;
    }

    @Override
    public long getNum() {
        return item_num;
    }

    @Override
    public int getDropId() {
        return item_type;
    }

    @Override
    public int getRate() {
        return chance;
    }
}
