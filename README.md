# lambda-sample

Introducing implementations related to Lambda

# ローカル開発

## Golang

[Golang を goenv を使ってインストールしてみた](https://qiita.com/walkers/items/761b2a5e58849176a633)

```
$ brew install goenv
$ vim ~/.bash_profile

export PATH="$HOME/.goenv/bin:$PATH"
eval "$(goenv init -)"

$ goenv install -l
...
  1.21.6
  1.21.7
  1.21.8
  1.21.9
  1.22.0
  1.22.1
  1.22.2

$ goenv install 1.22.2
$ goenv global 1.22.2
$ go version
go version go1.22.2 darwin/arm64
```

Golang プロジェクト初期化

```
$ go mod init github.com/okmtdev/lambda-sample

# moduleのインストール
$ go get github.com/hoge/fuga@latest

# コードのimportからgo.sumを作成する
$ go mod tidy
```

## Lambda Docker

[Go+Lambda+Docker のローカル環境を構築する](https://zenn.dev/ryohei_takagi/articles/f4d63ae991ee9c)

dynamodb-admin を用いるとローカル環境で DB 内のデータを GUI で確認できる

```
$ docker compose up

$ curl -i -X POST http://localhost:8080/2015-03-31/functions/function/invocations -d '{}'
HTTP/1.1 200 OK
Date: Wed, 01 May 2024 16:19:52 GMT
Content-Length: 4
Content-Type: text/plain; charset=utf-8

null
```

## Architecture figure from Terraform code

https://blog.mmmcorp.co.jp/2023/07/26/generating-architecture-diagram-from-terraform-code/

## DynamoDB Docker

DynamoDB Admin を通じてローカルの DynamoDB を確認してみる

`http://localhost:8001`

![dynamodb-admin-0](./images/dynamodb_admin_0.png)

ローカルで`docker compose up`をした後に`init.sh`を実行

```
./docker/dynamodb/init.sh
{
    "TableDescription": {
        "AttributeDefinitions": [
            {
                "AttributeName": "Id",
                "AttributeType": "S"
            }
        ],
        "TableName": "SampleTable",
        "KeySchema": [
            {
                "AttributeName": "Id",
                "KeyType": "HASH"
            }
        ],
        "TableStatus": "ACTIVE",
        "CreationDateTime": "2024-05-04T20:22:51.466000+09:00",
        "ProvisionedThroughput": {
            "LastIncreaseDateTime": "1970-01-01T09:00:00+09:00",
            "LastDecreaseDateTime": "1970-01-01T09:00:00+09:00",
            "NumberOfDecreasesToday": 0,
            "ReadCapacityUnits": 1,
            "WriteCapacityUnits": 1
        },
        "TableSizeBytes": 0,
        "ItemCount": 0,
        "TableArn": "arn:aws:dynamodb:ddblocal:000000000000:table/SampleTable",
        "DeletionProtectionEnabled": false
    }
}
Sample table and data created successfully.
```

`http://localhost:8001`

![dynamodb-admin-1](./images/dynamodb_admin_1.png)

SampleTable をクリックすると、データが入っているはず

![dynamodb-admin-2](./images/dynamodb_admin_2.png)
