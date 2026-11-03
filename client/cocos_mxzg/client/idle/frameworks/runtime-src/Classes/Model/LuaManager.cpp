//
//  LuaManager.cpp
//  idle
//
//  Created by hua on 2019/3/15.
//

#include "LuaManager.h"

LuaManager::LuaManager()
{
    
}

//获取变量名值
const char* LuaManager::getLuaVarString(const string& luaFileName,
                                        const char* varName){
    
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = luaL_dofile(ls, getFileFullPath(luaFileName.c_str()));
    if(isOpen!=0){
        CCLOG("Open Lua Error: %i", isOpen);
        return NULL;
    }
    
    lua_settop(ls, 0);
    lua_getglobal(ls, varName);
    
    int statesCode = lua_isstring(ls, 1);
    if(statesCode!=1){
        CCLOG("Open Lua Error: %i", statesCode);
        return NULL;
    }
    
    const char* str = lua_tostring(ls, 1);
    lua_pop(ls, 1);
    
    return str;
}



const char* LuaManager::getLuaVarOneOfTable(const string& luaFileName,
                                            const char* varName,
                                            const char* keyName){
    
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = luaL_dofile(ls, getFileFullPath(luaFileName.c_str()));
    if(isOpen!=0){
        CCLOG("Open Lua Error: %i", isOpen);
        return NULL;
    }
    
    lua_getglobal(ls, varName);
    
    int statesCode = lua_istable(ls, -1);
    if(statesCode!=1){
        CCLOG("Open Lua Error: %i", statesCode);
        return NULL;
    }
    
    lua_pushstring(ls, keyName);
    lua_gettable(ls, -2);
    const char* valueString = lua_tostring(ls, -1);
    
    lua_pop(ls, -1);
    
    return valueString;
}
//执行Lua表，返回表结构
const char* LuaManager::getLuaVarTable(const string& luaFileName,
                                       const char* varName){
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = luaL_dofile(ls, getFileFullPath(luaFileName.c_str()));
    if(isOpen!=0){
        CCLOG("Open Lua Error: %i", isOpen);
        return NULL;
    }
    
    lua_getglobal(ls, varName);
    
    int it = lua_gettop(ls);
    lua_pushnil(ls);
    
    string result="";
    
    while(lua_next(ls, it))
    {
        string key = lua_tostring(ls, -2);
        string value = lua_tostring(ls, -1);
        
        result=result+key+":"+value+"\t";
        
        lua_pop(ls, 1);
    }
    lua_pop(ls, 1);
    
    return result.c_str();
}

//带参执行Lua方法有返回值
const char* LuaManager::callLuaFuncParReturn(const string& luaFileName,
                                             const char* functionName,
                                             cocos2d::Vector<Ref*>* arraypar,
                                             cocos2d::Vector<Ref*>* arraypartype){
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = luaL_dofile(ls, getFileFullPath(luaFileName.c_str()));
    if(isOpen!=0){
        CCLOG("Open Lua Error: %i", isOpen);
        return NULL;
    }
    
    lua_getglobal(ls, functionName);
    int countnum = arraypar ? (int)arraypar->size() : 0;
    if(countnum>0)
    {
        for (int i = 0; i < arraypar->size(); i++) {
            cocos2d::__String* typestr = (cocos2d::__String*)arraypartype->at(i);
            cocos2d::__String* strnr = (cocos2d::__String*)arraypar->at(i);
            if(typestr->isEqual(cocos2d::__String::create("string")))
            {
                lua_pushstring(ls, strnr->getCString());
            }
            else if(typestr->isEqual(cocos2d::__String::create("int")))
            {
                lua_pushnumber(ls, strnr->intValue());
            }
            else if(typestr->isEqual(cocos2d::__String::create("bool")))
            {
                lua_pushboolean(ls, strnr->boolValue());
            }
        }
    }
    /*
     lua_call
     第一个参数:函数的参数个数
     第二个参数:函数返回值个数
     */
    lua_call(ls, countnum, 1);
    
    const char* iResult = lua_tostring(ls, -1);
    
    return iResult;
}

//带参执行Lua方法无返回值
const void LuaManager::callLuaFuncPar(const string& luaFileName,
                                      const char* functionName,
                                      cocos2d::Vector<Ref*>* arraypar,
                                      cocos2d::Vector<Ref*>* arraypartype){
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = luaL_dofile(ls, luaFileName.c_str());
    if(isOpen!=0){
        CCLOG("Open Lua Error: %i", isOpen);
        return;
    }
    
    lua_getglobal(ls, functionName);
    int countnum = arraypar ? (int)arraypar->size() : 0;
    if(countnum > 0)
    {
        for (int i = 0; i<arraypar->size(); i++) {
            cocos2d::__String * typestr = (cocos2d::__String*)arraypartype->at(i);
            cocos2d::__String* strnr = (cocos2d::__String*)arraypar->at(i);
            if(typestr->isEqual(cocos2d::__String::create("string")))
            {
                lua_pushstring(ls, strnr->getCString());
            }
            else if(typestr->isEqual(cocos2d::__String::create("int")))
            {
                lua_pushnumber(ls, strnr->intValue());
            }
            else if(typestr->isEqual(cocos2d::__String::create("bool")))
            {
                lua_pushboolean(ls, strnr->boolValue());
            }
        }
    }
    /*
     lua_call
     第一个参数:函数的参数个数
     第二个参数:函数返回值个数
     */
    lua_call(ls, countnum, 0);
}


int LuaManager::executeFunction(LuaStack* lua_stack, int numArgs, std::function<int32_t(LuaStack*, int&)> return_func)
{
    auto _state = lua_stack->getLuaState();
    
    int functionIndex = -(numArgs + 1);
    if (!lua_isfunction(_state, functionIndex))
    {
        CCLOG("value at stack [%d] is not function", functionIndex);
        lua_pop(_state, numArgs + 1); // remove function and arguments
        return 0;
    }
    
    int traceback = 0;
    lua_getglobal(_state, "__G__TRACKBACK__");                         /* L: ... func arg1 arg2 ... G */
    if (!lua_isfunction(_state, -1))
    {
        lua_pop(_state, 1);                                            /* L: ... func arg1 arg2 ... */
    }
    else
    {
        lua_insert(_state, functionIndex - 1);                         /* L: ... G func arg1 arg2 ... */
        traceback = functionIndex - 1;
    }
    
    int error = 0;
    //++_callFromLua;
    error = lua_pcall(_state, numArgs, 1, traceback);                  /* L: ... [G] ret */
    // --_callFromLua;
    if (error)
    {
        if (traceback == 0)
        {
            CCLOG("[LUA ERROR] %s", lua_tostring(_state, - 1));        /* L: ... error */
            lua_pop(_state, 1); // remove error message from stack
        }
        else                                                            /* L: ... G error */
        {
            lua_pop(_state, 2); // remove __G__TRACKBACK__ and error message from stack
        }
        return 0;
    }
    
    // get return value
    int ret = 0;
    return_func(lua_stack, ret);
//    if (lua_isnumber(_state, -1))
//    {
//        ret = (int)lua_tointeger(_state, -1);
//    }
//    else if (lua_isboolean(_state, -1))
//    {
//        ret = (int)lua_toboolean(_state, -1);
//    }
    
    // remove return value from stack
    lua_pop(_state, 1);                                                /* L: ... [G] */
    
    if (traceback)
    {
        lua_pop(_state, 1); // remove __G__TRACKBACK__ from stack      /* L: ... */
    }
    
    return ret;
}


int LuaManager::executeFunctionAndReturn(LuaStack* lua_stack,
                                         std::function<int32_t(LuaStack*)> push_func,
                                         std::function<int32_t(LuaStack*, int&)> return_func)
{
    auto _state = lua_stack->getLuaState();
    int numArgs = 0;
    if (push_func) {
        numArgs = push_func(lua_stack);
    }
    
    int functionIndex = -(numArgs + 1);
    if (!lua_isfunction(_state, functionIndex))
    {
        CCLOG("value at stack [%d] is not function", functionIndex);
        lua_pop(_state, numArgs + 1); // remove function and arguments
        return 0;
    }
    
    int traceback = 0;
    lua_getglobal(_state, "__G__TRACKBACK__");                         /* L: ... func arg1 arg2 ... G */
    if (!lua_isfunction(_state, -1))
    {
        lua_pop(_state, 1);                                            /* L: ... func arg1 arg2 ... */
    }
    else
    {
        lua_insert(_state, functionIndex - 1);                         /* L: ... G func arg1 arg2 ... */
        traceback = functionIndex - 1;
    }
    
    int error = 0;
    //++_callFromLua;
    error = lua_pcall(_state, numArgs, 1, traceback);                  /* L: ... [G] ret */
    // --_callFromLua;
    if (error)
    {
        if (traceback == 0)
        {
            CCLOG("[LUA ERROR] %s", lua_tostring(_state, - 1));        /* L: ... error */
            lua_pop(_state, 1); // remove error message from stack
        }
        else                                                            /* L: ... G error */
        {
            lua_pop(_state, 2); // remove __G__TRACKBACK__ and error message from stack
        }
        return 0;
    }
    
    // get return value
    int ret = 0;
    return_func(lua_stack, ret);
    //    if (lua_isnumber(_state, -1))
    //    {
    //        ret = (int)lua_tointeger(_state, -1);
    //    }
    //    else if (lua_isboolean(_state, -1))
    //    {
    //        ret = (int)lua_toboolean(_state, -1);
    //    }
    
    // remove return value from stack
    lua_pop(_state, 1);                                                /* L: ... [G] */
    
    if (traceback)
    {
        lua_pop(_state, 1); // remove __G__TRACKBACK__ from stack      /* L: ... */
    }
    
    return ret;
}


int LuaManager::executeGlobalFunction(const char* functionName)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return 0;
    }
    return ls->executeFunction(0);
}


int LuaManager::executeGlobalJsonFunction(const char* functionName, CSJson::Value json)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return 0;
    }
    
    CSJson::FastWriter writer;
    string json_stirng = writer.write(json);
    CCLOG("LuaManager::executeGlobalFunction  json_stirng = %s", json_stirng.c_str());
    
    lua_pushstring(ls->getLuaState(), json_stirng.c_str());
    return ls->executeFunction(1);
}

int LuaManager::executeGlobalDataFunction(const char* functionName, void* data, int32_t lenght)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return 0;
    }
    log("%s", "asdasd");
    
    ls->pushString((const char *)data, lenght);
    ls->pushInt(lenght);
    return ls->executeFunction(2);
}


int LuaManager::executeGlobalByteArrayFunction(const char* functionName, ByteArray* data, const char* type_name)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return 0;
    }
    
    ls->pushObject(data, type_name);
    return ls->executeFunction(1);
}

int LuaManager::executeGlobalObjectFunction(const char* functionName, void* data, const char* type_name)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return 0;
    }
    
    ls->pushObject((Ref*)data, type_name);
    return ls->executeFunction(1);
}

int LuaManager::executeGlobalAutoFunction(const char* functionName, std::function<int32_t(LuaStack*)> push_func)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return 0;
    }
    
    auto para_num = 0;
    if (push_func) {
        para_num = push_func(ls);
    }
    return ls->executeFunction(para_num);
}

void LuaManager::handleEvent(Ref* caller, string event, std::function<int32_t(LuaStack*)> push_func) {
    auto* ls = LuaEngine::getInstance()->getLuaStack();

    if (NULL == caller)
        return ;
    
    int handler = ScriptHandlerMgr::getInstance()->getObjectHandler(caller, ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);
    
    if (0 == handler)
        return ;
    auto para_num = 0;
    
    ls->pushString(event.c_str()); // para_num + 1
    if (push_func) {
        para_num = push_func(ls);
    }
    
    para_num++;
    
    //int ret = ls->executeFunctionByHandler(handler, 1);
    ls->executeFunctionByHandler(handler, para_num);
    
    ls->clean();
    return /*ret*/;
}

CSJson::Value LuaManager::handleEventReturn(Ref* caller, string event, std::function<int32_t(LuaStack*)> push_func)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    
    if (NULL == caller)
        return CSJson::Value();
    
    int handler = ScriptHandlerMgr::getInstance()->getObjectHandler(caller, ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);
    
    if (0 == handler)
        return CSJson::Value();
    auto para_num = 0;
    
    ls->pushString(event.c_str()); // para_num + 1
    if (push_func) {
        para_num = push_func(ls);
    }
    
    para_num++;
    
    
    string str_json = "";
    // tolua_tousertype(ls->getLuaState(), -1, NULL);
    auto return_func = [&](LuaStack* ls, int& ret){
        
        const char* str = tolua_tostring(ls->getLuaState(), -1, "");
        if (str != NULL) {
            str_json = str;
        }
        return 1;
    };

    int ret = 0;
    if (ls->pushFunctionByHandler(handler))                                /* L: ... arg1 arg2 ... func */
    {
        if (para_num > 0)
        {
            lua_insert(ls->getLuaState(), -(para_num + 1));                        /* L: ... func arg1 arg2 ... */
        }
        
        ret = executeFunction(ls, para_num, return_func); // ls->executeFunction(para_num);
    }
    lua_settop(ls->getLuaState(), 0);
    
    // log("str_json = %s", str_json.c_str());
    CSJson::Value json;
    CSJson::Reader reader;
    if (!reader.parse(str_json, json)) {
        ls->clean();
        return CSJson::Value();
    }
    
    ls->clean();
    return json /*ret*/;
}


CSJson::Value LuaManager::executeGlobalJsonFunctionReturn(const char* functionName)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return CSJson::Value();
    }
    

    lua_call(ls->getLuaState(), 0, 1);

    
    string str_json = lua_tolstring(ls->getLuaState(), -1, NULL);
    
    CSJson::Value json;
    CSJson::Reader reader;
    if (!reader.parse(str_json, json)) {
        ls->clean();
        return CSJson::Value();
    }
    ls->clean();
    return json;
}

CSJson::Value LuaManager::executeGlobalJsonFunctionReturn(const char* functionName, CSJson::Value json)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return CSJson::Value();
    }
    
    CSJson::FastWriter writer;
    string json_stirng = writer.write(json);
    
    lua_pushstring(ls->getLuaState(), json_stirng.c_str());
    lua_call(ls->getLuaState(), 1, 1);
    
    const char* str_char = lua_tostring(ls->getLuaState(), -1);
    
//    string str_json = str_char;
    CSJson::Reader reader;
    if (!reader.parse(str_char, json)) {
        ls->clean();
        return CSJson::Value();
    }
    
    ls->clean();
    return json;
}

Node* LuaManager::executeGlobalNodeFunctionReturn(const char* functionName, CSJson::Value json) {
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);       /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return 0;
    }
    
    auto push_func = [&](LuaStack * ls){
        CSJson::FastWriter writer;
        string json_stirng = writer.write(json);
        lua_pushstring(ls->getLuaState(), json_stirng.c_str());
        return 1;
    };
    
    Node* node = NULL;

    auto return_func = [&](LuaStack* ls, int& ret){
        node = (Node*)tolua_tousertype(ls->getLuaState(), -1, NULL);
        return 1;
    };
    executeFunctionAndReturn(ls, push_func, return_func);
    
    ls->clean();
    return (Node*)node;
}

void* LuaManager::executeGlobalObjectFunctionReturn(const char* functionName, CSJson::Value json)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return NULL;
    }
    
    CSJson::FastWriter writer;
    string json_stirng = writer.write(json);
    
    lua_pushstring(ls->getLuaState(), json_stirng.c_str());
    lua_call(ls->getLuaState(), 1, 1);
    
    auto data = lua_touserdata(ls->getLuaState(), -1);
    
    ls->clean();
    return data;
}


bool LuaManager::executeGlobalBoolFunctionReturn(const char* functionName, CSJson::Value json)
{
    auto* ls = LuaEngine::getInstance()->getLuaStack();
    lua_getglobal(ls->getLuaState(), functionName);    /* query function by name, stack: function */
    if (!lua_isfunction(ls->getLuaState(), -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", functionName);
        lua_pop(ls->getLuaState(), 1);
        return NULL;
    }
    
    CSJson::FastWriter writer;
    string json_stirng = writer.write(json);
    
    lua_pushstring(ls->getLuaState(), json_stirng.c_str());
    lua_call(ls->getLuaState(), 1, 1);
    
    auto data = lua_toboolean(ls->getLuaState(), -1);
    
    ls->clean();
    return data;
}


const char* LuaManager::getFileFullPath(const char* fileName){
    return FileUtils::getInstance()->fullPathForFilename(fileName).c_str();
}

//CCArray* arraypar = CCArray::create();
//arraypar->addObject(CCString::create("参数值"));
//CCArray* arraytype =CCArray::create();
//arraytype->addObject(CCString::create("string"));
//LuaManager::instance()->callLuaFuncPar("Lua文件名", "参数名", arraypar, arraytype);


// https://www.cnblogs.com/dabaopku/p/5649294.html

//void NetworkManager::get(const std::string &path, const std::string &params, int callback)
//{
//    auto func = [callback](NetworkResponse *response){
//        auto engine = LuaManager::getInstance()->engine();
//        engine->getLuaStack()->pushObject(response, "pp.NetworkResponse");<br>// 1
//        engine->getLuaStack()->executeFunctionByHandler(callback, 1);
//    };
//
//    Json::Value json;
//
//    this->get(path, json, func);
//}
