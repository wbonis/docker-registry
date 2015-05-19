# Apache + LDAP + AD + Docker Registry

Want to put LDAP in front of your Docker Registry? Need that to authenticate via LDAP to 
an Active Directory instnace? Sounds like you work in a fun place! Here's a nice little 
container to help you along ;D

First turn up a registry (or however you do it):

```bash
# First, you start your registry. It is named so we may nicely link to it later
# NOTE: We DO NOT expose the port 5000 mapping -- this container does not allow for direct
#       host access. The only way to this registry is through the proxies private link.
docker run -d --name registry registry
```

This will be `link`ed to the proxy later, so keep its name in mind.

Next, setup your `config.env` for this proxy container:

```bash
# The hostname for the apache instance (should match SSL certs)
PROXY_HOSTNAME="registry.domain"

# How much log output do you want? See LogLevel apache directive
PROXY_LOG_LEVEL=debug

# Your LDAP host/connection string and connection type (NONE|SSL|TLS|STARTTLS)
PROXY_LDAP_ADDR="ldap://domain:port/OU=ou,DC=dc?sAMAccountName?sub?(objectClass=*)"
PROXY_LDAP_CONNTYPE=SSL

# The account that will do the lookup from apache
PROXY_BIND_DN="user@domain"
PROXY_BIND_PASSWORD="password-here"

# If you are using self-signed certs on your LDAP/AD you may need this
PROXY_LDAP_CERT_VERIFY=On
PROXY_LDAP_CERT_TYPE=CA_BASE64
PROXY_LDAP_CERT_PATH=/srv/certs/ca.pem
```

Collect your SSL certificates that apache will use, place them into a folder and name them:

  1. `certificate.crt`: The pem certificate for the domain
  1. `private.key`: The key for the certificate (no password, aka nodes) 
  1. `cachain.crt`: The certificate ca chain

> **OPTIONAL:** The CA cert which can verify the ldap connection should be available 
> so that you can mount it into the container. The example below uses this approach.

Finally, start 'er up:

```bash
docker run -d \
 -v `pwd`/certs:/srv/certs \
 -p 443:443 \
 --env-file=config.env \ 
 --link registry:registry \
 --name drpa \
 creditkarma/drpa
```

_Note:_ The registry must be named "registry" inside the container so apache forwards to 
the correct location.
