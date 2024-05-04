#!/bin/bash
set -e

ENDPOINT=http://localhost:8000

aws dynamodb create-table --endpoint-url $ENDPOINT \
    --table-name SampleTable \
    --attribute-definitions AttributeName=Id,AttributeType=S \
    --key-schema AttributeName=Id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

aws dynamodb put-item --endpoint-url $ENDPOINT \
    --table-name SampleTable \
    --item '{"Id": {"S": "1"}, "Name": {"S": "Sample Data"}}'

echo "Sample table and data created successfully."