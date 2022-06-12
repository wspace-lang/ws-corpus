FROM alpine as builder

RUN apk add git make gcc musl-dev
RUN git clone https://github.com/StrangePan/I_C_Whitespace
WORKDIR /I_C_Whitespace
RUN make

FROM scratch as runner

COPY --from=builder /I_C_Whitespace/whitespace /
ENTRYPOINT ["/whitespace"]