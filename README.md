# base-pdo-oci

Creation of a Docker base image with Apache + PHP 7.2 + PDO_OCI



## Useful Docker commands:
If you want to generate the Docker image from the Dockerfile:

```sh
$ docker build -t "base-pdo-oci" .
```

If you prefer, you can load the image from [DockerHub](https://hub.docker.com/r/jap1968/base-pdo-oci) and then start the Apache web server:

```sh
$ docker run --rm -d -p 9099:80 jap1968/base-pdo-oci /usr/sbin/apache2ctl -D FOREGROUND
```

Once you have your container up and running, you can open your browser and point to the [testing address](http://localhost:9099/info.php) to verify that everything is working as expected.
