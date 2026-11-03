//
//  UIScrollViewBlownEx.cpp
//  Editorer
//
//  Created by windy on 2017/9/30.
//

#include "UIScrollViewBlownEx.h"

#define SCROLL_DEACCEL_RATE  0.85f  // 0.95
#define SCROLL_DEACCEL_DIST  1.0f   // 1.0
#define BOUNCE_DURATION      0.1f   // 0.15
#define INSET_RATIO          0.2f   // 0.2
#define MOVE_INCH            7.0f/160.0f
#define ZOOM_DURATION        0.3f   // 自己加的，默认0.15

// 自定
#define SPEED_MIN            15


UIScrollViewBlownEx::UIScrollViewBlownEx()
: delegate(NULL)
, min_scale(1)
, max_scale(1)
, distance_scale(500)
, is_touch_item(false)
, select_index(-1)
, auto_select_func(NULL)
, min_offset(0)
, menu(NULL)
{
    
}

UIScrollViewBlownEx* UIScrollViewBlownEx::create(Size view_size)
{
    UIScrollViewBlownEx* pRef = new(std::nothrow) UIScrollViewBlownEx();
    if ( pRef && pRef->initWithSize(view_size) ) {
        pRef->autorelease();
        return pRef;
    }
    CC_SAFE_DELETE(pRef);
    return NULL;
}

bool UIScrollViewBlownEx::initWithSize(Size view_size)
{
    if ( ! this->initWithViewSize(view_size) ) return false;
    setDelegate(this);
    setDirection(cocos2d::extension::ScrollView::Direction::VERTICAL);
    // setBounceable(false);
    
    menu = UIMenu::create();
    menu->setSwallowsTouches(false);
    menu->setPosition(Vec2::ZERO);
    getContainer()->addChild(menu);
    
    return true;
}

void UIScrollViewBlownEx::updateTweenAction(float value, const std::string& key)
{
    ScrollView::updateTweenAction(value, key);
}

void UIScrollViewBlownEx::onTouchEnded(Touch* touch, Event* event)
{
    if (!this->isVisible())
    {
        return;
    }
    
    auto touchIter = std::find(_touches.begin(), _touches.end(), touch);
    
    if (touchIter != _touches.end())
    {
        if (_touches.size() == 1 && _touchMoved)
        {
            this->unschedule(CC_SCHEDULE_SELECTOR(UIScrollViewBlownEx::scrollToPoint));
            this->schedule(CC_SCHEDULE_SELECTOR(UIScrollViewBlownEx::deaccelerateScrolling));
        }
        _touches.erase(touchIter);
    }
    
    if (_touches.size() == 0)
    {
        _dragging = false;
        _touchMoved = false;
    }
}

void UIScrollViewBlownEx::deaccelerateScrolling(float dt)
{
    if (_dragging)
    {
        this->unschedule(CC_SCHEDULE_SELECTOR(UIScrollViewBlownEx::deaccelerateScrolling));
        return;
    }
    
    float newX, newY;
    Vec2 maxInset, minInset;
    
    _container->setPosition(_container->getPosition() + _scrollDistance);
    
    if (_bounceable)
    {
        maxInset = _maxInset;
        minInset = _minInset;
    }
    else
    {
        maxInset = this->maxContainerOffset();
        minInset = this->minContainerOffset();
    }
    
    newX = _container->getPosition().x;
    newY = _container->getPosition().y;
    // 新加1
    float speed_offset = _scrollDistance.y;
    _scrollDistance     = _scrollDistance * SCROLL_DEACCEL_RATE;
    this->setContentOffset(Vec2(newX,newY));
    
    if ((fabsf(_scrollDistance.x) <= SCROLL_DEACCEL_DIST &&
         fabsf(_scrollDistance.y) <= SCROLL_DEACCEL_DIST) ||
        ((_direction == Direction::BOTH || _direction == Direction::VERTICAL) && (newY >= maxInset.y || newY <= minInset.y)) ||
        ((_direction == Direction::BOTH || _direction == Direction::HORIZONTAL) && (newX >= maxInset.x || newX <= minInset.x)))
    {
        this->unschedule(CC_SCHEDULE_SELECTOR(UIScrollViewBlownEx::deaccelerateScrolling));
        this->relocateContainer(true);
    }
    
    // 新加
    speed_offset = fabsf(speed_offset - _scrollDistance.y);
    if ( abs(_scrollDistance.y) <= m_speed_y && speed_offset < m_speed_offset) {
        scrollViewWillStop(_scrollDistance);
    }
}

void UIScrollViewBlownEx::scrollViewDidScroll(ScrollView* view)
{
    // 禁止滑出视图
    Vec2 content_offset = getContentOffset();
    if ( min_offset < 0 ) {
        content_offset.y = clampf(content_offset.y, MAX(getViewSize().height - getContentSize().height, min_offset), 0);
        getContainer()->setPosition(content_offset);
    }
    
    float mid_y = -(content_offset.y - getViewSize().height * 0.5);
    for (int i = 0 ; i < vec_item.size() ; ++i)
    {
        MenuItem* item = vec_item[i];
        // 不在视图之内
        if ( ! isNodeVisible(item) ) {
            continue;
        }
        
        float scale =  MIN(abs(item->getPositionY() - mid_y), distance_scale);
        scale = min_scale + (max_scale - min_scale) * ((distance_scale - scale) / distance_scale);
        item->setScale(scale);
        if (scale > (max_scale - 0.1)) {
            if (select_item != item) {
                select_item = item;
                select_index = i;
                if (auto_select_func) {
                    auto_select_func(this, i);
                }
            }
        }
    }
    
    if (delegate) delegate->scrollViewDidScroll(view);
}

void UIScrollViewBlownEx::scrollViewDidZoom(ScrollView* view)
{
    if ( delegate ) delegate->scrollViewDidZoom(this);
}

void UIScrollViewBlownEx::scrollViewWillStop(Vec2 speed)
{
    float min_distance = -50 + 50 * abs(speed.y / SPEED_MIN);
    Vec2 content_offset = getContentOffset();
    float mid_y = -(content_offset.y - getViewSize().height * 0.5);
    float tmp_distance = distance_scale;
    Node* end_point_node = NULL;
    
    if (speed.x == 0 && speed.y == 0)
    {
        if ( is_touch_item )
        {
            is_touch_item = ! is_touch_item;
            return;
        }
        
        // 玩家让滚动视图停止了.
        for (auto item : vec_item)
        {
            float distance = fabsf(item->getPositionY() - mid_y);
            if (distance < tmp_distance)
            {
                tmp_distance = distance;
                end_point_node = item;
            }
        }
    }
    else
    {
        
        // 自然滚动停止
        if (fabsf(speed.y) < 3)
        {
            stopScrollAnimation();
        }
        
        for (auto item : vec_item)
        {
            if ( speed.y < 0 )
            {
                if ( item->getPositionY() < mid_y )
                {
                    continue;
                }
            }
            else
            {
                if (item->getPositionY() > mid_y) {
                    continue;
                }
            }
            float distance = fabsf( item->getPositionY() - mid_y );
            if (distance > min_distance && distance < distance_scale)
            {
                if (distance < tmp_distance)
                {
                    tmp_distance = distance;
                    end_point_node = item;
                }
            }
            
        }
    }
    
    if (end_point_node != NULL)
    {
        stopSomewhere(   Vec2(0, getViewSize().height * 0.5 - end_point_node->getPositionY())   );
        select_item = end_point_node;
        if (select_func)
        {
            select_func(this, getSelectIndex(end_point_node));
        }
        // updateReward();
    }
}

void UIScrollViewBlownEx::stopScrollAnimation()
{
    this->unschedule(CC_SCHEDULE_SELECTOR(UIScrollViewBlownEx::deaccelerateScrolling));
}

void UIScrollViewBlownEx::setItemScale(float min_scale, float max_scale)
{
    this->min_scale = min_scale;
    this->max_scale = max_scale;
}

void UIScrollViewBlownEx::setItemOffset(float offset)
{
    item_offset = offset;
}

void UIScrollViewBlownEx::setScaleDistance(float distance)
{
    distance_scale = distance;
}

void UIScrollViewBlownEx::setDidStopSpeed(float speed_y, float offset_max)
{
    m_speed_y = speed_y;
    m_speed_offset = offset_max;
}

void UIScrollViewBlownEx::setSelect(int index, bool animation)
{
    CCASSERT(index < vec_item.size(), "");

    Node* item = vec_item[index];
    if ( animation )
    {
        stopSomewhere( Vec2(0, getViewSize().height * 0.5 - item->getPositionY()) );
    }
    else
    {
        setContentOffset(Vec2(getContentOffset().x, getViewSize().height * 0.5 - item->getPositionY()));
    }
    select_index = index;
}

void UIScrollViewBlownEx::setMinSelect(int32_t index)
{
    CCASSERT(index < vec_item.size(), "");
    
    Node* item = vec_item[index];
    min_offset = getViewSize().height * 0.5 - item->getPositionY();
    
    if ( index < select_index )
    {
        setSelect(index, false);
    }
}


void UIScrollViewBlownEx::setSelectCallBack(const std::function<void (UIScrollViewBlownEx*, int)> &func)
{
    select_func = func;
}

void UIScrollViewBlownEx::setAutoSelectCallBack(const std::function<void (UIScrollViewBlownEx*, int)> &func)
{
    auto_select_func = func;
}

// 惯性滚动到某个位置停下来..不可以在静止状态时调用这个函数
void UIScrollViewBlownEx::stopSomewhere(Vec2 offset)
{
    action_time = 0;
    begin_y = getContentOffset().y;
    distance_offset = offset.y - begin_y;
    
    this->unschedule(CC_SCHEDULE_SELECTOR(UIScrollViewBlownEx::scrollToPoint));
    this->schedule(CC_SCHEDULE_SELECTOR(UIScrollViewBlownEx::scrollToPoint));
}


void UIScrollViewBlownEx::scrollToPoint(float dt)
{
    action_time += dt;
    if (action_time > 1) {
        action_time = 1;
        //this->unschedule("scrollToPoint");
        this->unschedule(CC_SCHEDULE_SELECTOR(UIScrollViewBlownEx::scrollToPoint));
        stopScrollAnimation();
    }
    float time = action_time;
    time = (time == 1 ? 1 : (-powf(2, -10 * time / 1) + 1));
    float offset = begin_y + distance_offset * time;
    setContentOffset(Vec2(getContentOffset().x , offset));
}

int UIScrollViewBlownEx::getSelectIndex(Node* node)
{
    for (int i = 0 ; i < vec_item.size() ; ++i)
    {
        if (vec_item[i] == node)
        {
            return i;
        }
    }
    return -1;
}


void UIScrollViewBlownEx::updateView()
{
    if (vec_item.size() <= 0) {
        return;
    }
    
    Size item_size = vec_item[0]->getContentSize();
    float margin = getViewSize().height * 0.5 - item_size.height * 0.5;
    for (int i = 0 ; i < vec_item.size() ; ++i)
    {
        MenuItem* item = vec_item[i];
        item->setPosition(getViewSize().width * 0.5,
                          margin + item_size.height * 0.5 + (item_size.height + item_offset) * i);
    }
    
    float height = (item_size.height + item_offset) * vec_item.size() + margin * 2 - item_offset;
    setContentSize(Size(getContentSize().width,
                        MAX(height, getViewSize().height)));

    scrollViewDidScroll(this);
}

void UIScrollViewBlownEx::addItem(MenuItem* item)
{
    vec_item.push_back(item);
    menu->addChild(item);
}

int UIScrollViewBlownEx::getSelect()
{
    return select_index;
}

int UIScrollViewBlownEx::getItemCount() {
    return (int)vec_item.size();
}

