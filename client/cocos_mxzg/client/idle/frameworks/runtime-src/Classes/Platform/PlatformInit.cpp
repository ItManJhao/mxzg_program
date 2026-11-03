//
//  PlatformInit.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "PlatformInit.h"
#include "SimpleAudioEngine.h"
#include "../Model/LuaManager.h"
#include "../Model/Game.h"

// 平台初始化
void PlatformInit::init() {
	Game::instance()->stopTheGame();
	//Director::getInstance()->getScheduler()->unscheduleAll();

	CocosDenshion::SimpleAudioEngine::getInstance()->stopBackgroundMusic(true);
	CocosDenshion::SimpleAudioEngine::getInstance()->stopAllEffects();

//    // 准备登陆腾讯平台
//    SocialPlatform::instance()->init();

	// 进入平台LOGO动画场景
    CSJson::Value json;
    json["status"] = 10;
    auto is_change = LuaManager::instance()->executeGlobalBoolFunctionReturn("changeToLogoSceneCtr", json);
    if (is_change) {
    }
}

