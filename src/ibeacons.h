#pragma once

#include <string>

using namespace std;

namespace iBeacons {

typedef void(*state_change_cb)(bool active, bool error);

struct Impl;

class IBeaconEmitter
{
public:
    IBeaconEmitter();
    virtual ~IBeaconEmitter();
    void StartAdvertising(std::string uuid, int major, int minor, int measuredPower, state_change_cb cb);
    void StopAdvertising();
private:
    struct Impl *_impl;
};
    
} // iBeacons
