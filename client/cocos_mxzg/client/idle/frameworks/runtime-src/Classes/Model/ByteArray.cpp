//
//  ByteArray.cpp
//  idle
//
//  Created by hua on 2019/3/16.
//

#include "ByteArray.h"

#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h> //Only she can resolve this problem

#include "../Ctrl/Scene/MainSceneCtr.h"

ByteArray::ByteArray()
{
    resetPos();
}


void ByteArray::resetPos() {
    pos = 1;
}

ByteArray* ByteArray::create()
{
    ByteArray* ba = new(std::nothrow) ByteArray();
    if (ba) {
        ba->autorelease();
        return ba;
    }
    
    CC_SAFE_DELETE(ba);
    return NULL;
}

void ByteArray::pushData(void* data, int32_t lenght)
{
    str_data.append((const char*)data, lenght);
    //log("ByteArray::pushData str_data.size() = %lu", str_data.size());
}


bool ByteArray::readBool()
{
    bool result = false;
    if (pos <= str_data.size() && str_data.size() >= pos) {
        const char* data = str_data.c_str();
        memcpy(&result, data + pos - 1, sizeof(bool));
        pos += 1;
    } else {
        CCASSERT(false, "ByteArray::readBool");
    }
    return result;
}

void ByteArray::writeBool(bool value)
{
    str_data.append((const char*)&value, sizeof(value));
}

char ByteArray::readByte()
{
    char result = 0;
    if (pos <= str_data.size() && str_data.size() >= pos) {
        const char* data = str_data.c_str();
        memcpy(&result, data + pos - 1, sizeof(char));
        pos += 1;
    } else {
        CCASSERT(false, "ByteArray::readByte");
    }
    return result;
}

void ByteArray::writeByte(char value)
{
    str_data.append((const char*)&value, sizeof(value));
}

int32_t ByteArray::readInt8()
{
    int8_t result = 0;
    if (pos <= str_data.size() && str_data.size() >= pos) {
        const char* data = str_data.c_str();
        memcpy(&result, data + pos - 1, sizeof(int8_t));
        pos += 1;
    } else {
        CCASSERT(false, "ByteArray::readInt8");
    }
    return result;
}
void ByteArray::writeInt8(int32_t value)
{
    int8_t data = value;
    str_data.append((const char*)&data, sizeof(data));
}


int32_t ByteArray::readInt16()
{
    int16_t result = 0;
    if (pos + 1 <= str_data.size() && str_data.size() >= pos) {
        const char* data = str_data.c_str();
        memcpy(&result, data + pos - 1, sizeof(int16_t));
        pos += 2;
    } else {
        CCASSERT(false, "ByteArray::readInt16");
    }
    return result;
}

void ByteArray::writeInt16(int32_t value)
{
    int16_t data = value;
    str_data.append((const char*)&data, sizeof(data));
}

int32_t ByteArray::readInt()
{
    int32_t result = NAN;
    if (pos + 3 <= str_data.size() && str_data.size() >= pos) {
        const char* data = str_data.c_str();
        memcpy(&result, data + pos - 1, sizeof(int32_t));

        pos += 4;
    } else {
        CCASSERT(false, "ByteArray::readInt");
    }
    return result;
}

void ByteArray::writeInt(int32_t value)
{
    str_data.append((const char*)&value, sizeof(value));
}

std::string ByteArray::readInt64()
{
    string result = "";
    if (pos + 7 <= str_data.size() && str_data.size() >= pos) {
        
        int64_t int_data = 0;
        const char* data = str_data.c_str();
        memcpy(&int_data, data + pos - 1, sizeof(int64_t));
        
        result = StringUtils::format("%lld", int_data);
        
        pos += 8;
    } else {
        CCASSERT(false, "ByteArray::readInt64");
    }
    return result;
}

void ByteArray::writeInt64(std::string value)
{
    int64_t tmp_value = atoll(value.c_str());
    str_data.append((const char*)&tmp_value, sizeof(tmp_value));
}


std::string ByteArray::readString(int32_t lenght)
{
    string result;
    if (pos + lenght - 1 <= str_data.size() && str_data.size() >= pos) {
        char* char_data = (char*)malloc(lenght + 1);
        char_data[lenght] = '\0';
        memcpy(char_data, str_data.c_str() + pos - 1, lenght);
        
        result = char_data;
        free(char_data);
        
        pos += lenght;
    } else {
        CCASSERT(false, "ByteArray::readString");
    }
    return result;
}

void ByteArray::writeString(std::string value, int32_t lenght)
{
//    char* char_data = (char*)malloc(lenght + 1);
//    memset(char_data, '\0', lenght + 1);
//    memcpy(char_data, value.c_str(), lenght);
//    str_data.append((const char*)char_data, lenght);
    printf("====:%s", value.c_str());
    const char* chars = value.c_str();
    for (int i = 0; i < lenght; ++i) {
        printf("%d, ", (int)chars[i]);
    }
    printf("\n");
    
//    auto min_length = MIN(value.length(), lenght);
    char* char_data = (char*)malloc(lenght + 1);
    memset(char_data, '\0', lenght + 1);
    memcpy(char_data, value.c_str(), lenght);
    str_data.append((const char*)char_data, lenght);
    free(char_data);
    
    chars = str_data.c_str();
    for (int i = 0; i < str_data.length(); ++i) {
        printf("%d, ", (int)chars[i]);
    }
    printf("\n");
}

int32_t ByteArray::getLength()
{
    return (int32_t)str_data.size();
}

void ByteArray::print()
{
    log("ByteArray::print : %s", str_data.c_str());
}

void* ByteArray::getData()
{
    return (void*)str_data.c_str();
}

void ByteArray::pushCallBackData(LuaCallBackData* data)
{
    str_data.append((const char*)(&(*data)), sizeof(data));
}

LuaCallBackData* ByteArray::readCallBackData()
{
    int32_t lenght = sizeof(LuaCallBackData*);
    LuaCallBackData* data = NULL;
    
    if (pos + lenght - 1 <= str_data.size() && str_data.size() >= pos) {
        data = (LuaCallBackData*)str_data.c_str() + pos - 1;
        pos += lenght;
    } else {
        CCASSERT(false, "ByteArray::readCallBackData");
    }
    
    return data;
}

LuaCallBackData::LuaCallBackData()
: caller (NULL)
, data (NULL)
, node(NULL)
{
    
}
    
void LuaCallBackData::setCaller(Node* node)
{
    this->caller = node;
}

Node* LuaCallBackData::getCaller()
{
    return caller;
}
    
ByteArray* LuaCallBackData::getUserData()
{
    return data;
}

void LuaCallBackData::setUserData(ByteArray* data)
{
    this->data = data;
}


void LuaCallBackData::setNodeName(string node_name)
{
    this->node_name = node_name;
}

string LuaCallBackData::getNodeName()
{
    return node_name;
}

void LuaCallBackData::setNode(Node* node)
{
    this->node = node;
}

Node* LuaCallBackData::getNode()
{
    return node;
}

