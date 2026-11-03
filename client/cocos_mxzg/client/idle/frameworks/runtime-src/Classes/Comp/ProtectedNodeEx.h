//
//  ProtectedNodeEx.h
//  Editorer
//
//  Created by windy on 2018/4/3.
//

#ifndef ProtectedNodeEx_h
#define ProtectedNodeEx_h

#include "cocos2d.h"
#include "cocos/2d/CCProtectedNode.h"

class ProtectedNodeEx : public cocos2d::ProtectedNode {
public:
    CREATE_FUNC(ProtectedNodeEx);
    virtual void destroy(bool cleanup);
    virtual void removeFromParentAndCleanup(bool cleanup) override;
    virtual void onExitTransitionDidStart() override;
    virtual void cleanup() override;
    virtual void onExit() override;
};

#endif /* ProtectedNodeEx_h */
