//
//  AutomationManager.h
//  idle
//
//  Created by apple on 2021/5/9.
//

#if (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)

#ifndef AutomationManager_h
#define AutomationManager_h


#include "../Common/SingleInstance.h"
#include "cocos2d.h"

class FileData {
public:
    bool isRead;
    string file;
};

class AutomationManager : public SingleInstance<AutomationManager> {
public:
    static void listenerFileSave();
    
    ~AutomationManager();
    
    void update(float dt);
private:
    vector<FileData*> listPara;
};

#endif /* AutomationManager_h */

#endif
