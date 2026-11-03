//
//  Maths.cpp
//  cleck
//
//  Created by apple on 2018/10/5.
//

#include "Maths.h"
#include "cocos2d.h"
#include <time.h>

float Maths::clamp(float value, const float& min, const float& max)
{
    if (value < min)
    {
        value = min;
    }
    else if (value > max)
    {
        value = max;
    }
    return value;
}


float Maths::smoothDamp(float current,
                        float target,
                        float& currentVelocity,
                        float smoothTime,
                        float maxSpeed,
                        float deltaTime)
{
    smoothTime = MAX(0.0001f, smoothTime);
    float num = 2.0f / smoothTime;
    float num2 = num * deltaTime;
    float num3 = 1.0f / (1.0f + num2 + 0.48f * num2 * num2 + 0.235f * num2 * num2 * num2);
    float num4 = current - target;
    float num5 = target;
    float num6 = maxSpeed * smoothTime;
    num4 = Maths::clamp(num4, -num6, num6);
    target = current - num4;
    float num7 = (currentVelocity + num * num4) * deltaTime;
    
    currentVelocity = (currentVelocity - num * num7) * num3;
    
    float num8 = target + (num4 + num7) * num3;
    if (num5 - current > 0.0f == num8 > num5)
    {
        num8 = num5;
        currentVelocity = (num8 - num5) / deltaTime;
    }
    return num8;
}


bool Maths::isLeap(int year)
{
    if (year%400==0) return true;
    if (year%100==0) return false;
    if (year%4==0) return true;
    return false;
}

long long Maths::getDays(int32_t  time_stamp)
{
    int num[13]={0,31,28,31,30,31,30,31,31,30,31,30,31};  //平年每月的天数
    
    time_t lt = time_stamp;
    auto tmp_day = localtime(&lt);
    
    int y = tmp_day->tm_year;
    int m = tmp_day->tm_mon + 1;
    int d = tmp_day->tm_mday;
    
    y--;
    long long ret=365ll*y + y/4-y/100 + y/400 +d;
    
    // cocos2d::log("Maths.getDays1 = %lld, %d, %d, %d", ret, y, m, d);
    for (int i = 1; i < m; i++)
    {
        ret += num[i];
        if ( i==2 && isLeap(y+1) ) ret++;
    }
    return ret;
}

bool Maths::randTrigger(int32_t rand_range, int32_t value)
{
    int32_t percent = rand() % rand_range;
    return percent < value;
}


int Maths::random_unint(unsigned int min, unsigned int max, unsigned int seed)
{
//    std::default_random_engine e(seed);
//    std::uniform_int_distribution<int> u(min, max);
//    return u(e);
    
//    std::random_device rd;
    std::mt19937 gen(seed);
    std::uniform_int_distribution<> dis(min, max-1);
    
    return dis(gen);
}

bool Maths::randomTrigger(int32_t rand_range, int32_t value, int32_t time)
{
//    srand(time);
//    int32_t percent = rand() % rand_range;
//    CCLOG("percent=%d", percent);
//    return percent < value;
    
    int32_t percent = random_unint(0, 10000, time);
    return percent < value;
}


