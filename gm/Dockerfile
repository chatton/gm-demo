FROM golang:1.21-alpine3.18 as builder

RUN set -eux; apk add --no-cache git libusb-dev linux-headers gcc musl-dev make;

ENV GOPATH=""
ADD . .

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -mod=readonly -tags "netgo ledger muslc" -ldflags '-X github.com/cosmos/cosmos-sdk/version.Name=gm -X github.com/cosmos/cosmos-sdk/version.AppName=gmd -X github.com/cosmos/cosmos-sdk/version.Version= -X github.com/cosmos/cosmos-sdk/version.Commit= -X "github.com/cosmos/cosmos-sdk/version.BuildTags=netgo ledger muslc," -w -s -linkmode=external -extldflags "-Wl,-z,muldefs -static"' -trimpath -o /go/build/ ./...

FROM alpine:3.18

RUN set -eux; apk add --no-cache curl jq;

COPY --from=builder /go/build/gmd /bin/gmd

ENTRYPOINT ["gmd"]
