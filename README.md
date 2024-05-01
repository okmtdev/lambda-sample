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
$ docker compose build
$ docker compose run --rm go-local go build -o ./app/main ./app/main.go
```

## Architecture figure from Terraform code

https://blog.mmmcorp.co.jp/2023/07/26/generating-architecture-diagram-from-terraform-code/
