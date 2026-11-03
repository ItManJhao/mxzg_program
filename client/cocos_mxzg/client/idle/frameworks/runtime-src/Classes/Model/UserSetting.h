//
//  UserSetting.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__UserSetting__
#define __AVT__UserSetting__

#include <string>
#include <iostream>
#include <fstream>
#include "../Common/SingleInstance.h"
#include "cocos2d.h"

USING_NS_CC;
using namespace std;

struct UserSetting {
    int ver; // 文件的版本，不同版本，自动清空
    bool music_visible;
    bool sound_visible;
    int32_t music_percent;  // 背景声音大小，1-100
    int32_t sound_percent;  // 普通音效大小，1-100
    int8_t lang; // 1中文 2英文 3韩文 4繁体 5法文 6泰文
    char user_id[65];
    int64_t client_version; // 游戏客户端版本
    int server_id;
    char server_name[60];
    char update_url[129]; // 更新安装包用的网址
    
    bool is_turn_on_notification; // 是否打开推送；
    
    char image_url_md5[33]; // 全部公告图片网址的md5值，如果和后端返回算出来的不一样，就重新下载
    
    int8_t platform_type; // 平台类型 0游客 1wx 2qq  ／／一个字节
    
    // 世界和队伍在CharCtr中保存.
    int32_t clan_chat_read_time;    // 上次查看军团消息的时间
    int64_t friends_chat_read_time[60][2];
    
    int32_t dungeon_visit_level;     // 上次查看副本的等级

    int32_t refresh_shop_pvp_time;
    int32_t shop_pvp_list[5][2];    // <物品id, 已经购买的数量>
    
    int32_t refresh_pub_limit_time;
    int32_t pub_limit_count;
    
    int32_t refresh_shop_limit_time;
    int32_t shop_limit_num;

    UserSetting();
    
    void setUserId(const char* s);
    void setUpdateUrl(const char* s);
    void setImageUrlMD5(const char* s);
    
    void setString(char* str, const char* s, int size);
    
    void reset();
};

struct UserState {
    int64_t role_id;
    int lasttime_clan;
    int lasttime_global;
    int lasttime_battlelog;
    int16_t curGuideId;
    char request_soldier[61];
    bool is_guided_present;  // 是否启动过送礼指引
    int32_t last_login_time; // 上次登录的时间
    
    UserState()
    {
        role_id = 0;
        lasttime_clan = 0;
        lasttime_global = 0;
        lasttime_battlelog = 0;
        curGuideId = 0;
        is_guided_present = false;
        memset(request_soldier, 0, sizeof(request_soldier));
    }
};

/**
 * 背包模式下每个建筑的位置记录数据
 */
struct BagItemPos {
    int64_t building_id;
    int64_t area_id;
    int16_t x;
    int16_t y;
    
    BagItemPos() {
        building_id = 0;
        area_id = 0;
        x = 0;
        y = 0;
    }
    
    BagItemPos(int64_t building_id, int64_t area_id, int16_t x, int16_t y) {
        this->building_id = building_id;
        this->area_id = area_id;
        this->x = x;
        this->y = y;
    }
};

class UserSettingManager : public cocos2d::Ref,
                           public SingleInstance<UserSettingManager>
{
public:
    UserSetting user_setting;
    
    map<int64_t, UserState> settingMap;
    
    /**
     * 背包模式下记录的建筑位置缓存数据的map
     */
    
    int bag_mode_server_id; // 当前保存的编辑模式下建筑位置缓存所对应的服务器id
    int64_t bag_mode_role_id; // 当前保存的编辑模式下建筑位置缓存所对应的角色id
    
    map<int64_t, BagItemPos> bag_report_pos_map;
    
    UserSettingManager();
    
    void reload();
    void save();
    
    void reloadStateMap();
    void saveStateMap();
    UserState* getUserState(int64_t rid);
    
    void reloadBagRepotPosMap();
    void saveBagRepotPosMap();
    
    void setUserId(const char* user_id);
    string getUserId();
    
    void setServerId(int32_t server_id);
    int32_t getServerId();
    
    
    void clear();
    
protected:
    string setting_path;
    const char* getPath();
};

#endif /* defined(__AVT__UserSetting__) */
