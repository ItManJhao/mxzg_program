//
//  RoleData.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__RoleData__
#define __AVT__RoleData__

#include "../Common/CommonDefine.h"
#include "../Common/SingleInstance.h"


#include "../AutoRun/NetManager.h"
#include "../Net/Protocol/ProtocolRequest.h"

class RoleData : public Ref, public SingleInstance<RoleData>
{
public:
    
    
    int gold;
    int gem;
    
    
    float total_charge;     // 玩家总共充值宝石个数
    bool is_role_rename;    // 角色是否重命名过
    bool is_new_player;
    int32_t login_time;         // 登陆时间
    int32_t role_create_time;   // 角色创建时间
    
    int32_t inline_time_tip;

    
    int32_t adventure_daily_limit;  // 友情点每天限额
    int32_t befall_daily_limit;
    int32_t friend_daily_limit;

    int32_t restore_energy;         // 今天体力恢复次数
    
    /**首充相关**/
    int16_t first_charge_status;    // 首充状态  1:没有首充  2:首充但没有领  3:表示首充且已领
    
//    static RoleData* instance(){}
public:
    RoleData();
    ~RoleData();
    
    bool isFirstCharge();   // 是否为首充（商城充值宝石）
    

};

#endif /* defined(__AVT__RoleData__) */
