## Oracle Instant-Client drivers

In order to install the OCI and PDO_OCI extensions, you need to obtain the Oracle Instant-Client drivers (v18.5) from their website:

<https://www.oracle.com/technetwork/database/database-technologies/instant-client/overview/index.html>

Since we are working with a 64 bit Linux image, the files we need can be found here:

<https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html>

Our base image is based on Ubuntu, but the driver files are distributed as `.rpm` ones. The installation files have to be converted from `.rpm` to `.deb`. That can be done with the `alien` tool:

    sudo alien oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm  
    sudo alien oracle-instantclient18.5-devel-18.5.0.0.0-3.x86_64.rpm

The Dockerfile expects the Oracle files to be found here. We have included empty dummy files in this repository, but you should replace those by the right ones from the Oracle website.
