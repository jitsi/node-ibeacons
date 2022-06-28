'use strict'

const { EventEmitter } = require('events');
const binding = require('node-gyp-build')(__dirname)

class IBeaconEmitter extends EventEmitter {
    start(uuid, major = 0, minor = 0, measuredPower = -59) {
        // TODO: validate UUID.
        binding.start(uuid, major, minor, measuredPower, this.emit.bind(this));
    }

    stop() {
        binding.stop();
    }
}


module.exports = new IBeaconEmitter();
