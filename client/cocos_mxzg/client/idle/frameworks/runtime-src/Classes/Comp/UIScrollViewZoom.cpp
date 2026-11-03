//
//  UIScrollViewZoom.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "UIScrollViewZoom.h"
#include "../Model/LuaManager.h"

#define SCROLL_DEACCEL_RATE  0.85f  // 0.95
#define SCROLL_DEACCEL_DIST  1.0f   // 1.0

UIScrollViewZoom::UIScrollViewZoom() {
    can_handle = true;
    last_touch = 0;
    scrolling = false;
    move_speed = 0.95;
}

UIScrollViewZoom::~UIScrollViewZoom() {
    
}


UIScrollViewZoom* UIScrollViewZoom::create(Size size)
{
    auto pRef = new(std::nothrow)UIScrollViewZoom();
    if (pRef && pRef->initWithViewSize(size)) {
        pRef->autorelease();
        return pRef;
    }
    
    CC_SAFE_DELETE(pRef);
    return NULL;
}


void UIScrollViewZoom::setMinScale(float minScale) {
    _minScale = minScale;
}

float UIScrollViewZoom::getMinScale() {
    return _minScale;
}

void UIScrollViewZoom::setMaxScale(float maxScale) {
    _maxScale = maxScale;
}

float UIScrollViewZoom::getMaxScale() {
    return _maxScale;
}

void UIScrollViewZoom::setMoveSpeed(float speed) {
    this->move_speed = speed;
}

float UIScrollViewZoom::getMoveSpeed() {
    return move_speed;
}

Rect UIScrollViewZoom::getZoomViewRect() {
    return getViewRect();
}

bool UIScrollViewZoom::onTouchBegan(Touch *pTouch, Event *pEvent) {
    if (!this->isVisible()) {
        return false;
    }
    
    if (scrolling) {
        return false;
    }
    
    if (_touches.size() > 2) {
        return false;
    }
    
    if (_touchMoved) {
        //return false;
    }
    
    //CCRect frame;
    //CCPoint frameOriginal = this->getParent()->convertToWorldSpace(this->getPosition());
    //frame = CCRectMake(frameOriginal.x, frameOriginal.y, m_tViewSize.width, m_tViewSize.height);
    Rect frame = getViewRect();
    if (!frame.containsPoint(_container->convertToWorldSpace(_container->convertTouchToNodeSpace(pTouch)))) {
        return false;
    }
    
    bool is_contains = false;
    for (int i = 0; i < _touches.size(); i++) {
        if ((_touches[i] = pTouch)) {
            is_contains = true;
            break;
        }
    }
    if (!is_contains) {
        _touches.push_back(pTouch);
    }
    
    if (_touches.size() == 1) {
        _touchPoint = this->convertTouchToNodeSpace(pTouch);
        _touchMoved = false;
        _dragging = true; //dragging started
        _scrollDistance = Point::ZERO;
        _touchLength = 0.0f;
    } else if (_touches.size() == 2 || _touches.size() == 3) {
        _touchPoint = this->convertTouchToNodeSpace((Touch*)_touches[0]).getMidpoint(this->convertTouchToNodeSpace((Touch*)_touches[1]));
        _touchLength = _container->convertTouchToNodeSpace((Touch*)_touches[0]).getDistance(_container->convertTouchToNodeSpace((Touch*)_touches[1]));
        _dragging  = false;
    }
    
    return true;
}

void UIScrollViewZoom::onTouchMoved(Touch *pTouch, Event *pEvent) {
    if (!this->isVisible()) {
        return;
    }
    
    if (!can_handle) {
        return;
    }
    
    bool is_contains = false;
    for (int i = 0; i < _touches.size(); i++) {
        if ((_touches[i] = pTouch)) {
            is_contains = true;
            break;
        }
    }
    if (!is_contains) {
        return;
    }
    
    if (_touches.size() == 1 && _dragging) {
        Point moveDistance, newPoint, maxInset, minInset;
        Rect frame = getViewRect();
        float newX, newY;
        
        newPoint = this->convertTouchToNodeSpace((Touch*)_touches[0]);
        moveDistance = newPoint - _touchPoint;
        
        float dis = 0.0f;
        if (_direction == ScrollView::Direction::VERTICAL) {
            dis = moveDistance.y;
        } else if (_direction == ScrollView::Direction::HORIZONTAL) {
            dis = moveDistance.x;
        } else {
            dis = sqrtf(moveDistance.x*moveDistance.x + moveDistance.y*moveDistance.y);
        }
        float factor = (Director::getInstance()->getOpenGLView()->getScaleX() + Director::getInstance()->getOpenGLView()->getScaleY()) / 2;
        float inch = dis * factor / Device::getDPI();
        if (!_touchMoved && fabs(inch) < 7.0f / 160.0f) {
            return;
        }
        
        if (!_touchMoved) {
            moveDistance = Point::ZERO;
        }
        
        _touchPoint = newPoint;
        _touchMoved = true;
        
        if (frame.containsPoint(this->convertToWorldSpace(newPoint))) {
            switch (_direction) {
                case ScrollView::Direction::VERTICAL:
                    moveDistance = Vec2(0.0f, moveDistance.y);
                    break;
                case ScrollView::Direction::HORIZONTAL:
                    moveDistance = Vec2(moveDistance.x, 0.0f);
                    break;
                default:
                    break;
            }
            
            maxInset = _maxInset;
            minInset = _minInset;
            
            newX     = _container->getPosition().x + moveDistance.x;
            newY     = _container->getPosition().y + moveDistance.y;
            
            _scrollDistance = moveDistance;
            this->setContentOffset(Vec2(newX, newY));
        }
    } else if ((_touches.size() == 2 || _touches.size() == 3) && !_dragging) {
        const float len = _container->convertTouchToNodeSpace((Touch*)_touches[0]).getDistance(_container->convertTouchToNodeSpace((Touch*)_touches[1]));
        
        this->setZoomScale(this->getZoomScale() * len / _touchLength);
    }
}

void UIScrollViewZoom::onTouchEnded(Touch *pTouch, Event *pEvent) {
    if (!this->isVisible()) {
        return;
    }
    
    for (vector<Touch*>::iterator iter = _touches.begin(); iter != _touches.end(); ++iter) {
        if (*iter == pTouch) {
            if (_touches.size() == 1) {
                this->schedule(schedule_selector(UIScrollViewZoom::deaccelerateScrolling));
            }
            
            _touches.erase(iter);
            
            if (_touches.size() == 1) {
                // 还剩下一个手指，激活拖动
                _dragging = true;
                _touchPoint = this->convertTouchToNodeSpace((Touch*)_touches[0]);
            } else {
                _dragging = false;
            }
            
            break;
        }
    }
    
    if (_touches.size() == 0) {
        _dragging = false;
        _touchMoved = false;
    }
    
    
    // 当超过/等于最大显示缩放时就返回到最大显示缩放值
    if (_container->getScale() >= showMaxScale && _container->getScale() <= _maxScale) {
        setZoomScale(showMaxScale, true);
    }
    
    // 当超过/等于最小显示缩放值时就反回到最小显示缩放值
    if (_container->getScale() >= _minScale && _container->getScale() <= showMinScale) {
        setZoomScale(showMinScale, true);
    }
}

void UIScrollViewZoom::onTouchCancelled(Touch *touch, Event *event) {
    onTouchEnded(touch, event);
}


bool UIScrollViewZoom::isDoubleTouch() {
    bool b = false;
    int64_t now = Game::millisecond();
    if (now - last_touch < 200) {
        b = true;
    }
    last_touch = now;
    return b;
}

void UIScrollViewZoom::setContentOffsetInDuration(Point offset, float dt) {
    ScrollView::setContentOffsetInDuration(offset, dt);
    scrolling = true;
}

void UIScrollViewZoom::stoppedAnimatedScroll(Node * node) {
    ScrollView::stoppedAnimatedScroll(node);
    scrolling = false;
}


void UIScrollViewZoom::deaccelerateScrolling(float dt) {
    if (_dragging)
    {
        this->unschedule(CC_SCHEDULE_SELECTOR(UIScrollViewZoom::deaccelerateScrolling));
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
        this->unschedule(CC_SCHEDULE_SELECTOR(UIScrollViewZoom::deaccelerateScrolling));
        this->relocateContainer(true);
    }
}

void UIScrollViewZoom::setSwallowsTouches(bool b) {
    _touchListener->setSwallowTouches(b);
}


UIScrollViewZoom* UIScrollViewBackpackLoader::createNode(cocos2d::Node * pParent, cocosbuilder::CCBReader * ccbReader) {
//    CSJson::Value json;
//    json["class_name"] = "UIScrollViewBackpack";
//    auto node = LuaManager::instance()->executeGlobalNodeFunctionReturn("changeMainSceneLayer", json);
//    return (UIScrollViewZoom*)node;
    
//    CSJson::Value json;
//    json["node_name"] = "xx";
//    LuaManager::instance()->executeGlobalNodeFunctionReturn("createLuaNode", json);
    CSJson::Value json;
    json["class_name"] = "UIScrollViewBackpack";
    auto node = LuaManager::instance()->executeGlobalNodeFunctionReturn("createBuilderNode", json);
    return (UIScrollViewZoom*)node;
}
