//
//  DataBuffer.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__DataBuffer__
#define __AVT__DataBuffer__

#include "../Common/CommonDefine.h"

class DataBuffer {
    
public:
    char* buffer;
    int size;
    
    int data_begin;
    int data_end;
    
    DataBuffer(int size);
    ~DataBuffer();
    
    int getDataLength();
    int write(void* buffer, int length);
    int read(void* buffer, int length);
    int get(void* buffer, int length);
    void skipBytes(int length);
    void clear();
};

#endif /* defined(__AVT__DataBuffer__) */
