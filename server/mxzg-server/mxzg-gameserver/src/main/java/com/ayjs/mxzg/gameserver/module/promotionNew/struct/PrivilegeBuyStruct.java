package com.ayjs.mxzg.gameserver.module.promotionNew.struct;

/**
 * 狂欢特权购买结构
 *
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
//@Value(staticConstructor = "of")
public class PrivilegeBuyStruct {
    private boolean buy_privilege;

    public boolean isBuy_privilege() {
        return buy_privilege;
    }

    public static PrivilegeBuyStruct of(boolean buy) {
        PrivilegeBuyStruct struct = new PrivilegeBuyStruct();
        struct.buy_privilege = buy;
        return struct;
    }

}
