//
//  Game.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__Game__
#define __ClickerHeroes__Game__

#include "../Common/CommonDefine.h"
#include "../Common/SingleInstance.h"
#include "GameImpl.h"

typedef enum {
	NET_STATE_DISCONNECTED = 0,	// 无网络
	NET_STATE_WIFI = 1,			// WIFI网络
	NET_STATE_MOBILE = 2		// 手机网络
} NetworkState;

class Game : public Ref, public SingleInstance<Game> {
private:
    int64_t client_lastest_time;
    int64_t server_lastest_time;
    int64_t latest_touch; // 最后的一次点击时间
    int32_t background_music_id;
    
    GameImpl* game_impl;
    
//    cocos2d::experimental::AudioEngine* audio_engine;
    void checkNetwork(float delay);
    
    static bool widthAndHeightCompare(pair<cocos2d::Size, DeviceType> t1, pair<cocos2d::Size, DeviceType> t2);
    
public:
//    static Game* instance(){}
    string push_token;
    string push_id;
    DeviceType device;
    DeviceWidthToHeight d_wth; // 设备宽高比
    
    /**
     * 当前是否在线(在线判定为socket是否链接中)
     * 该值的改变只在两处：1、LoginController::loginGameDone；2、SocketClient::close()
     */
    static bool is_online;
    static bool is_stop_game;       // 记录是否已经停止了游戏，该值在logoscene调用startgame时置位为false，stopthegame时置位为true
    
    static bool is_login;       // 是否点击了进入游戏，判断是否是SDK切换了用户
    
    static bool is_in_pay;      // 是否正在充值支付中
    static bool is_need_recharge_check;     // 是否需要充值订单检查
    
    static int64_t server_version; // 服务器版本号（日期加3位数）
    static int64_t client_version; // 客户端版本号（日期加3位数）
    static bool config_loaded; // 配置是否已经加载过了
    
    static int32_t goto_main_scene_time;
    
    static string music_playing;
    map<string, int64_t> play_times;

    int zone;   // 时区间隔时间
    
    unsigned char encode_key[32];

    Game();
    virtual ~Game();
    void confirmDevice();
    /**获取服务端精确时间(秒级)*/
    int getServerTime();
    /**获取服务端精确时间(毫秒量级)*/
    int64_t getServerMillisecond();
    void setServerTime(int64_t server_time);
    void onInconsistentData(); // 与后端数据不一致
    void onOffline(); // 网络不通
    void reLogin(int button_index = 0);
    void setResLogin();
    
    void startCheckNetwork();
    void stopCheckNetwork();
    
    void downloadApp();
    
    void openURL(const char* url);
    
    
    string getDeviceString();
    static float getReverseScale();
    cocos2d::Rect getEGLViewRect();
    float getNotchHeight();
    DeviceOrientation getDeviceOrientation();
    static void orientationChange(int32_t orientation);

    string getDeviceToken();
    void updateXingeToken(string token);
    
    // 音效相关
    static void preloadBackgroundMusic(const char *path);
    static void playBackgroundMusic(const char *path);
    static void setBackgroundMusicVisible(bool visible);
    static void setBackgroundMusicVolume(int32_t volume);
    static bool getBackgroundMusicVisible();
    static int32_t getBackgroundMusicVolume();
    static void stopBackgroundMusic();
    
    static void preloadEffect(const char *path);
    static void playEffect(const char *path, bool frequently = false);
    static void setEffectsVisible(bool visible);
    static void setEffectsVolume(int32_t volume);
    static bool getEffectsVisible();
    static int32_t getEffectsVolume();
    
    static bool isKeyBoardShown();
    static void shutDownKeyBoard();
    
    static int64_t millisecond();
    static int second();
    
    static int64_t makeId();
    static string makeLuaId();

    //static string macAddress();
    string deviceUUID();
    string updateDeviceUUID();
    string getCurrentLanguageCodeFull();
    
    void updatePushId();
    
    string getVersion();
    string getBundleId();
    
    void setClipboard(string str);
    
    void stopTheGame();

    // 0:无网络 1:wifi 2:手机网络
    int getNetworkState();

    void showExitTheGame();
    void exitTheGame(float delay = 0);
    static void exitTheGameNoParam(int button_index = 0);
    
    void updateEncodeKey();
    unsigned char* getEncodeKey();
    
    string getDeviceLanguage();
    
    static void sendLog(const char* content);
    
    static bool isInVisible(Node* node);
    
    
};
 
#endif /* defined(__ClickerHeroes__Game__) */
