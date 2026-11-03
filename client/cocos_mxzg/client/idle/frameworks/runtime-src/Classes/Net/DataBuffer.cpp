//
//  DataBuffer.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "DataBuffer.h"

DataBuffer::DataBuffer(int size) {
    this->size = size;
    buffer = static_cast<char*>(malloc(this->size));
    
    data_begin = 0;
    data_end = 0;
}

DataBuffer::~DataBuffer() {
    free(buffer);
}

int DataBuffer::getDataLength() {
	return data_end - data_begin;
}

int DataBuffer::write(void* buffer, int length) {
    int data_length = getDataLength(); // 已经有数据的长度
    if (data_length + length > size) {
        return 0;
    }
    
    if (data_end + length > size) {
        if (data_length <= 0) {
            data_begin = 0;
            data_end = 0;
        } else {
            memcpy(this->buffer, this->buffer + data_begin, data_length);
            data_begin = 0;
            data_end = data_length;
        }
    }
    
    memcpy(this->buffer + data_end, buffer, length);
    data_end += length;
    
    return length;
}

int DataBuffer::read(void* buffer, int length) {
    int len = get(buffer, length);
    skipBytes(len);
    return len;
}

int DataBuffer::get(void* buffer, int length) {
    if (length > getDataLength()) {
        return 0;
    }
    
    memcpy(buffer, this->buffer + data_begin, length);
    return length;
}

void DataBuffer::skipBytes(int length) {
    data_begin += length;
}

void DataBuffer::clear() {
    // memset(buffer, 0, size);
    data_begin = 0;
    data_end = 0;
}
