QEMU for Windows 64bit
```https://qemu.weilnetz.de/w64/```


$ wget https://downloads.raspberrypi.org/raspbian_lite_latest
mv raspbian_lite_latest raspbian_lite_latest.zip
unzip raspbian_lite_latest.zip
mv <the output file from above> rpi.img
qemu-img convert -f raw -O qcow2 rpi.img pri.qcow2   
qemu-img resize rpi.qcow2 +4G

with the browser to this page https://github.com/dhruvvyas90/qemu-rpi-kernel and download the kernel.

or 
wget https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/master/kernel-qemu-4.19.50-buster

qemu-system-arm \
   -kernel kernel-qemu-4.14.79-stretch \
   -dtb versatile-pb.dtb \
   -m 256 -M versatilepb -cpu arm1176 \
   -serial stdio \
   -append "rw console=ttyAMA0 root=/dev/sda2 rootfstype=ext4  loglevel=8 rootwait fsck.repair=yes memtest=1" \
   -drive file=rpi.qcow2 \
   -no-reboot \
   -net user,hostfwd=tcp::10022-:22 \
   -net nic




install debian on virt

https://translatedcode.wordpress.com/2016/11/03/installing-debian-on-qemus-32-bit-arm-virt-board/


ARMEL & ARMHF
https://www.debian.org/ports/arm/
https://blogs.oracle.com/jtc/is-it-armhf-or-armel

https://en.wikipedia.org/wiki/Binfmt_misc


https://wiki.debian.org/QemuUserEmulation
