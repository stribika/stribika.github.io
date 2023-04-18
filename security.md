---
layout: page
title: Vulnerability Disclosure Policy
permalink: /security/
hidden: true
---

# Commitment

The organization is just me, I am committed to security, and not becoming a comic book villain by suing you guys.
I'm told I should have one of these policies, and it should include "Safe Harbor", "Important Guidelines", "Scope", and "Process".
So, here goes.

# Safe Harbor

If you make a good faith effort to comply with this policy during your security research, we will consider your research to be authorized.
We will work with you to understand and resolve the issue quickly, and we will not recommend or pursue legal action related to your research.
Should legal action be initiated by a third party scumbag against you for activities that were conducted in accordance with this policy, we will make this authorization known.

# Important Guidelines

Please notify us as soon as possible after a security vulnerability is found.
Proof of concept exploits SHALL have minimal impact that is sufficient to demonstrate the existence of a vulnerability.
Partial PoCs that do not breach all layers of defense are still appreciated.
We all know what a segfault at 0x4141414141414141 means, you don't have to spend a weekend getting the ROP chain to work.

# Scope

Any software hosted on [my github](https://github.com/stribika) is in scope.
Any service hosted under stribik.technology, strib.tech, or their subdomains is in scope.

Social engineering is not in scope.
This is because "we" are just me.
Social engineering is simply the act of lying to me, and "we" don't appreciate that kind of thing.

For similar reasons, physical access is not in scope either.

Denial of service that relies on merely saturating the pipe is not in scope.
It's not interesting and there is no possible way I could fix that.
All I can do is move the site behind Cloudflare for a while, and if you keep trying, you could literally break the Internet.
Low traffic denial of service is in scope but do you MUST NOT keep it going for an unreasonably long time.

# Process

The reporting process is very simple.
You SHALL send an email to [security@stribik.technology](mailto:security@stribik.technology), with enough information to identify and, if applicable, reproduce the issue.
You SHOULD encrypt said email with the [public key](/assets/about/security.gpg) provided here, using S/MIME.
If you do encrypt it, you MUST provide a reasonable way to obtain your public key.

We SHALL reply within 24 hours.
In this reply, we MAY ask you to wait an additional 24 hours before public disclosure.
After this time of at most 48 hours, you MAY disclose the vulnerability publicly.
After a further 24 hours (72 in total), you SHOULD disclose the vulnerablity publicly or we will.

You MAY request your name to be added to a special acknowledgements page.
If no such page exists, one will be created for you.
The name MUST be a non-empty unicode string no longer than 1 KiB.
It is an arbitrary value, it does not have to be your actual name.
The default is "Anonymous".
