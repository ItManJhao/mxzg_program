//
//  Maths.h
//  cleck
//
//  Created by apple on 2018/10/5.
//

#ifndef Maths_h
#define Maths_h

#include <iostream>
#include <random>
#include <iostream>
#include <ctime>

class Maths
{
public:
    
    //
    static float clamp(float value, const float& min, const float& max);
    
    // 缓动函数
    /*
     * 如果 current 跟 target 一样。则前7秒返回的值都是 target
     * 如果 maxSpeed 值过小的时候。。产生的结果是曲线的。一般取浮点数最大值
     */
    static float smoothDamp(float current,
                            float target,
                            float& currentVelocity,
                            float smoothTime,
                            float maxSpeed,
                            float deltaTime);
    
    static int random_unint(unsigned int min, unsigned int max, unsigned int seed = 0);
    
    static bool isLeap(int year);
    static long long getDays(int32_t time_stamp);
    
    static bool randTrigger(int32_t rand_range, int32_t value);
    static bool randomTrigger(int32_t rand_range, int32_t value, int32_t time);
};


#endif /* Maths_h */
