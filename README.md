baremetal OS kernel for RV32I

Motivation
----------
This repository is inspired by [mini-arm-os](https://github.com/jserv/mini-arm-os.git),
and rewrite from [mini-arm-os](https://github.com/jserv/mini-arm-os.git) also.

Prerequisites
-------------
* ToolChain
`riscv64-unknown-elf`, whcih can get from [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain.git).

* Qemu
`qemu-system-riscv32`, which can get from [QEMU](https://gitlab.com/qemu-project/qemu.git).

Steps
-----
* `00-HelloWorld`
  - Print trivial greetings

* `00-HelloWorld`

* `02-ContextSwitch`

* `03-ContextSwitch-2`

* `04-Multitasking`

* `05-TimerInterrupt`

* `06-Preemptive`

* `07-Threads`

Building and Verification
-------------------------
* Changes the current working directory to specificed one and issue
```
make
make qemu
```

Licensing
---------
`mini-riscv-os` is freely redistributable under the two-clause BSD License.
Use of this source code is governed by a BSD-style license that can be found
in the `LICENSE` file.

Reference
---------
* [mini-arm-os](https://github.com/jserv/mini-arm-os.git)
* [riscv-toolchain-install-guide](https://github.com/johnwinans/riscv-toolchain-install-guide.git)
