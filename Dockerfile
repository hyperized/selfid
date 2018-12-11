FROM golang:latest as builder
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN go get -d -v ./...
RUN go build -ldflags "-linkmode external -extldflags -static" -a main.go

FROM alpine
RUN apk add --no-cache bash gawk sed grep bc coreutils netcat-openbsd
ADD . /
COPY --from=builder /app/main /main
HEALTHCHECK --interval=5s --timeout=3s CMD nc localhost 8081
CMD ["/main"]
