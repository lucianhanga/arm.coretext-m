<a name="table-of-contents"></a>
#### Table of Contents ####


1. [Virtualizing](#virtualizing)
1.1. [Introduction](#virtualizing-introduction)
1.1. [Installing QEMU](#virtualizing-introduction)
1.1. [Virtualizing Raspberry](#virtualizing-raspberry)
1.2. [Virtualizing ARM](#virtualizing-arm)
1.3. [Virtualizing ARM Baremetal](#virtualizing-arm-bare-metal)
2. [Cross Compilation](#cross-compilation)



<a name="virtualizing"></a>
####1. Virtualizing ####

To be able to develop and test ARM applications(or any other platform) without the need of an external development board there is the posiblity to virtualize the platform on the development machine. The simplest choice for a development machine would be a Linux but virtualization ran also on Windows and MacOS hosts.

<a name="virtualizing-introduction"></a>
##### 1.1. Introduction #####

The best choice for virtualization of systems which are based on a diferent platform than the host is [QEMU](https://www.qemu.org). QEMU is a generic and open source machine emulator and virtualizer.


[[toc]](#table-of-contents)

<a name="#virtualizing-introduction"></a>
##### 1.2. Installing QEMU #####

###### Installing on windows ######

The installers for the windows platform can be found at this [location](https://qemu.weilnetz.de/w64/). At the time of writing of this document this was the latest version [4.1.0](https://qemu.weilnetz.de/w64/2019/qemu-w64-setup-20181128.exe).


[[toc]](#table-of-contents)

<a name="#virtualizing-raspberry"></a>
##### 1.3. Virtualizing Raspberry #####

+ Prepare a folder which will contain the raspberry files from QEMU.
```sh
$ mkdir qemu-raspi
$ cd qemu-raspi
```
+ Download the latest **raspbian** image from the [raspberyip.org](https://www.raspberrypi.org).
```sh 
$ wget https://downloads.raspberrypi.org/raspbian_lite_latest
```
+ Prepare the downloaded image for QEMU

```sh
$ mv raspbian_lite_latest raspbian_lite_latest.zip
$ unzip raspbian_lite_latest.zip
$ rm raspbian_lite_latest.zip
```
At the time the document was  written the output file was: ```2019-09-26-raspbian-buster-lite.img ```. Continue with the preparation, and make sure that in the following commands you use the correct  ```.img``` file.

```sh
mv 2019-09-26-raspbian-buster-lite.img rpi.img
```

Use the qemu tools to conver the ```.img``` format to a format recognized by the qemu. Also resize the virtual drive to fit your needs. In this scenario is enlarged with 4Gb.

```sh
$ qemu-img convert -f raw -O qcow2 rpi.img rpi.qcow2
$ qemu-img resize rpi.qcow2 +4G
$ rm rpi.img
```

At this point the raspberian images is ready to be used.

+ Download the [qemu raspberry PI kernel](https://github.com/dhruvvyas90/qemu-rpi-kernel) directly from the  github. Take one of the latest kernels. At the time when this doucment was written the following kernel was downloaded:

```sh 
$ wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.14.79-stretch
$ mv kernel-qemu-4.14.79-stretch rpi-kernel
```
Also download the *Device Tree Binary* which needs to be passed to the kernel on boot:

```sh 
$ wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/versatile-pb.dtb
```

+ Start the virtualized Raspberry

```sh
$ qemu-system-arm \
   -kernel rpi-kernel \
   -dtb versatile-pb.dtb \
   -m 256 -M versatilepb -cpu arm1176 \
   -serial stdio \
   -append "rw console=ttyAMA0 root=/dev/sda2 rootfstype=ext4  loglevel=8 rootwait fsck.repair=yes memtest=1" \
   -drive file=rpi.qcow2 \
   -no-reboot \
   -net user,hostfwd=tcp::10022-:22 \
   -net nic
```


[[toc]](#table-of-contents)

<a name="#virtualizing-arm"></a>
##### 1.4. Virtualizing ARM #####

```sh
$ qemu-system-arm -machine help
```
**[barebox](https://www.barebox.org/)** is a bootloader designed for embedded systems. It runs on a variety of architectures including x86, ARM, MIPS, PowerPC and others.. *barebox* is the Swiss Army Knife for bare metal.



[[toc]](#table-of-contents)

<a name="#virtualizing-arm-bare-metal"></a>
##### 1.5. Virtualizing ARM Baremetal #####

+ First make sure that you have installed the QEMU ARM engine.
```sh
$ qemu-system-arm --version
QEMU emulator version 3.1.0
Copyright (c) 2003-2018 Fabrice Bellard and the QEMU Project developers

```

+ Also make sure that the GCC cross-compiler toolchain is installed on the system. Also other toolchains can be used but this document refers to the GCC toolchain.

```sh
$ arm-none-eabi-gcc --version
arm-none-eabi-gcc (GNU Tools for Arm Embedded Processors 8-2019-q3-update) 8.3.1 20190703 (release) [gcc-8-branch revision 273027]
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
+ Check the support for the processor support in the 

For the this documentation all the source code examples are refering to a **Cortex-M** processor, especially **_Cortext-M3_** and **_Cortex-M4_**. Currently the QEMU support for **_Cortext-M3_** and **_Cortex-M4_** CPUs are the _TI Stellaris_ evaluation boards: [lm3s811evb](https://www.ti.com/lit/ds/symlink/lm3s811.pdf) and [lm3s6965evb](http://www.ti.com/lit/ds/symlink/lm3s6965.pdf).

Check the availability of the hardware using the:
```sh 
$ qemu-system-arm -machine help
$ qemu-system-arm -machine help | grep lm3
lm3s6965evb          Stellaris LM3S6965EVB
lm3s811evb           Stellaris LM3S811EVB
```
Running the ARM machine:

```sh 
$ qemu-system-arm   -M vexpress-a9 \
                    -m 32M \
                    -no-reboot \
                    -nographic \
                    -monitor telnet:127.0.0.1:1234,server,nowait
qemu-system-arm: Guest image must be specified (using -kernel)
```
However this ends in an error because there is no code presented. 



[[toc]](#table-of-contents)

<a name="#cross-compilation"></a>
####2. Cross Compilation ####

[[toc]](#table-of-contents)

