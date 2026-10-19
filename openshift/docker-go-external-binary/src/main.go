package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte("ok\n"))
	})

	http.HandleFunc("/", func(w http.ResponseWriter, _ *http.Request) {
		output, err := exec.Command("/usr/local/bin/runtime-helper").Output()
		if err != nil {
			log.Printf("required external binary failed: %v", err)
			http.Error(w, "required external binary is unavailable", http.StatusServiceUnavailable)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]string{
			"app":             "go-external-binary-app",
			"external_binary": string(output),
			"message":         "Go application is running with its external binary dependency",
		})
	})

	log.Printf("Listening on :%s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
