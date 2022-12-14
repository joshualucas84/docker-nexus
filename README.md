# sonatype/docker-nexus

Docker images for Sonatype Nexus Repository Manager 2 with the OpenJDK, starting with 2.14.14 the [Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image) is used as the base image while earlier versions used CentOS.
For Nexus Repository Manager 3, please refer to https://github.com/sonatype/docker-nexus3

- [sonatype/docker-nexus](#sonatypedocker-nexus)
  - [Notes](#notes)
    - [Persistent Data](#persistent-data)
    - [Adding Nexus Plugins](#adding-nexus-plugins)

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
