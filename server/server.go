// A tiny static file server for the built MkDocs site. Standard library only, so
// it compiles to a static binary that runs on distroless/static (non-root, 0 deps).
package main

import (
	"log"
	"net/http"
	"os"
	"time"
)

func main() {
	dir := getenv("SITE_DIR", "/site")
	port := getenv("PORT", "8080")

	mux := http.NewServeMux()
	mux.HandleFunc("/healthz", health)
	mux.HandleFunc("/readyz", health)
	mux.Handle("/", secureHeaders(http.FileServer(http.Dir(dir))))

	srv := &http.Server{
		Addr:              ":" + port,
		Handler:           mux,
		ReadHeaderTimeout: 5 * time.Second,
	}
	log.Printf("serving %s on :%s", dir, port)
	if err := srv.ListenAndServe(); err != nil {
		log.Fatal(err)
	}
}

func health(w http.ResponseWriter, _ *http.Request) {
	_, _ = w.Write([]byte("ok"))
}

func secureHeaders(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.Header().Set("X-Frame-Options", "DENY")
		w.Header().Set("Referrer-Policy", "no-referrer")
		next.ServeHTTP(w, r)
	})
}

func getenv(k, def string) string {
	if v := os.Getenv(k); v != "" {
		return v
	}
	return def
}
