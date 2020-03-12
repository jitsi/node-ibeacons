#import <Foundation/Foundation.h>

// CLBeaconRegion is not available on macOS (why, Apple, why?!) so roll our own.
// Ref: https://blendedcocoa.com/blog/2013/11/02/mavericks-as-an-ibeacon/

@interface iBeaconRegion : NSObject

@property (strong, nonatomic) NSUUID *uuid;
@property (readonly, nonatomic) NSNumber *major;
@property (readonly, nonatomic) NSNumber *minor;

- (id)initWithUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor;
- (NSMutableDictionary *)peripheralDataWithMeasuredPower:(NSNumber *)measuredPower;

@end
