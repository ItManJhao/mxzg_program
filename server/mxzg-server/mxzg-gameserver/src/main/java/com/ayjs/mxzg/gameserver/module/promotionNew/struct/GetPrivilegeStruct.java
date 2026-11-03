package com.ayjs.mxzg.gameserver.module.promotionNew.struct;

/**
 * 封装给前端的结构体
 *
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
public class GetPrivilegeStruct {
    private boolean get_privilege;

    public boolean isGet_privilege() {
        return get_privilege;
    }

    public static GetPrivilegeStruct of(boolean buy) {
        GetPrivilegeStruct struct = new GetPrivilegeStruct();
        struct.get_privilege = buy;
        return struct;
    }

}
