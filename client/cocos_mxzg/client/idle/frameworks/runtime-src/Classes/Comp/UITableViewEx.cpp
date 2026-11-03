#include "UITableViewEx.h"

#define SCROLL_DEACCEL_DIST  1.0f


UITableViewEx::UITableViewEx()
{
    move_speed = 0.95;
}


UITableViewEx* UITableViewEx::create(Size view_size)
{
    UITableViewEx *table = new (std::nothrow) UITableViewEx();
    table->initWithViewSize(view_size, NULL);
    table->autorelease();
    // table->setDataSource(NULL);
    //table->_updateCellPositions();
    //table->_updateContentSize();
    return table;
}

void UITableViewEx::onTouchEnded(Touch *pTouch, Event *pEvent)
{
    if (!this->isVisible()) {
        return;
    }
    
    if (_touchedCell){
        Rect bb = this->getBoundingBox();
        bb.origin = _parent->convertToWorldSpace(bb.origin);
        
        if (bb.containsPoint(pTouch->getLocation()) && _tableViewDelegate != nullptr)
        {
            _tableViewDelegate->tableCellUnhighlight(this, _touchedCell);
            _tableViewDelegate->tableCellTouched(this, _touchedCell);
        }
        
        _touchedCell = nullptr;
    }
    
    onScrollViewTouchEnded(pTouch, pEvent);
}


void UITableViewEx::onScrollViewTouchEnded(Touch* touch, Event* event)
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
            this->schedule(CC_SCHEDULE_SELECTOR(UITableViewEx::deaccelerateScrolling));
        }
        _touches.erase(touchIter);
    }
    
    if (_touches.size() == 0)
    {
        _dragging = false;
        _touchMoved = false;
    }
}

void UITableViewEx::setMoveSpeed(float speed) {
    this->move_speed = speed;
}

float UITableViewEx::getMoveSpeed() {
    return move_speed;
}

void UITableViewEx::deaccelerateScrolling(float dt) {
    if (_dragging)
    {
        this->unschedule(CC_SCHEDULE_SELECTOR(UITableViewEx::deaccelerateScrolling));
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
    
    _scrollDistance     = _scrollDistance * move_speed;
    this->setContentOffset(Vec2(newX, newY));
    
    if ((fabsf(_scrollDistance.x) <= SCROLL_DEACCEL_DIST &&
         fabsf(_scrollDistance.y) <= SCROLL_DEACCEL_DIST) ||
        ((_direction == Direction::BOTH || _direction == Direction::VERTICAL) && (newY >= maxInset.y || newY <= minInset.y)) ||
        ((_direction == Direction::BOTH || _direction == Direction::HORIZONTAL) && (newX >= maxInset.x || newX <= minInset.x)))
    {
        this->unschedule(CC_SCHEDULE_SELECTOR(UITableViewEx::deaccelerateScrolling));
        this->relocateContainer(true);
    }
}
