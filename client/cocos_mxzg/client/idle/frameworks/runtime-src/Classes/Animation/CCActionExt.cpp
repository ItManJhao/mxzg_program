//
//  CCActionExt.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "CCActionExt.h"
//#include "Person.h"
#include "../Model/Game.h"
#include "../Person/Unit.h"
#include "ShaderFactory.h"

#pragma mark -------CCEclipse--------

CCEclipse::CCEclipse() {
    m_isRotate = false;
    m_startrotation = 0;
}

CCEclipse * CCEclipse::create(float duration, const Point& orgin, float a, float b) {
    CCEclipse * result = new CCEclipse();
    result->initWithDuration(duration, orgin, a, b);
    result->autorelease();
    return result;
}

void CCEclipse::startWithTarget(cocos2d::Node *pTarget) {
    ActionInterval::startWithTarget(pTarget);
}

bool CCEclipse::initWithDuration(float duration, const Point& orgin, float a, float b) {
    if (ActionInterval::initWithDuration(duration)) {
        m_orgin = orgin;
        m_a = a;
        m_b = b;
        return true;
    }
    return false;
}

void CCEclipse::setIsRotated(bool value) {
    m_isRotate = value;
}

void CCEclipse::setStartRotation(float r) {
    m_startrotation = r;
}

void CCEclipse::update(float time) {
//    if (m_pTarget) {
//        //这里的time就相当于当前时间占总的需要运行时间的百分比
//        
//        //这里根据椭圆标准方程来设定轨迹：(x - x0) * (x - x0) / a*a + (y - y0) * (y - y0) / b * b = 1。
//        CCPoint oldP = m_pTarget->getPosition();
//        float X = m_orgin.x +  m_a * cos( 2 * M_PI * (time + m_startrotation));
//        float Y = m_orgin.y + m_b * sin( 2 * M_PI * (time + m_startrotation));
//        m_pTarget->setPosition(X, Y);
//        
//        if (m_isRotate) {
//            CCPoint newP = m_pTarget->getPosition();
//            float distX = newP.x - oldP.x;
//            float distY = newP.y - oldP.y;
//            float angleDes = 180 + (90 - 180 * atan2(distY, distX) / 3.14);
//            m_pTarget->setRotation(angleDes);
//        }
//    }
}


#pragma mark -------CCPlayEffect--------

CCPlayEffect::CCPlayEffect() {
    sound = "";
}

CCPlayEffect * CCPlayEffect::create(const char* sound) {
    CCPlayEffect * result = new CCPlayEffect();
    result->sound = sound;
    result->autorelease();
    return result;
}

void CCPlayEffect::update(float time) {
    Game::playEffect(sound.c_str());
}

#pragma mark -------CCDampedTo--------
DampedTo* DampedTo::create(const float& duration, const float& s, const float& r, const float& f)
{
    DampedTo *dampedTo = new (std::nothrow) DampedTo();
    dampedTo->initWithDuration(duration, s,r,f);
    dampedTo->autorelease();
    return dampedTo;
}

bool DampedTo::initWithDuration(const float& duration, const float& s, const float& r, const float& f)
{
    if (ActionInterval::initWithDuration(duration))
    {
        endScale = s;
        this->ratio = r;
        this->frequency = f;
        return true;
    }
    return false;
}

DampedTo* DampedTo::clone() const
{
    // no copy constructor
    auto a = new (std::nothrow) DampedTo();
    a->initWithDuration(_duration,1.0,ratio,frequency);
    a->autorelease();
    return a;
}

DampedTo* DampedTo::reverse() const
{
    CCASSERT(false, "reverse() not supported in ScaleTo");
    return nullptr;
}


void DampedTo::startWithTarget(Node *target)
{
    ActionInterval::startWithTarget(target);
    beginScale = target->getScale();
    finalScale = endScale - beginScale;
}
void DampedTo::update(float time)
{
    if (_target)
    {
        float value = finalScale - pow(2.718281828459, this->ratio * time) * cos(this->frequency * time) ;
        value = ceil(value * 1000) * 0.001 + beginScale;
        _target->setScale(value);
    }
}


DampedToY* DampedToY::create(const float& duration, const float& s, const float& r, const float& f)
{
    DampedToY *dampedTo = new (std::nothrow) DampedToY();
    dampedTo->initWithDuration(duration, s,r,f);
    dampedTo->autorelease();
    return dampedTo;
}

bool DampedToY::initWithDuration(const float& duration, const float& s, const float& r, const float& f)
{
    if (ActionInterval::initWithDuration(duration))
    {
        endScale = s;
        this->ratio = r;
        this->frequency = f;
        return true;
    }
    return false;
}

DampedToY* DampedToY::clone() const
{
    // no copy constructor
    auto a = new (std::nothrow) DampedToY();
    a->initWithDuration(_duration,1.0,ratio,frequency);
    a->autorelease();
    return a;
}

DampedToY* DampedToY::reverse() const
{
    CCASSERT(false, "reverse() not supported in ScaleTo");
    return nullptr;
}


void DampedToY::startWithTarget(Node *target)
{
    ActionInterval::startWithTarget(target);
    beginScale = target->getScale();
    finalScale = endScale - beginScale;
}

void DampedToY::update(float time)
{
    if (_target)
    {
        float value = finalScale - pow(2.718281828459, this->ratio* time) * cos(this->frequency * time) ;
        value = ceil(value * 1000) * 0.001 + beginScale;
        //log("time = %f, scale = %f , beginScale = %f",time, value , beginScale);
        _target->setScaleY(value);
    }
}

Gray::Gray() {
    _glProgramState = NULL;
}

Gray *Gray::create(const float &duration) {
    Gray *gray = new (std::nothrow) Gray();
    gray->initWithDuration(duration);
    gray->autorelease();
    return gray;
}

Gray *Gray::reverse(void) const {
    CCASSERT(false, "reverse() not supported in ScaleTo");
    return NULL;
}

void Gray::startWithTarget(Node *target) {
    ActionInterval::startWithTarget(target);

    auto program = new GLProgram();
    program->initWithFilenames("shader/default.vsh", "shader/grayuniform.fsh");
    program->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_POSITION, GLProgram::VERTEX_ATTRIB_POSITION);
    program->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_COLOR, GLProgram::VERTEX_ATTRIB_COLOR);
    program->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_TEX_COORD, GLProgram::VERTEX_ATTRIB_TEX_COORD);

    program->link();
    program->updateUniforms();

    _glProgramState = GLProgramState::create(program);
    _glProgramState->retain();
    target->setGLProgramState(_glProgramState);

    unf_changing = glGetUniformLocation(_glProgramState->getGLProgram()->getProgram(), "changing");
    _glProgramState->setUniformFloat(unf_changing, 0);
}

void Gray::update(float time) {
    if (_target) {
        _glProgramState->getGLProgram()->use();
        _glProgramState->setUniformFloat(unf_changing, time);
    }
}

Gray *Gray::clone() const {
    // no copy constructor
    auto a = Gray::create(_duration);
    a->setTag(getTag());
    return a;
}

Gray::~Gray() {

    if (_target) {
        _target->setGLProgram(ShaderFactory::instance()->getGLProgram(ST_POSITION_TEXTURE_GRAY));
    }

    if (_glProgramState) {
        auto program = _glProgramState->getGLProgram();
        CC_SAFE_RELEASE(program);
        CC_SAFE_RELEASE(_glProgramState);
    }
    _glProgramState = NULL;
}


