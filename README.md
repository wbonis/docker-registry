docker-registry
===============


## A Docker Registry with apache and SSL and authentication

To Generate a CA and a Certificat for your Server:

```bash
./gen_ca_and_cert.sh
```

To Install docker-compose:
```bash
curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose 
chmod +x /usr/local/bin/docker-compose
```

To Start:
```bash
docker-compose up
```

Then you can reach the UI at: https://ip.of.dockerhost:5000/ui/ (The Username is admin:admin)

you can upload a image to your server with:

```bash
docker pull busybox
# You can also use reg.you.doamin:5000 if that URL is reachable from outside
docker tag  busybox localhost:5000/busybox
# The defaul Username is admin:admin 
# You can change if with htpasswd or openssl password in certs/passwd
# It will be over SSL/HTTPS
docker login localhost:5000
docker push  localhost:5000/busybox
```



