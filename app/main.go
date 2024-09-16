package main

import (
	"context"
	"encoding/json"
	"errors"
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

	apiGatewayReq := events.APIGatewayProxyRequest{
		HTTPMethod:            req.RequestContext.HTTP.Method,
		Path:                  req.RawPath,
		Headers:               req.Headers,
		Body:                  req.Body,
		QueryStringParameters: req.QueryStringParameters,
		RequestContext: events.APIGatewayProxyRequestContext{
			AccountID:        req.RequestContext.AccountID,
			RequestID:        req.RequestContext.RequestID,
			APIID:            req.RequestContext.APIID,
			DomainName:       req.RequestContext.DomainName,
			DomainPrefix:     req.RequestContext.DomainPrefix,
			RequestTimeEpoch: req.RequestContext.TimeEpoch,
		},
	}

	log.Println("This is lambdaHander apiGatewayReq")

	return echoLambda.ProxyWithContext(ctx, apiGatewayReq)
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
