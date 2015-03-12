---
layout: post
title: "Rowhammering ElGamal"
tags: [crypto,elgamal,rowhammer,security]
---

I had this idea of combining a new hardware attack with an old cryptanalysis paper.
Specifically, using [Rowhammer][rowhammer] to flip bits in an ElGamal private key.
The usual approach is to target executable memory or the page table and hope for a change that makes the system exploitable.
I'm guessing this is not going to be stable because you need a change in particular and other changes may crash things.
But we'll see when Google releases their Chrome sandbox escape/kernel mode code execution details.
The attack described in [Fault Cryptanalysis of ElGamal Signature Scheme][fault-cryptanalysis] results in key recovery for *any* change in the private key.

# ElGamal signatures

Just a quick reminder on how [ElGamal][elgamal] works.
Nothing new here, feel free to skip ahead to the attack.
It's an asymmetric signature scheme based on the Discrete Logarithm Problem.

A large prime number, p, and a generator, g, defines a multiplicative group.
Choose a random integer, 1 < a < p - 2, as the private key, then compute the public key as y = g<sup>a</sup> mod p.

Normally signing works like so (m is the message to be signed):

1. Choose a random integer unique for each signature, 1 < k < p, so that k and p - 1 are relative primes.
1. r = g<sup>k</sup> mod p
1. s = k<sup>-1</sup> * (hash(m) - a * r) mod (p - 1)
1. If s == 0, then goto 1.
1. The pair (r, s) is the signature.

Verification looks kind of weird at first glance:

1. Check that 0 < r < p.
1. Check that 0 < s < p - 1.
1. Verify that g<sup>hash(m)</sup> = y<sup>r</sup> * r<sup>s</sup> mod p

But why? Solve the equation in step 3 of signing:

* hash(m) = a * r + s * k mod (p - 1)
* g<sup>hash(m)</sup> = g<sup>a * r</sup> * g<sup>s * k</sup> mod p
* g<sup>hash(m)</sup> = y<sup>r</sup> * r<sup>s</sup> mod p

Hey, how is that mod p, not mod (p - 1)?
It's [Fermat's][fermats-little-theorem] fault.

# Fault cryptanalysis attack

If _for some reason_ one of the secret key bits gets flipped in memory, then an incorrect signature is computed.
Not only will this signature fail to verify, it reveals the original value of the flipped bit.
Since the original paper is behind a paywall I repeat some of the results here.

A single bit error at the i-th bit of the secret key can be expressed as

{: style="font-size:125%; text-align:center;" }
a' = a ± 2<sup>i</sup>

This will result in an incorrect s:

{: style="font-size:125%; text-align:center;" }
s' = k<sup>-1</sup> * (hash(m) - a' * r) mod (p - 1)

From the incorrect signature (r, s') the attacker can calculate r<sup>s'</sup>.
Let's see why that's a problem.

{: style="font-size:125%; text-align:center;" }
r<sup>s'</sup> = (g<sup>k</sup>)<sup>k<sup>-1</sup> * (hash(m) - a' * r)</sup> mod (p - 1)

{: style="font-size:125%; text-align:center;" }
r<sup>s'</sup> = g<sup>k * k<sup>-1</sup> * (hash(m) - a' * r)</sup> mod (p - 1)

k * k<sup>-1</sup> is of course 1.

{: style="font-size:125%; text-align:center;" }
r<sup>s'</sup> = g<sup>hash(m) - r * a'</sup> mod (p - 1)

Substituting a' we get:

{: style="font-size:125%; text-align:center;" }
r<sup>s'</sup> = g<sup>hash(m) - r * (a ± 2<sup>i</sup>)</sup> mod (p - 1)

{: style="font-size:125%; text-align:center;" }
r<sup>s'</sup> = g<sup>hash(m) - r * a ∓ r * 2<sup>i</sup></sup> mod (p - 1)

{: style="font-size:125%; text-align:center;" }
r<sup>s'</sup> = g<sup>hash(m)</sup> * g<sup>-r * a</sup> * g<sup>∓r * 2<sup>i</sup></sup> mod (p - 1)

Notice that g<sup>-r * a</sup> = (g<sup>a</sup>)<sup>-r</sup> = y<sup>-r</sup>.

{: style="font-size:125%; text-align:center;" }
r<sup>s'</sup> = g<sup>hash(m)</sup> * y<sup>-r</sup> * g<sup>∓r * 2<sup>i</sup></sup> mod (p - 1)

Now you can solve for g<sup>∓r * 2<sup>i</sup></sup>.

{: style="font-size:125%; text-align:center;" }
g<sup>∓r * 2<sup>i</sup></sup> = r<sup>s'</sup> / g<sup>hash(m)</sup> / y<sup>-r</sup> mod (p - 1)

OK, so you need to know i and whether it's minus or plus.
But you still have to solve the DLP.
Or do you?
Remember, i is between 0 an the bit length of the secret key so you can just try them all.
Once you have e.g. +2<sup>5</sup>, you know that the fifth bit changed from 1 to 0.

You need to repeat this many times to recover most bit of the secret key.
(Actually way more than the paper estimates, since rowhammer changes the same cell with high probability.)
This is easy if the program is structured in such a way that you can start the attack with a fresh copy of the private key and corrupt just one bit.
The attack still works if you keep flipping more and more bits in the already corrupted key.
To understand this, let's see how flipping the j-th bit would affect the above calculation.
The more corrupt private key is

{: style="font-size:125%; text-align:center;" }
a'' = a ± 2<sup>i</sup> ± 2<sup>j</sup>

The two ± signs can be the same or opposite, it doesn't matter.
You can do the above calculation again with one extra term if you want, I typed enough sup tags for today.
The final equation solved for g<sup>∓r * 2<sup>j</sup></sup> will be:

{: style="font-size:125%; text-align:center;" }
g<sup>∓r * 2<sup>j</sup></sup> = r<sup>s''</sup> / g<sup>hash(m)</sup> / y<sup>-r</sup> / g<sup>∓r * 2<sup>i</sup></sup> mod (p - 1)

You already know i and one of the signs from the previous step, so you can try all the j values with both plus and minus again.
Even if you don't know i, it's still brute forceable which might be useful if you accidentally corrupt two bits at once.

# Rowhammer

The basic idea behind Rowhammer is that you can access certain DRAM cells repeatedly and sometimes the charge will leak into a nearby DRAM cell.
Cells on a DRAM chip are organized into rows, discharging and recharging (hammering) both neighbours of the target row will likely change the memory stored in that row, hence the name.
The neat or scary thing about this is the fact that it works regardless of any software or hardware access control.

To target anything, you need to know the memory layout of the process (/proc/$pid/maps) and how the virtual memory is mapped to physical memory (/proc/$pid/pagemaps).
Grsecurity protects both of these but there could be other, unexpected ways I'm not thinking of.
Obviously these mappings have to be randomized for hiding them to be meaningful, which /proc/$pid/maps is, /proc/$pid/pagemaps I don't think so.

The attack doesn't work on all RAM modules.
It doesn't work on ECC RAM but that's extremely expensive.
There's a [memtest fork][rowhammer-memtest] that can test your hardware and a [userspace testing utility][rowhammer-userspace-test] that works as any user.

[rowhammer]: http://www.rowhammer.com/
[rowhammer-memtest]: https://github.com/CMU-SAFARI/rowhammer
[rowhammer-userspace-test]: https://github.com/google/rowhammer-test
[elgamal]: https://en.wikipedia.org/wiki/ElGamal_signature_scheme
[fermats-little-theorem]: https://en.wikipedia.org/wiki/Fermat%27s_little_theorem#Generalizations
[fault-cryptanalysis]: http://link.springer.com/chapter/10.1007/11556985_43?no-access=true
