---
layout: post
title: "Hardened Gentoo Handbook"
tags: [gentoo,linux,security]
---

Gentoo is a GNU/Linux distribution that compiles all packages from source.
The compilation process is highly configurable with USE flags and compiler options.
I like it because the packages are not that different from upstream and it's very easy to look at the patches or even create your own patches.
It is also exceptionally well integrated with Grsecurity which in my opinion is the state of the art exploit mitigation and mandatory access control system.
Having control over the compilation process means you can take full advantage of toolchain memory protections and ASLR.
One disadvantage of this approach is the increased package installation time and resource requirements.
It can get pretty bad with larger packages needing gigabytes of disk space and compiling for almost a day.

Gentoo has a hardened profile optimized for security.
It compiles everything with stack smashing protection, creates ET_DYN executables and compiles without JIT support whenever possible.
Portage, the package manager, also handles PaX flags for you by default.
(Don't worry if you don't understand these terms yet, everything will become clear.)
Gentoo has an excellent installation guide.
The one thing that's missing from it is how to install a hardened system from the start.
Following the handbook then switching later is somewhat inconvenient but it can be done.

This post is intended to be used alongside the Gentoo Handbook for those of us who want the most secure installation.
I'm going to assume AMD64 architecture here and link to the relevant pages of the AMD64 handbook.
You can probably follow the guide using on a different architecture.

[snowden-docs]: https://www.spiegel.de/international/germany/inside-the-nsa-s-war-on-internet-security-a-1010361.html
[dh]: https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange
[ecdh]: https://en.wikipedia.org/wiki/Elliptic_curve_Diffie%E2%80%93Hellman
[forward-secrecy]: https://en.wikipedia.org/wiki/Forward_secrecy
[dlp]: https://en.wikipedia.org/wiki/Discrete_logarithm_problem
[curve25519]: http://ed25519.cr.yp.to/
[rfc4253]: https://www.ietf.org/rfc/rfc4253.txt
[rfc4419]: https://www.ietf.org/rfc/rfc4419.txt
[nist-sucks]: http://blog.cr.yp.to/20140323-ecdsa.html
[bullrun]: https://projectbullrun.org/dual-ec/vulnerability.html
[ae]: https://en.wikipedia.org/wiki/Authenticated_encryption
[grsec]: https://grsecurity.net/
[tor-hs]: https://www.torproject.org/docs/hidden-services.html.en
