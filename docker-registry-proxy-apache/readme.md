# Apache+ AD + Docker Registry

Need that to authenticate to a docker registry over https

First turn up a registry (or however you do it):

```bash
# First, you start your registry. It is named so we may nicely link to it later
# NOTE: We DO NOT expose the port 5000 mapping -- this container does not allow for direct
#       host access. The only way to this registry is through the proxies private link.
docker run -d --name backend registry
docker run -d --name frontend \
   --link backend:backend
   -e ENV_DOCKER_REGISTRY_HOST=backend \
   -e ENV_DOCKER_REGISTRY_PORT=5000 \
    konradkleine/docker-registry-frontend
```

This will be `link`ed to the proxy later, so keep its name in mind.

Next, setup your `config.env` for this proxy container:

```bash
# The hostname for the apache instance (should match SSL certs)
PROXY_HOSTNAME="registry.domain"

# How much log output do you want? See LogLevel apache directive
PROXY_LOG_LEVEL=debug

```

Finally, start:

```bash
docker run -d \
 -v `pwd`/certs:/srv/certs \
 -p 443:443 \
 --env-file=config.env \ 
 --link backend:backend \
 --link frontend:frontend \
 --name registry-proxy-apache \
 zimboboyd/registry-proxy-apache
```

_Note:_ The registry must be named "backend" inside the container so apache forwards to 
the correct location.
_Note:_ The ui must be named "frontend" inside the container so apache forwards to 
the correct location.

