//
//  CCBLoader.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__CCBLoader__
#define __ClickerHeroes__CCBLoader__

#include "../Ctrl/NodeCtr.h"

class NodeCtr;
class CCBLoader : public Ref {
public:
    static Node* readNodeGraphFromFile(const char* pCCBFileName);
    static Node* readNodeGraphFromFile(const char* pCCBFileName, NodeCtr* pController);
    static Node* readNodeGraphFromFile(const char* pCCBFileName, NodeCtr* pController, bool flag);

    static Scene* createSceneWithNodeGraphFromFile(const char* pCCBFileName, NodeCtr* pController);
    static void addLuaLoaderLibrary(const char* pCCBFileLayerName);
    static void addNodeLoaderLibrary(const char* pCCBFileLayerName);
    
    static void onHandlePropTypeStringCustom(Node * pNode, Node * /*pParent*/, const char* pPropertyName, const char * pString, CCBReader * /*ccbReader*/);
protected:
    static NodeLoaderLibrary* getLoaderLibrary();
    static NodeLoaderLibrary* loaderLibrary;
};

#endif /* defined(__ClickerHeroes__CCBLoader__) */
