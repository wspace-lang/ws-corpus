FROM alpine as builder

RUN apk add git make gcc musl-dev flex
RUN git clone https://github.com/wspace/rdebath-c whitespace
WORKDIR /whitespace
RUN make

FROM scratch as runner

COPY --from=builder /whitespace/ws2c /
COPY --from=builder /whitespace/wsa /
ENTRYPOINT ["/ws2c"]