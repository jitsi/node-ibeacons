#import "iBeaconRegion.h"


@implementation iBeaconRegion

- (id)initWithUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor {
    if (self = [super init]) {
        _uuid = uuid;
        _major = major;
        _minor = minor;
    }
    return self;
}

- (NSMutableDictionary *)peripheralDataWithMeasuredPower:(NSNumber *)measuredPower {
    unsigned char bytes[21] = { 0   };
    
    if (!measuredPower) {
        measuredPower = @-59;
    }
    
    [_uuid getUUIDBytes:(unsigned char *)&bytes];
    
    bytes[16] = (unsigned char)(self.major.shortValue >> 8);
    bytes[17] = (unsigned char)(self.major.shortValue & 0xff);
    
    bytes[18] = (unsigned char)(self.minor.shortValue >> 8);
    bytes[19] = (unsigned char)(self.minor.shortValue & 0xff);
    
    bytes[20] = measuredPower.shortValue;
    
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:21];
    return [@{@"kCBAdvDataAppleBeaconKey":data} mutableCopy];
}

@end
