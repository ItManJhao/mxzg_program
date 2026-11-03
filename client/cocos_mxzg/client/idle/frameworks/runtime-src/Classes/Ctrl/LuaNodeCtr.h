//
//  LuaNodeCtr.h
//  cleck
//
//  Created by hua on 2019/3/26.
//

#ifndef LuaNodeCtr_h
#define LuaNodeCtr_h

#include "NodeCtr.h"
#include "Layer/WindowCtr.h"
#include "../Model/ByteArray.h"

class LuaNodeCtr : public WindowCtr {
public:
    LuaNodeCtr();
    ~LuaNodeCtr();
    
    static LuaNodeCtr* create();
    
    virtual void close(Ref* object);

    void setCCBIPath(std::string file);
    
    void setLayer(Node* layer);
    
    // 不删除
    virtual void remove();
    
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref * pTarget, const char* pSelectorName);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(cocos2d::Ref * pTarget, cocos2d::Ref* pMenuItem,const char* pSelectorName);
    
    void resolveCCBCCMenuItemSelector();
    void onMenuItemSelector(Ref* pSender){}
protected:
    std::string file_path;
    virtual void loadLayer();
    
    static map<LuaNodeCtr*, vector<LuaCallBackData> > map_variable;
};

#endif /* LuaNodeCtr_h */
