package main

import (
	"context"
	"github.com/aws/aws-lambda-go/lambda"
	"log"
)

func Handler(ctx context.Context) error {
	log.Println("Hello World.")
	return nil
}

func main() {
	lambda.Start(Handler)
}