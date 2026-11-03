//
//  ByteArray.h
//  idle
//
//  Created by hua on 2019/3/16.
//

#ifndef ByteArray_h
#define ByteArray_h


#include "cocos2d.h"
USING_NS_CC;


#include <string>
using namespace std;

class MainCityLayer;
class LuaCallBackData;

class ByteArray : public Ref
{
public:
    ByteArray();
    static ByteArray* create();
    
    bool readBool();
    void writeBool(bool value);
    
    char readByte();
    void writeByte(char value);
    
    int32_t readInt8();
    void writeInt8(int32_t value);
    
    int32_t readInt16();
    void writeInt16(int32_t value);
    
    int32_t readInt();
    void writeInt(int32_t value);
    
    std::string readInt64();
    void writeInt64(std::string value);
    
    std::string readString(int32_t lenght);
    void writeString(std::string value, int32_t lenght);
    
    void pushData(void* data, int32_t lenght);
    void* getData();

    void pushCallBackData(LuaCallBackData* data);
    LuaCallBackData* readCallBackData();
    
    int32_t getLength();
    void print();
    
    void resetPos();
private:
    std::string str_data;
    int32_t pos;
};


class LuaCallBackData : public Ref
{
public:
    LuaCallBackData();
    
    void setCaller(Node* node);
    Node* getCaller();
    
    ByteArray* getUserData();
    void setUserData(ByteArray* data);
    
    void setNodeName(string node_name);
    string getNodeName();
    
    void setNode(Node* node);
    Node* getNode();
public:
    Node* caller;
    ByteArray* data;
    
    string node_name;
    Node* node;
};

#endif /* ByteArray_h */
