FROM golang:1.21-alpine3.18 as builder

RUN set -eux; apk add --no-cache git libusb-dev linux-headers gcc musl-dev make;

ENV GOPATH=""
ADD . .

RUN go mod download

# build tag nolink_libwasmvm allows for consuming only 08-wasm types
RUN make build BUILD_TAGS="nolink_libwasmvm"

FROM alpine:3.18

RUN set -eux; apk add --no-cache curl jq;

COPY --from=builder /go/build/gmd /bin/gmd

ENTRYPOINT ["gmd"]
