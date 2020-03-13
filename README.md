# node-ibeacons

ibeacon emitting for Node.

**NOTE**: only macOS is supported at the moment.

## Overview

This package allows the user to emit an ibeacon with their device, proven it
has support for it.

### API

#### beaconEmitter.start(uuid, [major, [minor, [measuredPower]]])

Starts emitting an ibeacon with the given proximity UUID, major, minor at the
given measured power.

This function may be called multiple times and the last one will prevail,
previous advertisementts will be cancelled.

The `started` event will be emitted when the advertising starts. The `stopped`
and `error` events may also occur. If Bluetooth is stopped while advertising,
the `stopped` event will be emitted, but adverttising will be automatically
resumed when Bluetooth is started.

#### beaconEmitter.stop()

Stops advertising ibeacons. No further events will be emitted.

## License

Apache Licence 2.0.
