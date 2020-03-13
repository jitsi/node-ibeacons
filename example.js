
const beaconEmitter = require('./index.js');

beaconEmitter.start('4A411F6B-F075-4201-BCD5-4B3E087D43F0');

beaconEmitter.on('started', () => {
    console.log('started!');
});

beaconEmitter.on('stopped', () => {
    console.log('stopped!');
});

beaconEmitter.on('error', () => {
    console.log('error!');
});

setTimeout(() => {
    console.log('change of UUID!');
    beaconEmitter.start('1B12FD24-AEB6-4F12-8745-75FB9AC05B15');
}, 5000);

setTimeout(() => {
    beaconEmitter.stop();
}, 15000);
