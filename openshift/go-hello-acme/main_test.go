package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestHandler(t *testing.T) {
	tests := []struct {
		name       string
		method     string
		path       string
		statusCode int
		body       string
	}{
		{
			name:       "greeting",
			method:     http.MethodGet,
			path:       "/",
			statusCode: http.StatusOK,
			body:       "Hello Acme!",
		},
		{
			name:       "health check",
			method:     http.MethodGet,
			path:       "/healthz",
			statusCode: http.StatusOK,
			body:       "ok",
		},
		{
			name:       "not found",
			method:     http.MethodGet,
			path:       "/missing",
			statusCode: http.StatusNotFound,
		},
		{
			name:       "unsupported method",
			method:     http.MethodPost,
			path:       "/",
			statusCode: http.StatusMethodNotAllowed,
		},
	}

	handler := newHandler()
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			request := httptest.NewRequest(test.method, test.path, nil)
			response := httptest.NewRecorder()

			handler.ServeHTTP(response, request)

			if response.Code != test.statusCode {
				t.Fatalf("status = %d, want %d", response.Code, test.statusCode)
			}
			if !strings.Contains(response.Body.String(), test.body) {
				t.Errorf("body %q does not contain %q", response.Body.String(), test.body)
			}
		})
	}
}
