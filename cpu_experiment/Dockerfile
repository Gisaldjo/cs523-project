FROM ubuntu

RUN apt-get update && apt-get install -y curl
RUN curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | bash
RUN apt-get -y install sysbench
ENTRYPOINT ["sysbench", "cpu", "--cpu-max-prime=30000000", "--threads=16", "run"]
