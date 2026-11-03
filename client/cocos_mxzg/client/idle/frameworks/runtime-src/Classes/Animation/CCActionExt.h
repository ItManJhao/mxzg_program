//
//  CCActionExt.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__CCActionExt__
#define __AVT__CCActionExt__

#include "../Common/CommonDefine.h"


class Unit;

#pragma mark -------CCEclipse--------
class  CCEclipse : public ActionInterval {
public:
    CCEclipse();
    
    //初始化action
    bool initWithDuration(float duration, const Point& orgin, float a, float b);
    virtual void startWithTarget(Node *pTarget);
    virtual void update(float time);
    
    //类似引擎的对象创建构造，duration表示运动一周的时间，orgin表示圆心坐标，a/b分别表示椭圆长半轴和短半轴，a = b时，显然，轨迹是一个标准圆
    static CCEclipse * create(float duration, const Point& orgin, float a, float b);
    
    //设置对象是否根据圆曲线进行旋转
    void setIsRotated(bool value);
    
    //设置初始旋转角度
    void setStartRotation(float r);
private:
    bool m_isRotate;
    Point m_orgin;
    float m_a;
    float m_b;
    float m_startrotation;
};


#pragma mark -------CCEclipse--------
class  CCPlayEffect : public ActionInstant {
public:
    CCPlayEffect();
    
    virtual void update(float time);
    
    static CCPlayEffect * create(const char* sound);
    
private:
    string sound;
};


#pragma mark -------CCDampedTo--------

class DampedTo : public ActionInterval
{
public:
    static DampedTo* create(const float& duration, const float& s, const float& r = -7, const float& f = 30.0);
    
    virtual DampedTo* reverse(void) const override;
    virtual void startWithTarget(Node *target) override;
    
    virtual void update(float time) override;
    virtual DampedTo* clone() const override;
    
CC_CONSTRUCTOR_ACCESS:
    DampedTo() {}
    virtual ~DampedTo() {}
    bool initWithDuration(const float& duration, const float& s, const float& r, const float& f);
    
protected:
    float ratio = -7;
    float frequency = 30;
    float finalScale = 1.0;
    float beginScale;
    float endScale = 1.0;
private:
    CC_DISALLOW_COPY_AND_ASSIGN(DampedTo);
};


class DampedToY : public ActionInterval
{
public:
    static DampedToY* create(const float& duration, const float& s, const float& r = -7, const float& f = 30.0);
    
    virtual DampedToY* reverse(void) const override;
    virtual void startWithTarget(Node *target) override;
    
    virtual void update(float time) override;
    virtual DampedToY* clone() const override;
    
CC_CONSTRUCTOR_ACCESS:
    DampedToY() {}
    virtual ~DampedToY() {}
    bool initWithDuration(const float& duration, const float& s, const float& r, const float& f);
    
protected:
    float ratio = -7;
    float frequency = 30;
    float finalScale = 1.0;
    float beginScale;
    float endScale = 1.0;
private:
    CC_DISALLOW_COPY_AND_ASSIGN(DampedToY);
};


class Gray : public ActionInterval
{
public:
    static Gray* create(const float& duration);

    virtual Gray* reverse(void) const override;
    virtual void startWithTarget(Node *target) override;

    virtual void update(float time) override;
    virtual Gray* clone() const override;

CC_CONSTRUCTOR_ACCESS:
    Gray();
    virtual ~Gray();
protected:
    int unf_changing;
    GLProgramState* _glProgramState;
private:
    CC_DISALLOW_COPY_AND_ASSIGN(Gray);
};

#endif /* defined(__AVT__CCActionExt__) */
