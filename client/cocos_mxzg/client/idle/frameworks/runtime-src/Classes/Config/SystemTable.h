//
//  SystemTable.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__SystemTable__
#define __AVT__SystemTable__

#include "ConfigTable.h"
#include "../Common/SingleInstance.h"

class SystemConfig {
public:
    SystemConfig();
    int64_t value;
};

class SystemTable : public ConfigTable, public SingleInstance<SystemTable> {
public:
    SystemConfig config;
    SystemTable();
    virtual void reload();
    
    SystemConfig* getConfig(const char* key);
public:
    map<std::string,SystemConfig> table;
};

#pragma mark - 防外挂
class GamePluginTable : public ConfigTable, public SingleInstance<GamePluginTable> {
public:
    GamePluginTable();
    virtual void reload();
    
    vector<string> getList();
    
private:
    char data[2500];
};

#endif /* defined(__AVT__SystemTable__) */
