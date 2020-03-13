#include "../ibeacons.h"
#include "ibeaconsimpl.h"

using namespace iBeacons;
using namespace std;

struct iBeacons::Impl {
    IBeaconEmitterImpl *obj;
    state_change_cb cb;
};

IBeaconEmitter::IBeaconEmitter()
{
    _impl = new Impl();
    _impl->obj = [[IBeaconEmitterImpl alloc] init];
}

IBeaconEmitter::~IBeaconEmitter()
{
    if (_impl)
        delete _impl;   
}

void IBeaconEmitter::StartAdvertising(std::string uuid, int major, int minor, int measuredPower, state_change_cb cb)
{
    NSUUID *uuid_ = [[NSUUID alloc] initWithUUIDString:[NSString stringWithUTF8String:uuid.c_str()]];
    [_impl->obj startForUUID:uuid_
                   withMajor:[NSNumber numberWithInt:major]
                   withMinor:[NSNumber numberWithInt:minor]
           withMeasuredPower:[NSNumber numberWithInt:measuredPower]
                withCallback:cb];
    _impl->cb = cb;
}

void IBeaconEmitter::StopAdvertising()
{
    [_impl->obj stop];
}

// Delegate methods
