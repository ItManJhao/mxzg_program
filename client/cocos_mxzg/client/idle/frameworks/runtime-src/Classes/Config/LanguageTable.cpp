//
//  LanguageTable.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "LanguageTable.h"
#include "../Model/UserSetting.h"
#include "../Common/CSVFile.h"
#include <string>

LanguageTypeConfig::LanguageTypeConfig() {
    idx = 0;
    text = "";
}

// 语言列表配置
LanguageTypeConfigTable::LanguageTypeConfigTable() {
    file_name = "languagetype.csv";
}

void LanguageTypeConfigTable::reload()
{
    table.clear();
    
    CSVFile csv_reader;
    if (!csv_reader.Open(true, file_name.c_str())) {
        if (!csv_reader.OpenLocal(true, StringUtils::format("config/%s", file_name.c_str()).c_str())) {
            return;
        }
    }
    
    while (csv_reader.CSVReadNextRow()) {
        LanguageTypeConfig obj;
        
        string str_idx;
        csv_reader.CSVRead("idx", str_idx);
        if (!strcmp(str_idx.c_str(), "#")) {
            continue;
        }
        
        obj.idx = atoi(str_idx.c_str());
        csv_reader.CSVRead("text", obj.text);
        
        table[obj.idx] = obj;
    }
}

#pragma mark ---------------

LanguageTable::LanguageTable() {
    file_name = "language.csv";
}

// 语言配置
void LanguageTable::reload()
{
    table.clear();
    
    CSVFile csv_reader;
    if (!csv_reader.Open(true, file_name.c_str())) {
        if (!csv_reader.OpenLocal(true, StringUtils::format("config/%s", file_name.c_str()).c_str())) {
            return;
        }
    }
    
    while (csv_reader.CSVReadNextRow()) {
        LanguageConfig obj;
        
        string str_idx;
        csv_reader.CSVRead("key", str_idx);
        if (!strcmp(str_idx.c_str(), "#")) {
            continue;
        }
        
        obj.key = atoi(str_idx.c_str());
        csv_reader.CSVReadString("value", obj.value);

        LanguageMap::iterator iter = table.find( obj.key );
        if (iter != table.end()) {
            CCLOG("%s, %s", str_idx.c_str(), obj.value.c_str());
        }
        
        table[obj.key] = obj;
    }
}

const char* LanguageTable::getLanguage(int32_t key)
{
    LanguageMap::iterator iter = table.find(key);
    if (iter == table.end()) {
        CCLOG("Can not find the text %d in 'language %d'.", key, UserSettingManager::instance()->user_setting.lang);
        return "";
    }
    return iter->second.value.c_str();
}
