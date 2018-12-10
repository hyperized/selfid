FROM golang:latest as builder
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN go get -d -v ./...
RUN go build -ldflags "-linkmode external -extldflags -static" -a main.go

FROM alpine
RUN apk add --no-cache bash gawk sed grep bc coreutils
ADD . /
COPY --from=builder /app/main /main
CMD ["/main"]
