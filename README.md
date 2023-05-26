# Terraformサンプル

EKS(fargate)を使用したargocd,dashbordのdemo環境

## 必要環境

* Bitbucket
    * SSH秘密鍵(repository access)
* k8s
    * EKS
    * kubectl
    * helm
* aws
    * awscli
* terraform
    * tfenv
    * tflint
* make

## Files

| path                           | desc                             |
|--------------------------------|----------------------------------|
| Makefile                       | コマンド操作ヘルパー             |
| global/backend.tf              | 共通のバックエンド設定           |
| global/providers_aws.tf        | 共通のプロバイダ設定(aws)        |
| global/providers_localstack.tf | 共通のプロバイダ設定(localstack) |
| global/locals.tf               | 共通の変数                       |
| global/versions.tf             | 共通のバージョン設定             |
| global/ip.sh                   | 自分PC(mac or linux)のIP取得     |
| global/ip_pub.sh               | 自分PC(public)のIP取得           |
| modules/                       | 自作モジュール                   |
| stacks_base/                   | VPC用のリソース                  |
| stacks_eks/                    | EKS用のリソース                  |
| stacks_template/               | stacksのテンプレート             |

## Setup

aws-cliの設定。プロファイル作成

```
$ aws configure
```

## Provisioning

一括apply
```
$ make apply ENV=prd -C stacks_base
```

個別apply
```
$ make apply ENV=prd -C stacks_base/01_network
```

## Usage

* eks context *

aws eks update-kubeconfig --name eks-main --alias eks-main

* dashboard *

http://<ALBのDNS>

「認証なし設定」なので認証画面のskipをクリックするとダッシュボードへ遷移する

* argocd *

http://<ALBのDNS>

[user]
admin
[initial password]
```
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

* sample app *

http://<ALBのDNS>

