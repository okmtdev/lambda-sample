package main

import (
	"context"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

type Item struct {
	Id   string
	Name string
}

func Handler(ctx context.Context) error {
	// セッションを作成
	sess := session.Must(session.NewSession(&aws.Config{
		Endpoint:    aws.String("http://dynamodb:8000"),
		Region:      aws.String("us-west-2"),
		Credentials: aws.AnonymousCredentials,
	}))

	// DynamoDBクライアントを作成
	svc := dynamodb.New(sess)

	// 書き込むアイテムを作成
	item := Item{
		Id:   "2",
		Name: "Another Sample Data",
	}

	// アイテムをマップに変換
	av, err := dynamodbattribute.MarshalMap(item)
	if err != nil {
		log.Fatalf("Got error marshalling new movie item: %s", err)
	}

	// アイテムをDynamoDBに書き込む
	input := &dynamodb.PutItemInput{
		Item:      av,
		TableName: aws.String("SampleTable"),
	}

	_, err = svc.PutItem(input)
	if err != nil {
		log.Fatalf("Got error calling PutItem: %s", err)
	}

	fmt.Println("Successfully added 'Another Sample Data' to SampleTable")
	return nil
}

func main() {
	lambda.Start(Handler)
}