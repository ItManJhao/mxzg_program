//
//  UIMenuRound.cpp
//  Editorer
//
//  Created by windy on 2017/9/29.
//

#include "UIMenuRound.h"
#include "../../Model/LuaManager.h"

#define SCROLL_DEACCEL_RATE  0.92f
#define SCROLL_DEACCEL_DIST  1.0f
#define BOUNCE_BACK_FACTOR   0.5f



int sgn(float x)
{
    if (x < 0)
        return -1;
    return 1;
}

UIMenuRound::UIMenuRound()
: menu(NULL)
, is_appoint(false)
, select_index(-1)
, round_length (0)
, now_place(0)
, move_offset_x(0)
, dragging(false)
, min_scale(1)
, max_scale(1)
, round_height(0)
, correct_offset(0)
, select_callback(NULL)
, is_open_opacity(false)
, mim_opacity(125)
{
    
}

bool UIMenuRound::init() {
    if ( ! Layer::init() ) return false;
    
    auto listener = EventListenerTouchOneByOne::create();
    listener->setSwallowTouches(true);
    listener->onTouchBegan = CC_CALLBACK_2(UIMenuRound::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(UIMenuRound::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(UIMenuRound::onTouchEnded, this);
    listener->onTouchCancelled = CC_CALLBACK_2(UIMenuRound::onTouchCancel, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
    
    
    menu = UIMenu::create();
    menu->setSwallowsTouches(false);
    menu->setPosition(Vec2::ZERO);
    addChild(menu);
    
    return true;
}

bool UIMenuRound::onTouchBegan(Touch* touch, Event* event) {
    auto camera = Camera::getVisitingCamera();
    Vec2 touchLocation = touch->getLocation();
    Rect rect;
    rect.size = getContentSize();
    rect.size.width *= 0.6;
    rect.origin = Vec2(-rect.size.width * 0.2, -rect.size.height * 0.5);
    if ( ! isScreenPointInRect(touchLocation, camera, this->getWorldToNodeTransform(), rect, nullptr))
    {
        return false;
    }
    
    correct_offset = 0;
    scroll_distance.setZero();
    dragging = true;
    touch_point = this->convertTouchToNodeSpace(touch);
    touch_begin_point = this->convertTouchToNodeSpace(touch);
    _touch = touch;
    return true;
}


void UIMenuRound::onTouchEnded(Touch* touch, Event* event) {
    move_offset_x = (this->convertTouchToNodeSpace(_touch) - touch_point).x;
    
    // 矫正目标点
    // 计算多少帧后停止.并计算出长度
    float tmp_heap = scroll_distance.x;
    float frames = 0;
    float distance = 0;
    while (fabsf(tmp_heap) >= SCROLL_DEACCEL_DIST)
    {
        tmp_heap = tmp_heap * SCROLL_DEACCEL_RATE;
        distance += tmp_heap;
        frames++;
    }

    if ( frames > 20 )
    {
        // 将要在这里停下来。
        float end_x = now_place + distance + tmp_heap;
        float modulus = round_length / vec_item.size();
        float overflow = roundLimit(end_x, modulus);
        float dec_point = abs(overflow) > modulus * 0.8 ? (end_x - overflow) + sgn(scroll_distance.x) * modulus : end_x - overflow;
        correct_offset = (dec_point - end_x) / frames;
        this->schedule(CC_SCHEDULE_SELECTOR(UIMenuRound::deaccelerateScrolling));

//        float end_point = now_place + distance + tmp_heap;
//        float interval = round_length / vec_item.size();
//        float round = end_point / interval;
//        float dec_point = round - (int)round;
//        round = (int)round;
//        dec_point = dec_point > 0.5 ? (round + sgn(scroll_distance.x)) * interval : round * interval;
//        correct_offset = (dec_point - end_point) / (frames);
//        this->schedule(CC_SCHEDULE_SELECTOR(UIMenuRound::deaccelerateScrolling));
    }
    else if (! is_appoint)
    {
        this->unschedule(CC_SCHEDULE_SELECTOR(UIMenuRound::deaccelerateScrolling));
        float offset = this->convertTouchToNodeSpace(touch).x - touch_begin_point.x;
        float sgn_num = sgn(offset);
        float interval = round_length / vec_item.size();
        float round = now_place / interval;
        float dec_point = abs(round - (int)round);
        round = (int)round;
        if ( dec_point > 0.1 )
        {
            round = round + (sgn_num > 0 ? 1 : 0);
        }

        dec_point = round * interval;
        stopSomewhere(dec_point);
    }

    dragging = false;
    is_appoint = false;
}

void UIMenuRound::onTouchMoved(Touch* touch, Event* event) {
    Vec2 moveDistance, newPoint;
    newPoint = this->convertTouchToNodeSpace(_touch);
    moveDistance = newPoint - touch_point;
    scroll_distance = moveDistance;
    move_offset_x = scroll_distance.x;
    touch_point = newPoint;
    updateRound(0);
}

void UIMenuRound::onTouchCancel(Touch* touch, Event* event) {
    onTouchEnded(touch, event);
}


void UIMenuRound::setItem(vector<MenuItem*> vec_item) {
    for (auto item : vec_item) {
        item->removeFromParent();
    }
    this->vec_item = vec_item;
    for (auto item : vec_item) {
        this->addChild(item);
    }
    now_place = round_length / vec_item.size();
    updateRound(0);
}

void UIMenuRound::pushItem(MenuItem* item) {
    vec_item.push_back(item);
    menu->addChild(item);
    
    now_place = round_length / vec_item.size();
    updateRound(0);
}

MenuItem* UIMenuRound::getItem(int32_t index) {
    if (index < 0 || index >= vec_item.size()) {
        return NULL;
    }
    return vec_item[index];
}

int32_t UIMenuRound::getItemSize() {
    return (int32_t)vec_item.size();
}


void UIMenuRound::setRoundLength(float length) {
    round_length = length;
    now_place = round_length / vec_item.size();
    updateRound(0);
}

float UIMenuRound::getRoundLength() {
    return round_length;
}

void UIMenuRound::setRoundHeight(float height) {
    round_height = height;
}

void UIMenuRound::setMinScale(float scale) {
    this->min_scale = scale;
}

void UIMenuRound::setMaxScale(float scale) {
    this->max_scale = scale;
}

int32_t UIMenuRound::getSelectIndex() {
    return select_index;
}

void UIMenuRound::setSelected(int32_t index) {
    is_appoint = true;
    
    float offset = round_length - round_length / vec_item.size();
    float dec_point = index * offset;
    stopSomewhere(dec_point);
}

void UIMenuRound::setSelectCallBack(RoundSelectCallback callback) {
    select_callback = callback;
}

void UIMenuRound::openOpacity()
{
    is_open_opacity = true;
}

void UIMenuRound::setMinOpacity(float opacity)
{
    mim_opacity = opacity;
}

void UIMenuRound::updateRound(float dt) {
    if ( vec_item.size() <= 0 ) {
        return;
    }
    float offset = round_length / vec_item.size();
    now_place += (move_offset_x + correct_offset);
    if ( now_place < 0 ) {
        now_place = round_length + now_place;
    } else if ( now_place > round_length ) {
        int fold = now_place / round_length;
        now_place = now_place - fold * round_length;
    }
    now_place = roundLimit(now_place, round_length);
    
    float tmp_coe = M_PI / 180;
    float diameter = round_length / M_PI;
    float radius = diameter * 0.5;
    float tmp_round_length = round_length * 0.25;

    int tmp_zorder = 0;
    int32_t tmp_select_index = select_index;
    for (int i = 0 ; i < vec_item.size() ; ++i)
    {
        float new_point_x = i * offset + now_place;
        new_point_x = roundLimit(new_point_x, round_length);
        float angle = (360.0 * new_point_x / round_length) - 90.0;
        float radian = tmp_coe * (angle);
        float fold_x = tmp_round_length + cos(radian) * radius;
        float fold_y = sin(radian) * radius;
        
        //bool is_top = fold_y <= 0;
        
        // 缩放值计算
        // float scale = is_top ? y_coe : 0;
        float scale = 1 - (fold_y + radius) / (2 * radius);
        int fold_z = scale * 100;
        fold_z = fold_z + i;

        scale = min_scale + (max_scale - min_scale) * scale;
        
        // Z值计算
        //calcMinDistance();
        // int fold_z =  - (fold_y / radius) * 10;

        MenuItem* item = vec_item[i];
        item->setScale(scale);
        item->setPositionX(fold_x);
        item->setPositionY(fold_y * (round_height / radius));
        item->setLocalZOrder(fold_z);
        
        // 设置透明度
        if (is_open_opacity) {
            float opacity = mim_opacity + (255 - mim_opacity) * scale;
            item->setOpacity(opacity);
        }

        if (fold_z > tmp_zorder) {
            tmp_select_index = i;
            tmp_zorder = fold_z;
        }
    }

    if ( select_index != tmp_select_index ) {
        select_index = tmp_select_index;
        if (select_callback) {
            select_callback(select_index);
        }
        
        
        LuaManager::instance()->handleEvent(this, "onItemSelect", [&](LuaStack* ls) {
            ls->pushInt(select_index);
            return 1;
        });
    }
    // [0, round_length * 0.5] 则在最前面
}

void UIMenuRound::deaccelerateScrolling(float dt)
{
    if (dragging)
    {
        this->unschedule(CC_SCHEDULE_SELECTOR(UIMenuRound::deaccelerateScrolling));
        return;
    }
    
    scroll_distance = scroll_distance * SCROLL_DEACCEL_RATE;
    move_offset_x = scroll_distance.x;
    if ((fabsf(scroll_distance.x) <= SCROLL_DEACCEL_DIST))
    {
        this->unschedule(CC_SCHEDULE_SELECTOR(UIMenuRound::deaccelerateScrolling));
    }
    
    updateRound(0);
}

void UIMenuRound::stopSomewhere(float x)
{
    // 计算方向
    x = roundLimit(x, round_length);

    float left_length = 0;
    float right_length = 0;
    calcMinDistance(x, left_length, right_length);

    action_delay = 0;
    move_offset_x = 0;
    correct_offset = 0;
    begin_x = now_place;
    action_distance = right_length < left_length ? right_length : -left_length;    //x - now_place;
    this->unschedule(CC_SCHEDULE_SELECTOR(UIMenuRound::deaccelerateScrolling));
    this->unschedule(schedule_selector(UIMenuRound::scrollToPoint));
    this->schedule(schedule_selector(UIMenuRound::scrollToPoint));
}


void UIMenuRound::scrollToPoint(float dt)
{
    if (dragging) {
        action_delay = 0;
        this->unschedule(schedule_selector(UIMenuRound::scrollToPoint));
        return;
    }

    action_delay += dt;
    if (action_delay > 1)
    {
        action_delay = 1;
        this->unschedule(schedule_selector(UIMenuRound::scrollToPoint));
    }
    
    float time = action_delay;
    time = (time == 1 ? 1 : (-powf(2, -10 * time / 1) + 1));
    now_place = begin_x + action_distance * time;
    updateRound(0);
}

float UIMenuRound::roundLimit(float l, float max) {
    if (max == 0) {
        return 0;
    }
    return fmod(l, max);
}

float UIMenuRound::calcMinDistance(float x, float &left_length, float &right_length) {

    // 往右滑动的距离
    if ( x >= now_place && x <= round_length ) {
        right_length = x - now_place;
    } else {
        right_length = abs((round_length - now_place) + x);
    }

    // 往左滑动的距离
    if (x <= now_place) {
        left_length = now_place - x;
    } else {
        left_length = abs(now_place + (round_length - x));
    }

    if (left_length > right_length) {
        return -left_length;
    } else {
        return right_length;
    }
}











