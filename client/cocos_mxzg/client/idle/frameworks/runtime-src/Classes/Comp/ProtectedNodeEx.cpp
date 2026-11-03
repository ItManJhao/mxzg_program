//
//  ProtectedNodeEx.cpp
//  Editorer
//
//  Created by windy on 2018/4/3.
//

#include "ProtectedNodeEx.h"

void ProtectedNodeEx::onExitTransitionDidStart() {
    
}

void ProtectedNodeEx::cleanup() {
    
}

void ProtectedNodeEx::onExit() {
    
}

void ProtectedNodeEx::removeFromParentAndCleanup(bool cleanup) {
    if (_parent != nullptr)
    {
        retain();
        _parent->removeChild(this,cleanup);
        setParent(NULL);
    }
}

void ProtectedNodeEx::destroy(bool cleanup) {
    if (_running)
    {
        ProtectedNode::onExitTransitionDidStart();
        ProtectedNode::onExit();
    }
    
    // If you don't do cleanup, the child's actions will not get removed and the
    // its scheduledSelectors_ dict will not get released!
    if (cleanup)
    {
        ProtectedNode::cleanup();
    }
    
    // set parent nil at the end
    ProtectedNode::setParent(nullptr);
    
    while (getReferenceCount() > 1) {
        release();
    }
}

