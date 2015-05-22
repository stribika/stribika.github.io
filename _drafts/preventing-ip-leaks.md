---
layout: post
title: "Preventing IP leaks"
tags: [linux,tor]
---

If you use Tor regularly, hopefully you hear a lot about IP leaks.
Java applets ignore /etc/resolv.conf, WebRTC ignores proxy settings, bittorrent clients tell your IP to the trackers, CIPAV sends your IP to the FBI, kernel bugs in transproxy cause RSTs to be sent directly, etc.

There are two types of leaks:

1. Incorrectly implemented proxy support.
1. The protocol you're using hands out your IP to people.

Both types can be accidental or exploited maliciously.

# Preventing Type-1 leaks

Preventing Type-1 leaks is pretty simple if you don't care that it breaks certain applications.

Block non-Tor traffic with iptables:

<pre><code>iptables -P INPUT DROP
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -j LOG
iptables -P OUTPUT DROP
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m owner --owner-uid {Tor's UID} -j ACCEPT
iptables -A OUTPUT -j LOG</code></pre>

Use Tor's DNS resolver:

<pre><code>cat > /etc/torrc << EOF
User tor
DNSPort 127.0.0.1:53
SOCKSPort 127.0.0.1:9050
ORPort 0.0.0.0:443
PIDFile /var/run/tor/tor.pid
Log notice syslog
DataDirectory /var/lib/tor/data
EOF

echo nameserver 127.0.0.1 > /etc/resolv.conf</code></pre>

Of course, you may want to allow other things through your firewall, such as DHCP.
This must be done with care.
Use UID and destination IP matching if possible.

At this point, all you have to do is configure your applications to use the localhost:9050 proxy and you're done.
Applications without SOCKS support or with broken SOCKS support will stop working.
You will see these in the syslog, maybe you just forgot to configure them correctly.
You may want to run server processes, for this, you need to set up hidden services.

# Preventing Type-2 leaks

Most people would like to use applications without SOCKS support, so they force everything through Tor with transproxy or TUN/TAP.
Sending everything through Tor without knowing what that traffic is greatly increases the chances of Type-2 leaks.
If a network interface has a public IP address, then any of the processes might call getifaddrs(3) and send the address to some other host through the Tor network.
This could happen by accident or it could be the FBI malware.

The two things required for this kind of IP leak are: having access to an interface with a routable IP and being able to call getifaddrs(3).
Take any of these away and Type-2 leaks are impossible.
There is no simple way to control who can call getifaddrs(3) but fortunately, recent Linux kernels support network namespaces.
Basically, the kernel can offer multiple copies of the networking stack, each with its own links, addresses and routes.
Even iptables rules can be different.
Processes inherit namespace memberships when forked the same way they inherit the environment variables and the UID, for example.
Otherwise only root can set the namespace.

If we set up two namespaces, assign all the real network cards to one of them and run almost every process in the other, like a virtual LAN, then those processes will have no way to figure out the external IPs.

# More isolation

There are various other namespaces one could enter, each duplicating some subset of the user facing kernel API, each inherited the same way.

* Network namespaces: This is what we were talking about so far.
* UTS namespace: Makes it possible to show different local hostnames for different processes. Could be useful, if the local hostname may reveal some information.
* Mount namespaces: The visibility of mount points can be restricted using mount namespaces. In fact, you get a mount namespace for free with each network namespace so you can mount a different /etc/resolv.conf everywhere.
* PID namespaces: Processes in different namespaces can share the same PID and can't see each other in the /proc filesystem.
* User namespaces: User and group IDs are only valid within a single namespace. A process may be running as root in one namespace and have no special powers in another.
* IPC namespaces: It is possible to isolate shared memory segments and message queues using IPC namespaces.
* Chroots: Could be considered "file namespaces" but strictly speaking they are not the same thing. Also a lot older.

It should be possible to create very light weight virtual machines that share the same kernel.
Unfortunately, I did not find any good user space tooling for these namespaces other than ip netns.
There is also some weird interaction between chroots and network namespaces that I don't completely understand:
`ip netns exec foo chroot /some/chroot/dir /bin/sh`
will put the /bin/sh in the default network namespace.

Or we could go all the way and use real VMs, with all their additional benefits and some extra cost in disk space and performance.
It's also a balance between security and maintainability, if I have a physical machine with 6 VMs, I actually have to maintain 7 machines.
Qubes can also help with many of these problems.

[handbook-disks]: https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks
[handbook-stage]: https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage
[xts]: https://en.wikipedia.org/wiki/Disk_encryption_theory#XEX-based_tweaked-codebook_mode_with_ciphertext_stealing_.28XTS.29
[ewontfix-systemd]: http://ewontfix.com/14/
