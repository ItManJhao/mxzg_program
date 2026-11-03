//
//  ActionFactory.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "ActionFactory.h"

ActionInterval* ActionFactory::createAnimateWithDuration(const char *plist, string format, float duration, CallFunc* callFunc) {
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    if (strlen(plist) > 0) {
        sfc->addSpriteFramesWithFile(plist);
    }
    
    Vector<SpriteFrame*> array;
    char name[50] = {};
    int i = 0;
    SpriteFrame* frame = NULL;
    
    while (1) {
        sprintf(name, format.c_str(), i++);
        frame = sfc->getSpriteFrameByName(name);
        if (!frame) {
            break;
        }
        array.pushBack(frame);
    }
    
    float speed = duration / array.size();
    Animation* animation = Animation::createWithSpriteFrames(array, speed);
    Animate* animate = Animate::create(animation);
    if (callFunc) {
        return Sequence::createWithTwoActions(animate, callFunc);
    } else {
        return animate;
    }
}

ActionInterval* ActionFactory::createLuaAnimateWithDuration(const char *plist, string format, float duration) {
    return createAnimateWithDuration(plist, format, duration, NULL);
}


Animation* ActionFactory::createAnimation(const char *plist, string format, float speed) {
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    sfc->addSpriteFramesWithFile(plist);
    
    Vector<SpriteFrame*> array;
    char name[50] = {};
    int i = 0;
    SpriteFrame* frame = NULL;
    
    while (1) {
        sprintf(name, format.c_str(), i++);
        frame = sfc->getSpriteFrameByName(name);
        if (!frame) {
            break;
        }
        array.pushBack(frame);
    }
    
    Animation* animation = Animation::createWithSpriteFrames(array, speed);
    return animation;
}


ActionInterval* ActionFactory::createAnimate(const char *plist, string format, float speed, CallFunc* callFunc) {
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    sfc->addSpriteFramesWithFile(plist);
    
    Vector<SpriteFrame*> array;
    char name[50] = {};
    int i = 0;
    SpriteFrame* frame = NULL;
    
    while (1) {
        sprintf(name, format.c_str(), i++);
        frame = sfc->getSpriteFrameByName(name);
        if (!frame) {
            break;
        }
        array.pushBack(frame);
    }
    
    //sfc->removeSpriteFramesFromFile(plist);
    
    Animation* animation = Animation::createWithSpriteFrames(array, speed);
    Animate* animate = Animate::create(animation);
    if (callFunc) {
        return Sequence::createWithTwoActions(animate, callFunc);
    } else {
        return animate;
    }
}

ActionInterval* ActionFactory::createLuaAnimate(const char *plist, string format, float speed) {
    return createAnimate(plist, format, speed, NULL);
}

ActionInterval* ActionFactory::createAnimate(string format, float speed, int32_t index) {
    
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();

    Vector<SpriteFrame*> array;
    char name[50] = {};
    int i = 0;
    SpriteFrame* frame = NULL;
    
    while (1) {
        sprintf(name, format.c_str(), i++);
        frame = sfc->getSpriteFrameByName(name);
        if (!frame) {
            break;
        }
        array.pushBack(frame);
    }
    
    if (array.size() > 0) {
        index = index % array.size();
        Vector<SpriteFrame*> tmp_array;

        for (int i = index; i < array.size(); ++i)
        {
            tmp_array.pushBack(array.at(i));
        }
        
        for (int i = 0; i < index; ++i)
        {
            tmp_array.pushBack(array.at(i));
        }
        
        Animation* animation = Animation::createWithSpriteFrames(tmp_array, speed);
        Animate* animate = Animate::create(animation);
        return animate;
    }
    
    Animation* animation = Animation::createWithSpriteFrames(array, speed);
    Animate* animate = Animate::create(animation);
    return animate;
}


RepeatForever* ActionFactory::createRepeatForever(const char *plist, string format, float speed) {
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    if (strlen(plist) > 0) {
        sfc->addSpriteFramesWithFile(plist);
    }
    
    Vector<SpriteFrame*> array;
    char name[50] = {};
    int i = 0;
    SpriteFrame* frame = NULL;
    
    while (1) {
        sprintf(name, format.c_str(), i++);
        frame = sfc->getSpriteFrameByName(name);
        if (!frame) {
            break;
        }
        array.pushBack(frame);
    }
    
    //sfc->removeSpriteFramesFromFile(plist);
    
    if (array.size() < 1) {
        return NULL;
    }
    
    Animation* animation = Animation::createWithSpriteFrames(array, speed);
    return RepeatForever::create(Animate::create(animation));
}


ActionInterval* ActionFactory::createAnimateWithRemoveSelf(const char *plist, string format, float speed) {
    
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    if (plist && strcmp(plist, "") != 0) {
        sfc->addSpriteFramesWithFile(plist);
    }
    
    Vector<SpriteFrame*> array;
    char name[50] = {};
    int i = 0;
    SpriteFrame* frame = NULL;
    
    while (1) {
        sprintf(name, format.c_str(), i++);
        frame = sfc->getSpriteFrameByName(name);
        if (!frame) {
            break;
        }
        array.pushBack(frame);
    }
    
    //sfc->removeSpriteFramesFromFile(plist);
    
    
    
    Animation* animation = Animation::createWithSpriteFrames(array, speed);
    Animate* animate = Animate::create(animation);
    return Sequence::createWithTwoActions(animate, RemoveSelf::create());
}

ActionInterval* ActionFactory::createAnimateWithDelayFrame(const char *plist, string format, float speed, int32_t frame_index, float delay_time) {

    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    sfc->addSpriteFramesWithFile(plist);
    
    Vector<AnimationFrame *> array;
    char name[50] = {};
    int i = 0;
    SpriteFrame* frame = NULL;
    
    int32_t index = 0;
    while (1) {
        sprintf(name, format.c_str(), i++);
        frame = sfc->getSpriteFrameByName(name);
        if (!frame) {
            break;
        }
        AnimationFrame *spframe = nullptr;
        if (index == frame_index) {
            spframe = AnimationFrame::create(frame, delay_time, ValueMap());
        } else {
            spframe = AnimationFrame::create(frame, speed, ValueMap());
        }
        
        array.pushBack(spframe);
        
        index++;
    }
    
    assert(index >= frame_index);
    
    Animation* animation = Animation::create(array, delay_time);
    Animate* animate = Animate::create(animation);
    return animate;
    //return Sequence::createWithTwoActions(animate, RemoveSelf::create());
}

ActionInterval* ActionFactory::createBeattackAction(Point pos) {
    int r = rand() % 2 == 0 ? 1 : -1;
    int range = 3;
    Vector<cocos2d::FiniteTimeAction *> arr;
    for (int i = 0; i < 4; i++) {
        MoveTo* add = MoveTo::create(0.03 , Vec2(pos.x + r * range    , pos.y ));
        MoveTo* sub = MoveTo::create(0.035, Vec2(pos.x - r * range * 2, pos.y ));
        arr.pushBack(add);
        arr.pushBack(sub);
        arr.pushBack(add);
        range -= 1;
        if (range < 1) {
            range = 1;
        }
    }
    arr.pushBack(MoveTo::create(0.01, pos));
    auto sequ_shake = Sequence::create(arr);
    // auto spawn = Spawn::create(Sequence::create(Blink::create(0.5, 2), Show::create(), NULL) , sequ_shake, NULL);
    auto spawn = Spawn::create(Blink::create(0.5, 2), sequ_shake, NULL);
    return spawn;
}

ActionInterval* ActionFactory::createShakeAction(float range, int times, float slow_down) {
    
    int r = rand() % 2 == 0 ? 1 : -1;
    //    Array* arr = Array::create();
//    float
    Vector<cocos2d::FiniteTimeAction *> arr;
    for (int i = 0; i < times; i++) {
        MoveBy* add = MoveBy::create(0.016, Vec2(range, r * range));
        MoveBy* sub = MoveBy::create(0.032, Vec2(-range * 2, r * -range * 2));
        arr.pushBack(add);
        arr.pushBack(sub);
        arr.pushBack(add);
        range -= slow_down;
        if (range < 1) {
            range = 1;
        }
    }
//    arr.pushBack(CallFunc::create(CC_CALLBACK_0(LayerBase::shakeActionEnd, this)));
    
    auto shake_action = Sequence::create(arr);
    return shake_action;
}
