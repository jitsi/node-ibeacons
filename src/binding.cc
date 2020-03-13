#include <napi.h>
#include <uv.h>

#include "ibeacons.h"

using namespace std;


static char startEvent[] = "started";
static char stopEvent[] = "stopped";
static char errorEvent[] = "error";

static iBeacons::IBeaconEmitter *emitter;
uv_mutex_t tsMutex;
static Napi::ThreadSafeFunction tsEmit = nullptr;


static void StateChangedCb(Napi::Env env, Napi::Function jsCallback, void *value) {
  // Transform native data into JS data, passing it to the provided 
  // `jsCallback` -- the TSFN's JavaScript function.
  char *str = static_cast<char *>(value);
  jsCallback.Call({Napi::String::New(env, str)});
};

static void StateChanged(bool active, bool error) {
  uv_mutex_lock(&tsMutex);

  if (tsEmit != nullptr) {
    if (active) {
      tsEmit.NonBlockingCall(static_cast<void *>(startEvent), StateChangedCb);
    } else if (error) {
      tsEmit.NonBlockingCall(static_cast<void *>(errorEvent), StateChangedCb);
    } else {
      tsEmit.NonBlockingCall(static_cast<void *>(stopEvent), StateChangedCb);
    }
  }

  uv_mutex_unlock(&tsMutex);
}

Napi::Value Start(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  if (info.Length() < 5) {
    Napi::TypeError::New(env, "Wrong number of arguments").ThrowAsJavaScriptException();
    return env.Null();
  }

  std::string uuid = info[0].As<Napi::String>().Utf8Value();
  int major = info[1].As<Napi::Number>().Int32Value();
  int minor = info[2].As<Napi::Number>().Int32Value();
  int measuredPower = info[3].As<Napi::Number>().Int32Value();
  Napi::Function emit = info[4].As<Napi::Function>();

  uv_mutex_lock(&tsMutex);
  if (tsEmit == nullptr) {
    tsEmit = Napi::ThreadSafeFunction::New(env, emit, "Emit Fn", 0, 1 );
  }
  uv_mutex_unlock(&tsMutex);

  emitter->StartAdvertising(uuid, major, minor, measuredPower, StateChanged);

  return env.Undefined();
}

Napi::Value Stop(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  emitter->StopAdvertising();

  uv_mutex_lock(&tsMutex);
  if (tsEmit != nullptr) {
    tsEmit.Release();
    tsEmit = nullptr;
  }
  uv_mutex_unlock(&tsMutex);

  return env.Undefined();
}

// Init
Napi::Object Init(Napi::Env env, Napi::Object exports) {
  uv_mutex_init(&tsMutex);
  emitter = new iBeacons::IBeaconEmitter();
  exports["start"] = Napi::Function::New(env, Start);
  exports["stop"] = Napi::Function::New(env, Stop);
  return exports;
}

NODE_API_MODULE(NODE_GYP_MODULE_NAME, Init);
