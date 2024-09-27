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
		<title>Hello I am a multi layered built image</title>
	</head>
	<body>
		Hello Gopher </br>
		I am a multi layered built image.
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
