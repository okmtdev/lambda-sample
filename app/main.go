package main

import (
	"context"
	"log"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	echoadapter "github.com/awslabs/aws-lambda-go-api-proxy/echo"
	"github.com/labstack/echo/v4"
)

var echoLambda *echoadapter.EchoLambda

func setRouter(e *echo.Echo, ctx context.Context) {
	e.GET("/health", health)
	e.GET("/hello", hello)
	e.Any("/*", unknownRouteHandler)
}

// @title Lambda Sample
// @version 0.0.1
// @host https://localhost:1323/
// @BasePath /
func lambdaHandler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Println("This is lambdaHandler 001")

	e = echo.New()
	echoLambda = echoadapter.New(e)
	setRouter(e, ctx)

	apiGatewayReq := events.APIGatewayProxyRequest{
		HTTPMethod:            req.HTTPMethod,
		Path:                  req.Path,
		Headers:               req.Headers,
		Body:                  req.Body,
		QueryStringParameters: req.QueryStringParameters,
		RequestContext: events.APIGatewayProxyRequestContext{
			AccountID:        req.RequestContext.AccountID,
			RequestID:        req.RequestContext.RequestID,
			APIID:            req.RequestContext.APIID,
			DomainName:       req.RequestContext.DomainName,
			DomainPrefix:     req.RequestContext.DomainPrefix,
			RequestTimeEpoch: req.RequestContext.RequestTimeEpoch,
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
	e = echo.New()
	echoLambda = echoadapter.New(e)
	setRouter(e, nil)
	e.Logger.Fatal(e.Start(":1323"))
}

func hello(c echo.Context) error {
	return c.String(http.StatusOK, "Hello, World!")
}

func health(c echo.Context) error {
	return c.String(http.StatusOK, "OK")
}

func unknownRouteHandler(c echo.Context) error {
	return c.String(http.StatusNotFound, "Route not found")
}

func main() {
	if os.Getenv("ENV") == "local" {
		localHandler()
		return
	}
	lambda.Start(lambdaHandler)
}
