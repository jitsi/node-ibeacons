{
  "targets": [
    {
      "target_name": "binding",
      "sources": [
        "src/binding.cc"
      ],
      'cflags!': [ '-fno-exceptions' ],
      'cflags_cc!': [ '-fno-exceptions' ],
      'include_dirs': ["<!@(node -p \"require('node-addon-api').include\")"],
      'dependencies': ["<!(node -p \"require('node-addon-api').gyp\")"],
      'conditions': [
        ['OS=="win"', {
          "msvs_settings": {
            "VCCLCompilerTool": {
              "ExceptionHandling": 1
            }
          }
        }],
        ['OS=="mac"', {
          "sources": [
            "src/mac/ibeacons.mm",
            "src/mac/ibeaconsimpl.mm",
            "src/mac/iBeaconRegion.m",
          ],
          'link_settings': {
            'libraries': [
              '-framework Foundation',
              '-framework CoreBluetooth',
              '-framework CoreFoundation',
            ]
          },
          "xcode_settings": {
            "CLANG_CXX_LIBRARY": "libc++",
            'GCC_ENABLE_CPP_EXCEPTIONS': 'YES',
            'MACOSX_DEPLOYMENT_TARGET': '10.13',
            'OTHER_CFLAGS': [
              '-ObjC++',
              '-std=c++11',
              '-arch x86_64',
              '-arch arm64'
            ],
            'OTHER_LDFLAGS': [
              '-arch x86_64',
              '-arch arm64'
            ]
          }
        }]
      ],
      'variables' : {
        'openssl_fips': '',
      }
    }
  ]
}
