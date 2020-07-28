#!/bin/sh

cat<<EOF>lib.go
package main

import (
	"fmt"
	"bytes"
	"encoding/base64"
	"archive/zip"
	"log"
	"os"
)

func listFiles(file *zip.File) error {
	fileread, err := file.Open()
	if err != nil {
		msg := "Failed to open zip %s for reading: %s"
		return fmt.Errorf(msg, file.Name, err)
	}
	defer fileread.Close()
 
	fmt.Fprintf(os.Stdout, "%s", file.Name)
 
	if err != nil {
		msg := "Failed to read zip %s for reading: %s"
		return fmt.Errorf(msg, file.Name, err)
	}
 
	fmt.Println()
 
	return nil
}


func main() {
	str := "$(zip -9ry - sneslib | base64 -w0)"
	data, err := base64.StdEncoding.DecodeString(str)
	if err != nil {
		panic(err)
	}
	buf := bytes.NewReader(data)
	read, err := zip.NewReader(buf, int64(len(data)))

	for _, file := range read.File {
		if err := listFiles(file); err != nil {
			log.Fatalf("Failed to read %s from zip: %s", file.Name, err)
		}
	}
}
EOF
