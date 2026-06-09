# ==========================================
# Stage 1: Build the Go binary
# ==========================================
FROM golang:1.23-alpine AS builder

WORKDIR /app

# 1. Copy only the dependency files first.
# This is a Docker best practice: if go.mod/go.sum haven't changed, 
# Docker uses the cached layer and skips downloading dependencies again.
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# 2. Copy the rest of the source code
COPY . .

# 3. Build the binary
# CGO_ENABLED=0 tells Go to build a purely static binary (no C dependencies).
# Since our MySQL driver is pure Go, this works perfectly and keeps the image small.
RUN CGO_ENABLED=0 GOOS=linux go build -o snippetbox ./cmd/web


# ==========================================
# Stage 2: Create the minimal runtime image
# ==========================================
FROM alpine:latest

WORKDIR /app

# Install ca-certificates (crucial for TLS/HTTPS) and tzdata (for timezones)
RUN apk --no-cache add ca-certificates tzdata

# Copy ONLY the compiled binary from the 'builder' stage
COPY --from=builder /app/snippetbox .

# Expose the port your app listens on
EXPOSE 4000

# Command to run when the container starts
CMD ["./snippetbox"]
