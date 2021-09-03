---
title: ACPI in qemu
date:  2021-09-03
...

I'm fiddling around with QEMU and trying to get graceful shutdown working, triggered from outside
the VM. Here's what I figured out:

## Part 1: QMP

QEMU has a thing called "QMP", which I assume stands for "QEMU Management Protocol". It will listen
on a socket and you can chat with a running VM to control it a bit.

Run the VM with `-qmp unix:/tmp/qmp.sock,server,nowait`, then you can talk to that socket. I'm sure
there are libraries for this, but it looks like if you send the messages `{"execute":
"qmp_capabilities"}` and then `{"execute": "system_powerdown"}`, it does what I want.

```ruby
require('socket')
c = UNIXSocket.new('/tmp/qmp.sock')
puts(c.readline)
c.puts('{"execute": "qmp_capabilities"}')
puts(c.readline)
c.puts('{"execute": "system_powerdown"}')
puts(c.readline)
puts(c.readline)
c.close
```

This sends a message via ACPI to `acpid` running in my initramfs. In order for that to work, I have
to set up `/dev/input/event0`:

```bash
mknod /dev/input/event0 c 13 64
```

Then, when I run that QMP script above, `acpid` executes the file at `/etc/acpi/PWRF/00000080`.

## Part 2: Port I/O

So what do we do in that ACPI event script? Well, first, we'll want to fsync, shut down processes,
whatever, but at the end of the day I want the QEMU process to terminate. Here's how we do it:

```c
#include <sys/io.h>
#include <stdio.h>

int main() {
  printf ("Powering off...\n");

  /* In modern versions of qemu, in order to terminate the VM from inside,
   * we have to run qemu with `-device isa-debug-exit` and write a message
   * (0x31) to a port (0x501). Port I/O is a weird kernel-y thing, but just realize that:
   *   - ioperm gives us permission to write to port 0x501
   *   - outb writes a byte (0x31) to that port.
   * The byte we pass is doubled and incremented to build an exit code. So, we
   * can't end up with a clean (0) exit, or an even number. We pass 0x31=49 to end
   * up with an exit code of 49*2+1 = 99.
   */
  ioperm(0x501, 1, 1);
  outb(0x31, 0x501);

  printf ("failed to shut down...\n");
  for (;;) { }
}
```

So we compile that (I'm using an alpine docker image and compiling with `-O -static`), put it in the
initramfs at `/sbin/acpi-shutdown`, and write a script at `/etc/acpi/PWRF/00000080` that finishes by
calling it, and invoke `qemu` with `-device isa-debug-exit`.

After all that, when we run the script to send the QMP event for machine shutdown, this binary
executes and causes QEMU to actually terminate with exit status 99 after doing whatever graceful
termination seems useful.
