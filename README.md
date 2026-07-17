# Snippet-Go-Box

[![Go Version](https://img.shields.io/badge/Go-1.23+-00ADD8?style=for-the-badge&logo=go)](https://go.dev/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

A secure, performant, and fully containerized web application for creating and sharing text snippets. Built with modern Go best practices, featuring robust session management, CSRF protection, and a multi-stage Docker build.

---

## Features

- **Modern Go Architecture:** Utilizes Go 1.23+ `http.ServeMux` method routing and `embed.FS` for zero-dependency static asset serving.
- **Security First:** Implements `bcrypt` password hashing, `nosurf` CSRF protection, secure HTTP headers, and session token renewal.
- **Production-Ready Docker:** Multi-stage Dockerfile yielding a tiny, secure Alpine runtime image.
- **Automated Database Setup:** Docker Compose configuration with health checks and automatic schema initialization.
- **Comprehensive Testing:** Includes integration tests with mock databases and isolated HTTP test servers.
- **Structured Logging:** Native `log/slog` JSON logging for easy observability and debugging.

---

## Tech Stack

| Category | Technology |
| :--- | :--- |
| **Language** | Go 1.23+ |
| **Database** | MySQL 8.0 |
| **Containerization** | Docker & Docker Compose |
| **Session Management** | `github.com/alexedwards/scs` |
| **Form Decoding** | `github.com/go-playground/form/v4` |
| **CSRF Protection** | `github.com/justinas/nosurf` |
| **Password Hashing** | `golang.org/x/crypto/bcrypt` |

---

## Quick Start

The easiest way to run this project is using Docker Compose. This single command spins up the Go application, a MySQL database, and automatically initializes the database schema.

### 1. Prerequisites
Ensure you have the following installed:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (includes Docker Compose)
- [OpenSSL](https://www.openssl.org/) (for generating local TLS certificates)

### 2. Clone the Repository
```bash
git clone https://github.com/MihoZaki/Snippet-Go-Box.git
cd Snippet-Go-Box
```

### 3. Generate Local TLS Certificates
The application enforces HTTPS. For local development, generate a self-signed certificate:
```bash
mkdir -p tls
openssl req -x509 -newkey rsa:4096 -keyout tls/key.pem -out tls/cert.pem -days 365 -nodes -subj "/CN=localhost"
```

### 4. Start the Application
Build and start the containers:
```bash
docker compose up --build
```
> **Pro Tip:** The Go application is configured to wait for the MySQL database to pass its health check before starting, preventing connection refused errors.

### 5. Access the Application
Open your browser and navigate to:
 **[https://localhost:4000](https://localhost:4000)**

*(Note: Your browser will show a "Your connection is not private" warning due to the self-signed certificate. This is expected. Click **Advanced** → **Proceed to localhost** to continue).*

### Default Test Credentials
Your database is pre-seeded with a test user:
- **Email:** `alice@example.com`
- **Password:** `pa$$word`

---

## Environment Variables

The application is configured via environment variables, loaded from the `.env` file when using Docker Compose.

| Variable | Description | Default / Example |
| :--- | :--- | :--- |
| `DB_USER` | MySQL database username | `root` |
| `DB_PASSWORD` | MySQL database password | `supersecretpassword` |
| `DB_NAME` | MySQL database name | `snippetbox` |
| `DB_HOST` | MySQL host (use `db` for Docker) | `db` |
| `DB_PORT` | MySQL port | `3306` |
| `DB_PARSE_TIME` | Parse time values from MySQL | `true` |

---

## Project Structure

```text
├── cmd/web/               # Application entry point, handlers, and middleware
├── internal/              # Private application code (not importable externally)
│   ├── assert/            # Custom testing assertions
│   ├── models/            # Database models, interfaces, and business logic
│   └── validator/         # Form validation utilities
├── ui/                    # Embedded UI assets (HTML templates, CSS, JS)
├── tls/                   # TLS certificates (generated locally, gitignored)
├── docker-compose.yml     # Multi-service orchestration configuration
├── Dockerfile             # Multi-stage Docker build configuration
└── go.mod                 # Go module dependencies
```

---

## Testing

To run the unit and integration tests:

```bash
# Run all tests
go test ./...

# Run tests with verbose output
go test -v ./...

# Run tests, skipping long-running database integration tests
go test -short ./...
```

---

## License

This project is open-source and available under the [MIT License](LICENSE).
