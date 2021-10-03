baremetal OS kernel for RV32I

Motivation
----------
This repository is inspired by [mini-arm-os](https://github.com/jserv/mini-arm-os.git),
and rewrite from [mini-arm-os](https://github.com/jserv/mini-arm-os.git) also.

Prerequisites
-------------

Steps
-----
* `00-HelloWorld`
  - Print trivial greetings

Building and Verification
-------------------------
* Changes the current working directory to specificed one and issue
```
make
make qemu
```

Licensing
---------
`riscv-os-profile` is freely redistributable under the two-clause BSD License.
Use of this source code is governed by a BSD-style license that can be found
in the `LICENSE` file.

Reference
---------
* [mini-arm-os](https://github.com/jserv/mini-arm-os.git)
* [riscv-toolchain-install-guide](https://github.com/johnwinans/riscv-toolchain-install-guide.git)
