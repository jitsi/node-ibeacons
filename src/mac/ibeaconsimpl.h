
#import <Foundation/Foundation.h>

typedef void (^statusChangeBlock) (BOOL active, BOOL hasError);
typedef void(*state_change_cb)(bool active, bool error);

@interface IBeaconEmitterImpl : NSObject

- (instancetype)init;
- (void)startForUUID:(NSUUID *)uuid
           withMajor:(NSNumber *)major
           withMinor:(NSNumber *)minor
   withMeasuredPower:(NSNumber *)measuredPower
        withCallback:(state_change_cb)cb;
- (void)stop;

@end
