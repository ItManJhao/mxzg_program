//
//  LanguageTable.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__LanguageTable__
#define __AVT__LanguageTable__

#include "ConfigTable.h"
#include "../Common/SingleInstance.h"

#pragma mark - 语言类型配置
class LanguageTypeConfig {
public:
    short idx;
    string text;
    
    LanguageTypeConfig();
};

class LanguageTypeConfigTable : public ConfigTable, public SingleInstance<LanguageTypeConfigTable>
{
public:
    map<short, LanguageTypeConfig> table;
    LanguageTypeConfigTable();
    virtual void reload();
};

#pragma mark - 语言配置
class LanguageConfig {
public:
    int32_t key;
    string value;
};

class LanguageTable : public ConfigTable, public SingleInstance<LanguageTable>
{
public:
    map<int32_t, LanguageConfig> table;
    LanguageTable();
    virtual void reload();
    const char* getLanguage(int32_t key);
};

typedef map<int32_t, LanguageConfig> LanguageMap;



#endif /* defined(__AVT__LanguageTable__) */
