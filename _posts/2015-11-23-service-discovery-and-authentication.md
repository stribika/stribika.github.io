---
layout: post
title: "Service discovery and authentication"
tags: [java,security,zookeeper,tls]
---

# Service discovery

[ZooKeeper][zk] is a popular choice for service discovery in distributed systems.
It is a hierarchical key-value store with very strong consistency guarantees.
What makes it a good choice for service discovery is its capability to create temporary tree nodes that disappear when the session that created it is disconnected.
Another important feature is sequential nodes - nodes that have a consistent counter appended to their name.
You can use these for implementing distributed locking for example.

The exact details of implementing a [service discovery protocol][zksvc] using ZooKeeper is outside the scope of this document.
I want to describe it in enough details so that we can understand its security properties.
Each service that's running and ready to respond to requests opens a persistent connection to Zookeeper.
What usually happens is there is a root node, say /services, and it creates a temporary, sequential node:

<code>
/services/foo-service-1 = https://somehost.inthecloud.internal:6666
/services/foo-service-3 = https://otherhost.inthecloud.internal:12345
</code>

If you want to talk to this foo-service, you look in this root node and retrieve all the registered foo-service hostnames.
You pick one randomly, or using round-robin, or what have you, and talk to that.
If it fails, you try another.
If you shut down foo-service, or it crashes, the temporary node is removed and other services will no longer try to talk to it.

# Authenticating hostnames

In the example above, we are using HTTPS URLs, so you probably want some kind of internal CA to sign the certificates.
(You might want to use some different protocol, Kerberos maybe.)
You connect to the host and you can be sure it's really that host, no one is eavesdropping, all the good things.

There are two problems with this.
First, you are using Zookeeper because you don't want to care about what host is running which service.
You certainly don't want to sign a new certificate for each one, deploy the private key to that host, etc.
You can do this.
It is possible.
You can even automate it if you don't mind having an online CA, that is not only easier to abuse, but also limits your availability.

The second, and even more important problem is _authenticating the wrong thing_.
What if ZooKeeper lies to you?
What if a compromised service publishes a hostname for some other service?
You connect to that, verify that its certificate is correct, and proceed talking to the wrong service without noticing anything is wrong.
Now, ZooKeeper is capable of controlling who can write what node, so you can create a structure like this:

<code>
/services/foo-service/foo-service-1 = https://a.inthecloud.internal:6666
/services/foo-service/foo-service-3 = https://b.inthecloud.internal:12345
/services/bar-service/bar-service-0 = https://c.inthecloud.internal:6666
/services/baz-service/baz-service-2 = https://d.inthecloud.internal:4444
</code>

You have to set up the permissions so that no one can write /services, the user running foo-service can only write /services/foo-service, etc.
This still doesn't help if Zookeeper itself is compromised.

This way we must trust Zookeeper and the CA.

# Authenticating service names

There is a better way.
We don't care about the hostname, the same way we don't care about the IP address.
We don't sign certificates for IP addresses.
We can sign a certificate for the service name, as in, CN=foo-service.
Actually, we don't even have to sign it - the (self-signed) certificate can be included with the code of its clients.

The main disadvantage of this approach is having to write custom certificate validation code, which I have done in Java.
In Java it's actually pretty simple, the interfaces of interest are [X509KeyManager][keyman] and [X509TrustManager][trustman].
Some of the methods relating to CAs will be simple stubs.
There are "extended" versions of both, with more methods you don't need.
I will publish the code, but I did this at work, and have not had time to reimplement it in the public domain.

This way we don't have to trust Zookeeper, and we don't have to trust the CA either (we don't have one).
The only thing we do have to trust is that the certificates included in the code are correct, but if someone can change that, they can change the code too.

There is still the matter of deploying the private keys to the hosts, but now it can be the same one for each instance of the same service.
This could be on a NAS, or scp'd to the local machine before starting the service that needs it.
Obviously we also have to trust that the ACLs will protect the private key but this is no worse than the previous method.

# Authenticating the client

We must not forget to authenticate the client certificate as well.
This is usually not done for browsers, but for inter-service traffic it is essential.
You might want to use a different CN if the same service is sometimes the server and sometimes the client.
Or you can use the same certificate but I don't recommend it.
If they are different you can use the CA system for client authentication and use the embedded cert system for server authentication.
Either way, this means you have to embedd the certificate of the client in the server code.

There are all these certificates embedded everywhere.
It doesn't sound too maintainable, but what's really going on here is each service consists of 3 files:

- A server JAR that runs the server and doesn't contain any certs.
- A client JAR that's a library imported by the clients, and contains the cert for the service.
- A certificate, to be used for client authentication. (Or not, you could use a CA here.)

It's not that bad.

[keyman]: https://docs.oracle.com/javase/8/docs/api/javax/net/ssl/X509KeyManager.html
[trustman]: https://docs.oracle.com/javase/8/docs/api/javax/net/ssl/X509TrustManager.html
[zk]: https://zookeeper.apache.org/
[zksvc]: http://blog.arungupta.me/zookeeper-microservice-registration-discovery/
