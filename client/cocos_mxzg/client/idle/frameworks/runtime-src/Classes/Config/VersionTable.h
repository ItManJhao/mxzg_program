//
//  VersionTable.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT_VersionTable__
#define __AVT_VersionTable__

#include "ConfigTable.h"
#include "../Common/SingleInstance.h"

class VersionConfig {
public:
    int version; // 主版本号
    vector<string> platform_urls;
    string download_urls;
    string config_type;
    short lang;
    int16_t run_guide;
    VersionConfig();
};

class VersionTable : public ConfigTable, public SingleInstance<VersionTable> {
public:
	VersionConfig config;
    VersionTable();
    virtual void reload();
};

#endif /* __AVT_VersionTable__ */
