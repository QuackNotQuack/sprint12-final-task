FROM golang:1.25 AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/app ./

FROM scratch
WORKDIR /app

COPY --from=builder /app/app /app/app
COPY --from=builder /app/tracker.db /app/tracker.db

ENTRYPOINT ["/app/app"]
