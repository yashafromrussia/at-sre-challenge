package main

import (
	"log"
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
	router := chi.NewRouter()

	router.Use((middleware.Logger))

	router.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(cfg.AppName))
	})
	router.Get("/healthcheck", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("OK"))
	})

	http.ListenAndServe(":"+cfg.Port, router)

	log.Printf("Server is running on port %s", cfg.Port)
}
