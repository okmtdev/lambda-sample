package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	echoadapter "github.com/awslabs/aws-lambda-go-api-proxy/echo"
	"github.com/labstack/echo/v4"
	"log"
	"net/http"
	"os"
)

var (
	echoLambda *echoadapter.EchoLambda
	e          *echo.Echo
)

func init() {
	e = echo.New()
	e.GET("/", hello)
	e.GET("/health", health)
	echoLambda = echoadapter.New(e)
}

func lambdaHandler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Println("This is lambdaHandler")

	// Parse the path from the request body
	var requestBody map[string]string
	err := json.Unmarshal([]byte(req.Body), &requestBody)
	if err != nil {
		return events.APIGatewayProxyResponse{StatusCode: http.StatusBadRequest}, err
	}
	path, ok := requestBody["path"]
	if !ok {
		return events.APIGatewayProxyResponse{StatusCode: http.StatusBadRequest}, errors.New("path not specified")
	}

	// Set the path in the request
	req.Path = path

	return echoLambda.ProxyWithContext(ctx, req)
}


//func lambdaHandler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
//	log.Println("This is lambdaHandler")
//	return echoLambda.ProxyWithContext(ctx, req)
//}

func localHandler() {
	log.Println("This is localHandler")
	e.Logger.Fatal(e.Start(":1323"))
}

func hello(c echo.Context) error {
	return c.String(http.StatusOK, "Hello, World!")
}

func health(c echo.Context) error {
	return c.String(http.StatusOK, "OK")
}

func main() {
	if os.Getenv("ENV") == "local" {
		localHandler()
		return
	}
	lambda.Start(lambdaHandler)
}
