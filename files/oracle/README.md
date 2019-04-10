## Oracle Instant Client drivers

In order to install the OCI and PDO_OCI extensions, you need to obtain the Oracle Instant-Client drivers (v18.5) from their website:

<https://www.oracle.com/technetwork/database/database-technologies/instant-client/overview/index.html>

Our Docker image is built on top of a 64 bit Linux image, so the files we need can be found here:

<https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html>

According to the manufacturer, there are two versions of the driver:
* Basic Package - All files required to run OCI, OCCI, and JDBC-OCI applications
* Basic Light Package - Smaller version of the Basic package, with only English error messages and Unicode, ASCII, and Western European character set support.

Since we are working just with western European character sets, we have built our image with the *Basic Light Package* version.
