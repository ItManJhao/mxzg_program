//
//  SingleInstance.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__SingleInstance__
#define __AVT__SingleInstance__

#include "CommonDefine.h"
#pragma optimize( "", off )
template<class T> class SingleInstance
{
public:
//    T();
    static T* instance()
    {
        if (!_instance)
        {
//            _instance = (T*)malloc(sizeof(T));
//            _instance->constructor();
            _instance = new T;
        }
        return _instance;
    }
    static T* _instance;


    ~SingleInstance<T>()
    {
        if (this == SingleInstance<T>::_instance) {
            SingleInstance<T>::_instance = 0;
        }
    }
};

template<typename T>
T* SingleInstance<T>::_instance = 0;
#pragma optimize( "", on )

#endif /* defined(__AVT__SingleInstance__) */
