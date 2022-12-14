# sonatype/docker-nexus

Docker images for Sonatype Nexus Repository Manager 2 with the OpenJDK, starting with 2.14.14 the [Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image) is used as the base image while earlier versions used CentOS.
For Nexus Repository Manager 3, please refer to https://github.com/sonatype/docker-nexus3

- [sonatype/docker-nexus](#sonatypedocker-nexus)
  - [Notes](#notes)
    - [Persistent Data](#persistent-data)
    - [Adding Nexus Plugins](#adding-nexus-plugins)
    - [Build Args](#build-args)
  - [Getting Help](#getting-help)

To build:
```
# docker build --rm --tag sonatype/nexus oss/
# docker build --rm --tag sonatype/nexus-pro pro/
```

To run (if port 8081 is open on your host):

```
# docker run -d -p 8081:8081 --name nexus sonatype/nexus:oss
```

To determine the port that the container is listening on:

```
# docker ps -l
```

To test:

```
$ curl http://localhost:8081/nexus/service/local/status
```

To build, copy the Dockerfile and do the build:

```
$ docker build --rm=true --tag=sonatype/nexus .
```


## Notes

* The UI is accessible at: http://localhost:8081/nexus/

* Default credentials are: `admin` / `admin123`

* It can take some time (2-3 minutes) for the service to launch in a
new container.  You can tail the log to determine once Nexus is ready:

```
$ docker logs -f nexus
```

* Installation of Nexus is to `/opt/sonatype/nexus`.  Notably:
  `/opt/sonatype/nexus/conf/nexus.properties` is the properties file.
  Parameters (`nexus-work` and `nexus-webapp-context-path`) defined
  here are overridden in the JVM invocation.

* A persistent directory, `/sonatype-work`, is used for configuration,
logs, and storage. This directory needs to be writeable by the Nexus
process, which runs as UID 200.

* Environment variables can be used to control the JVM arguments

  * `CONTEXT_PATH`, passed as -Dnexus-webapp-context-path.  This is used to define the
  URL which Nexus is accessed.  Defaults to '/nexus'
  * `MAX_HEAP`, passed as -Xmx.  Defaults to `768m`.
  * `MIN_HEAP`, passed as -Xms.  Defaults to `256m`.
  * `JAVA_OPTS`.  Additional options can be passed to the JVM via this variable.
  Default: `-server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true`.
  * `LAUNCHER_CONF`.  A list of configuration files supplied to the
  Nexus bootstrap launcher.  Default: `./conf/jetty.xml ./conf/jetty-requestlog.xml ./conf/jetty-http.xml`

 To run 
  ```
  docker-compose up --build
  ```

 To verify 
  ```
  ./validate.sh
  ```



### Persistent Data




### Adding Nexus Plugins

Creating a docker image based on `sonatype/nexus` is the suggested
process: plugins should be expanded to `/opt/sonatype/nexus/nexus/WEB-INF/plugin-repository`.
See https://github.com/sonatype/docker-nexus/issues/9 for an example
concerning the Nexus P2 plugins.

### Build Args

Each Dockerfile contains two build arguments (`NEXUS_VERSION` & `NEXUS_DOWNLOAD_URL`) that can be used to customize what
version of, and from where, Nexus Repository Manager is downloaded. This is useful mostly for testing purposes as the
Dockerfile may be dependent on a very specific version of Nexus Repository Manager.

```
docker build --rm --tag nexus-custom-oss --build-arg NEXUS_VERSION=2.x.y --build-arg NEXUS_DOWNLOAD_URL=http://.../nexus-2.x.y-bundle.tar.gz oss/
docker build --rm --tag nexus-custom-pro --build-arg NEXUS_VERSION=2.x.y --build-arg NEXUS_DOWNLOAD_URL=http://.../nexus-professional-2.x.y-bundle.tar.gz pro/
```

## Getting Help

Looking to contribute to our Docker image but need some help? There's a few ways to get information or our attention:

* File a public issue [here on GitHub](https://github.com/sonatype/docker-nexus/issues)
* Check out the [Nexus](http://stackoverflow.com/questions/tagged/nexus) tag on Stack Overflow
* Check out the [Nexus Repository User List](https://groups.google.com/a/glists.sonatype.com/forum/?hl=en#!forum/nexus-users)
