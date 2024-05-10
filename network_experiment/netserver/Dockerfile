FROM networkstatic/netserver

RUN apt-get update && apt-get install -y iproute2
COPY netserver_run.sh /
RUN chmod +x /netserver_run.sh
VOLUME [ "/logs" ]
ENTRYPOINT ["/bin/bash", "-c", "/netserver_run.sh \"$@\""]
