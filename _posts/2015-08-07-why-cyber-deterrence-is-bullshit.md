---
layout: post
title: "Why cyber deterrence is bullshit"
tags: [bullshit, cybercybercyber, deterrence]
---

You may have heard of [this brilliant idea](https://uk.businessinsider.com/us-retaliation-against-china-for-opm-hacks-2015-8).
That's right, "hack back" as foreign policy.
It does not and will never work.

The reasons why this is utter bullshit should be all too obvious, but my Twitter account is locked and I have nothing better to do, so here goes:

1. *The word cyber.*
   Whenever you hear it, question the speaker's competence.
1. *Easy access.*
   To build nuclear weapons, you need: relatively rare fissionable materials, huge enrichment facilities, knowledge, and ICBMs.
   To hack, you need: a computer, electricity, knowledge, and Internet access.
   You may be able to deter a few rational entities capable of building nukes, but not every single child capable of hacking OPM.
   There is nothing even close to perfect rationality on the Internet.
1. *Attribution.*
   Radars and satellites can clearly show where the missiles are coming from.
   No such device exists for detecting the origin of a breach.
   Attribution is purely guesswork, based on things like the language of strings found in the malware, source IPs, etc.
   It's like sending a postcard, then trying to figure out who read it.
   Does that sound like perfect detection?
1. *Working defense.*
   Missile defense systems are actually more dangerous that the nukes they are trying to defend against.
   This is because they have a [very interesting property](https://en.wikipedia.org/wiki/Pre-emptive_nuclear_strike#Destabilizing_role_of_missile_defense):
   They reduce the second strike capability of one side, making counterforce first strike the logical choice for the other.
   The reason we are still all here, reading this post, is because covering large areas with such defenses is not feasible.
   This is not the case for defending computers against intrusion.
   Yes, attackers have a clear advantage over defenders, that is to say, hacking will always be possible.
   But it is significantly more difficult, and the effect less devastating, if the opponent just doesn't have an OPM equivalent.
   There goes your second strike.
1. *It is not a fucking weapon.*
   The damage caused by even the worst breaches is nowhere near the damage caused by a thermonuclear explosion.
   Even conventional weapons cause more damage, and are more scary.
   This is also supported by the fact that no sane person would risk armed conflict over hacking incidents.
   No one is afraid of getting pwned.

Today's attackers don't even need their advantage.
They get in because we let them.
We should focus on exploit mitigation (Grsecurity), isolation (Qubes), sandboxed multiprocess architectures (Chrome, qmail), encryption, and fixing shit.
Instead we are wasting time trying to make the attribution dice work, listening to fumbling idiots threaten the Chinese, and looking for a magic security device that solves everything if we just connect it to the network.

We know what to do and we know how to do it.
