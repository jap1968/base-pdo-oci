# base-pdo-oci

Creation of a Docker base image with Apache + PHP 7.2 + PDO_OCI



## Useful Docker commands:
```
docker build -t "myown/base-pdo-oci" .

docker run --rm -d -p 9099:80 --name base-pdo-oci_1 myown/base-pdo-oci
docker run --rm -d -p 9099:80 --name base-pdo-oci_1 myown/base-pdo-oci /usr/sbin/apache2ctl -D FOREGROUND

docker exec -it base-pdo-oci_1 /bin/bash
docker stop base-pdo-oci_1
```
