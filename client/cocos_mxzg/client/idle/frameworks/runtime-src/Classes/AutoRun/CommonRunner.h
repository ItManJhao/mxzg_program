//
//  CommonRunner.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__CommonRunner__
#define __AVT__CommonRunner__

#include "GameAutoRun.h"
#include "../Common/SingleInstance.h"

class CommonRunner : public GameAutoRun,
                     public SingleInstance<CommonRunner>
{
protected:
    virtual void init();
    virtual void run(float delay);
};

#endif /* defined(__AVT__CommonRunner__) */
