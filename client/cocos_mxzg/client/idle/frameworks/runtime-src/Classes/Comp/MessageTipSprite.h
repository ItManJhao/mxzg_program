//
//  MessageTipSprite.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__MessageTipSprite__
#define __AVT__MessageTipSprite__

#include "cocos2d.h"

USING_NS_CC;

class MessageTipSprite : public Sprite {
    
public:
    MessageTipSprite();
    bool init(float parent_scale, bool is_numTip);

    static MessageTipSprite* create(float parent_scale, bool is_numTip);

    // 设置tip数字,数字归零自动隐藏
    void setTipNumber(uint8_t num);
    // 数量自增1
    void autoIncrements();
    
private:
    float parent_scale;
    Label* tip_label;
    uint8_t tip_number;  // 显示数量，超过9显示9
};

#endif /* defined(__AVT__MessageTipSprite__) */
