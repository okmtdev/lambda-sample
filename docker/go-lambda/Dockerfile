FROM golang:1.22.7-alpine3.20 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY main.go /app/main.go
RUN go build -o main /app/main.go

FROM alpine:3.13
WORKDIR /app
COPY --from=builder /app/main .
COPY .env.dev /app/.env
EXPOSE 1323
CMD [ "/app/main" ]