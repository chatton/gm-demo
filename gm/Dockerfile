FROM golang:1.21-alpine3.18 as builder

RUN set -eux; apk add --no-cache git libusb-dev linux-headers gcc musl-dev make;

ENV GOPATH=""
ADD . .

RUN go mod download

RUN make build

FROM alpine:3.18

COPY --from=builder /go/build/gmd /bin/gmd

ENTRYPOINT ["gmd"]
