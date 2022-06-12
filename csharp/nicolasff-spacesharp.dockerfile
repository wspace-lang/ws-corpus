FROM mono as builder

RUN apt-get update
RUN apt-get install -y git make flex bison
RUN git clone https://github.com/nicolasff/spacesharp
WORKDIR /spacesharp
RUN make MCS=mcs

FROM scratch as runner

COPY --from=builder /spacesharp/wsc.exe /
ENTRYPOINT ["/wsc.exe"]