//
//  GameAutoRun.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "GameAutoRun.h"

void GameAutoRun::stop() {
    Director::getInstance()->getScheduler()->unscheduleAllForTarget(this);
}

void GameAutoRun::stopAndRelease() {
    stop();
    release();
}

void GameAutoRun::start()
{
    interval = 1;
    delay = 0;
    
    init();
    
    Scheduler* sharedScheduler = Director::getInstance()->getScheduler();
    sharedScheduler->schedule(schedule_selector(GameAutoRun::run), this, interval, CC_REPEAT_FOREVER, delay, false);
}

void GameAutoRun::init()
{
    CCLOG("init the GameAutoRun here.");
}

void GameAutoRun::run(float delay)
{
    CCLOG("do something here.");
}
