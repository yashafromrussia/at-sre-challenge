package main

import (
	"log/slog"
	"net/http"
	"os"

	chi "github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

type Config struct {
	Port    string `env:"APP_PORT" envDefault:"3000"`
	AppName string `env:"APP_NAME" envDefault:"airtasker"`
}

// TODO: Use a library like https://github.com/caarlos0/env to load environment variables if needed.
// For simplicity, this example uses os.Getenv directly.
func config() Config {
	port := os.Getenv("APP_PORT")
	if port == "" {
		port = "3000"
	}

	appName := os.Getenv("APP_NAME")
	if appName == "" {
		appName = "airtasker"
	}

	return Config{
		Port:    port,
		AppName: appName,
	}
}

func main() {
	cfg := config()

	handler := slog.NewJSONHandler(os.Stdout, nil)
	logger := slog.New(handler).With(
		"appName", cfg.AppName,
		"port", cfg.Port,
	)
	router := chi.NewRouter()

	logger.Info("Starting server")

	router.Use((middleware.Logger))

	router.Get("/", func(w http.ResponseWriter, r *http.Request) {
		hostname, _ := os.Hostname()

		// Set the header to indicate which server handled the request
		w.Header().Set("X-Served-By", hostname)

		w.Write([]byte(cfg.AppName))
	})
	router.Get("/healthcheck", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("OK"))
	})

	err := http.ListenAndServe(":"+cfg.Port, router)

	if err != nil {
		logger.Error("Server received an error", "error", err)
		os.Exit(1)
	}
}
