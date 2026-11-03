//
//  MainLevelTable.h
//  AVT
//
//  Created by windy on 17/10/14.
//
//

#ifndef __AVT__MainLevelTable_Table__
#define __AVT__MainLevelTable_Table__

#include "ConfigTable.h"
#include "../Common/SingleInstance.h"

class MainLevelConfig {
public:
    int16_t level;
    int32_t exp;
    MainLevelConfig(){
        level = 0;
        exp = 0;
    }
};

class MainLevelTable : public ConfigTable, public SingleInstance<MainLevelTable>
{
public:
    map<int16_t,MainLevelConfig > table;
    MainLevelTable();
    virtual void reload();
    MainLevelConfig* getConfig(int16_t level);
    int16_t getMaxLevel();
};

#endif
