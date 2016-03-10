package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
)

func helloHandler(res http.ResponseWriter, req *http.Request) {
	res.Header().Set(
		"Content-Type",
		"text/html",
	)
	io.WriteString(
		res,
		`<!doctype html>
		<html>
	<head>
		<title>Hello Gopher</title>
	</head>
	<body>
		Hello Gopher </br>
		It is really awesome that both Docker and Kubernetes are written in Go!
	</body>
</html>`,
	)
}
func defaultHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Go web app powered by Docker")
}
func main() {
	http.HandleFunc("/", defaultHandler)
	http.HandleFunc("/hello", helloHandler)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
		return
	}
}
