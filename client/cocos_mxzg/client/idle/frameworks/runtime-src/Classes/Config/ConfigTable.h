//
//  ConfigTable.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__ConfigTable__
#define __AVT__ConfigTable__

#include "../Common/CommonDefine.h"
#include "../lib_json/json_lib.h"

class ConfigTable {
public:
    virtual ~ConfigTable(){}
    string file_name;
    
    // 重新加载配置表
    virtual void reload() = 0;
};

#endif /* defined(__AVT__ConfigTable__) */
