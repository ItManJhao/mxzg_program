//
//  LuaManager.h
//  idle
//
//  Created by hua on 2019/3/15.
//

#ifndef __LuaManager_h__
#define __LuaManager_h__


#include "../Common/CommonDefine.h"
#include "../Common/SingleInstance.h"
#include "ByteArray.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"

#include "cocos2d.h"
using namespace cocos2d;
using namespace std;

extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
};


class LuaManager : public SingleInstance<LuaManager> {
public:
    LuaManager();
    
    /*
     直接获取Lua中得变量名值
     文件名 luaFileName
     变量名 varName
     */
    const char* getLuaVarString(const string& luaFileName,
                                const char* varName);
    
    /*
     获取Lua中一个表中得节点名，甚至方法
     文件名luaFileName
     方法名varName
     节点名
     */
    const char* getLuaVarOneOfTable(const string& luaFileName,
                                    const char* varName,
                                    const char* keyName);
    
    /*
     调用Lua全局Table
     lua文件名luaFileName
     table变量名varName
     */
    const char* getLuaVarTable(const string& luaFileName,
                               const char* varName);
    
    /*
     带参数有返回
     文件名luaFileName
     方法名functionName
     参数序列arraypar
     参数类型arraypartype
     */
    const char* callLuaFuncParReturn(const string& luaFileName,
                                     const char* functionName,
                                     cocos2d::Vector<Ref*>* arraypar,
                                     cocos2d::Vector<Ref*>* arraypartype);
    
    /*
     带参数无返回
     文件名luaFileName
     方法名functionName
     参数序列arraypar
     参数类型arraypartype
     */
    const void callLuaFuncPar(const string& luaFileName,
                              const char* functionName,
                              cocos2d::Vector<Ref*>* arraypar,
                              cocos2d::Vector<Ref*>* arraypartype);
    // 调用lua函数
    int executeFunction(LuaStack* lua_stack, int numArgs, std::function<int32_t(LuaStack*, int&)> return_func);
    int executeFunctionAndReturn(LuaStack* lua_stack, std::function<int32_t(LuaStack*)> push_func, std::function<int32_t(LuaStack*, int&)> return_func);

    // 无返回值调用
    int executeGlobalFunction(const char* functionName);
    int executeGlobalJsonFunction(const char* functionName, CSJson::Value json);
    int executeGlobalDataFunction(const char* functionName, void* data, int32_t lenght);
    int executeGlobalByteArrayFunction(const char* functionName, ByteArray* data, const char* type_name);
    int executeGlobalObjectFunction(const char* functionName, void* data, const char* type_name);
    int executeGlobalAutoFunction(const char* functionName, std::function<int32_t(LuaStack*)> push_func);
    void handleEvent(Ref* caller, string event, std::function<int32_t(LuaStack*)> push_func);
    CSJson::Value handleEventReturn(Ref* caller, string event, std::function<int32_t(LuaStack*)> push_func);

    
    // 返回一个json字符串
    CSJson::Value executeGlobalJsonFunctionReturn(const char* functionName);
    CSJson::Value executeGlobalJsonFunctionReturn(const char* functionName, CSJson::Value json);
    Node* executeGlobalNodeFunctionReturn(const char* functionName, CSJson::Value json);
    
    void* executeGlobalObjectFunctionReturn(const char* functionName, CSJson::Value json);
    bool executeGlobalBoolFunctionReturn(const char* functionName, CSJson::Value json);

private:
    const char* getFileFullPath(const char* fileName);
};

#endif /* LuaManager_h */
