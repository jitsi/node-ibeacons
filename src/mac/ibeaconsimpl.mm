
#import <CoreBluetooth/CoreBluetooth.h>
#import "ibeaconsimpl.h"
#import "iBeaconRegion.h"

@interface IBeaconEmitterImpl () <CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBPeripheralManager *manager;
@property (nonatomic, strong) iBeaconRegion *region;
@property (nonatomic, strong) NSNumber *measuredPower;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic) BOOL ready;
@property (nonatomic) state_change_cb cb;
@end

@implementation IBeaconEmitterImpl

- (instancetype)init
{
    if (self = [super init]) {
        dispatch_queue_attr_t attributes =
            dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, -1);
        _queue = dispatch_queue_create("IBeaconEmitter.queue", attributes);
        _manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:_queue];
        _region = nil;
        _measuredPower = nil;
        _ready = NO;
        _cb = nil;
    }

    return self;
}

- (void)startForUUID:(NSUUID *)uuid
           withMajor:(NSNumber *)major
           withMinor:(NSNumber *)minor
   withMeasuredPower:(NSNumber *)measuredPower
        withCallback:(state_change_cb)cb
{
    dispatch_async(_queue, ^{
        [self stopInternal];

        _region = [[iBeaconRegion alloc] initWithUUID:uuid major:major minor:minor];
        _measuredPower = measuredPower;
        _cb = cb;

        [self maybeStart];
    });
}

- (void)stop
{
    dispatch_async(_queue, ^{
        [self stopInternal];
    });
}

#pragma mark - Private helpers

- (void)maybeStart
{
    if ((_ready || _manager.state == CBManagerStatePoweredOn) && _region != nil) {
        [_manager startAdvertising:[_region peripheralDataWithMeasuredPower:_measuredPower]];
    }
}

- (void)stopInternal
{
    if (_manager.isAdvertising) {
        [_manager stopAdvertising];
        if (_cb) {
            _cb(NO, NO);
        }
    }
}

#pragma mark - Delegate methods.

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (_manager.state) {
        case CBManagerStatePoweredOn:
            _ready = YES;
            [self maybeStart];
            break;
        default:
            _ready = NO;
            [self stopInternal];
            break;
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral 
                                       error:(NSError *)error
{
    if (_cb) {
        _cb(YES, error != nil);
    }
}

@end
