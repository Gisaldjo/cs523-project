FROM networkstatic/netperf

RUN apt-get update && apt-get install -y iproute2
COPY netperf_run.sh /
RUN chmod +x /netperf_run.sh
VOLUME [ "/logs" ]
ENTRYPOINT ["/bin/bash", "-c", "/netperf_run.sh \"$@\""]
