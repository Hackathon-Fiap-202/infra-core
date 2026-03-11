# infra-core

Infraestrutura base do projeto **nexTime-frame**, provisionada com Terraform na AWS. Este repositório define a rede (VPC, subnets, gateways, tabelas de rotas, ACLs, security groups), os repositórios de imagem Docker (ECR), os segredos gerenciados (Secrets Manager) e os VPC Endpoints necessários para que os demais stacks de infraestrutura funcionem.

## Sumário

- [Visão Geral](#visão-geral)
- [Arquitetura de Rede](#arquitetura-de-rede)
- [Recursos Provisionados](#recursos-provisionados)
- [Pré-requisitos](#pré-requisitos)
- [Variáveis](#variáveis)
- [Outputs](#outputs)
- [Como Usar](#como-usar)
- [Backend Remoto](#backend-remoto)
- [CI/CD](#cicd)
- [Ordem de Deploy](#ordem-de-deploy)
- [Contribuição](#contribuição)

---

## Visão Geral

O `infra-core` é o **primeiro stack a ser aplicado** na ordem de deploy. Todos os demais stacks (`infra-messaging`, `infra-gateway`, `Infra-ecs`, `lambda-sender`) leem outputs deste estado remoto via `terraform_remote_state`.

---

## Arquitetura de Rede

```
Internet
    │
    ▼
Internet Gateway
    │
    ├─── Public Subnet us-east-1a (10.0.1.0/24)  ◄── NAT Gateway
    └─── Public Subnet us-east-1b (10.0.2.0/24)
              │
             NAT
              │
    ├─── Private Subnet us-east-1a (10.0.6.0/24)   ◄── ECS tasks, Lambda
    └─── Private Subnet us-east-1b (10.0.10.0/24)
```

VPC Endpoints (Interface) mantêm o tráfego interno à AWS, sem passar pela internet:

| Endpoint | Tipo | Serviço |
|---|---|---|
| `ecr.api` | Interface | Pull de imagens ECR |
| `ecr.dkr` | Interface | Pull de imagens ECR (Docker) |
| `secretsmanager` | Interface | Leitura de segredos |
| `logs` | Interface | CloudWatch Logs (Fluent Bit) |
| `s3` | Gateway | Acesso ao S3 sem NAT |

---

## Recursos Provisionados

### Rede

| Módulo | Recurso | Descrição |
|---|---|---|
| `vpc` | `aws_vpc` | VPC `10.0.0.0/16` com DNS habilitado |
| `subnet/public_subnet` | `aws_subnet` × 2 | Subnets públicas em `us-east-1a` e `us-east-1b` |
| `subnet/private_subnet` | `aws_subnet` × 2 | Subnets privadas em `us-east-1a` e `us-east-1b` |
| `internet_gateway` | `aws_internet_gateway` | IGW para saída pública |
| `nat_gateway` | `aws_nat_gateway` | NAT na subnet pública `us-east-1a` |
| `route_table` | `aws_route_table` | Tabela pública: `0.0.0.0/0` → IGW |
| `route_table_private` | `aws_route_table` | Tabela privada: `0.0.0.0/0` → NAT |
| `security_group/public_sg` | `aws_security_group` | SG da API (referenciado pelo ALB e VPC Link) |
| `acl` | `aws_network_acl` | ACL associada às subnets |

### Armazenamento e Imagens

| Módulo | Recurso | Descrição |
|---|---|---|
| `ecr` | `aws_ecr_repository` | Repositório ECR para `ms-video` e `process-video` |
| `documentdb` | `aws_secretsmanager_secret` | Segredo com a URI do MongoDB Atlas |
| `datadog` | `aws_secretsmanager_secret` | Segredo com a API Key do Datadog |

### VPC Endpoints (`vpc_endpoints.tf`)

Cinco endpoints provisionados diretamente (sem módulo): `secretsmanager`, `ecr.api`, `ecr.dkr`, `logs` (Interface) e `s3` (Gateway).

---

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado com credenciais que permitam criar os recursos acima
- Bucket S3 `nextime-frame-state-bucket-s3` criado previamente na região `us-east-1` (usado como backend remoto)

---

## Variáveis

| Variável | Tipo | Descrição | Padrão |
|---|---|---|---|
| `project_name` | `string` | Prefixo usado em todos os recursos | `nextime-frame` |
| `region` | `string` | Região AWS | `us-east-1` |
| `vpc_name` | `string` | Nome da VPC | `infra-vpc` |
| `cidr_block` | `string` | CIDR da VPC | `10.0.0.0/16` |
| `azs` | `list(string)` | Zonas de disponibilidade | `["us-east-1a","us-east-1b"]` |
| `public_subnets` | `list(string)` | CIDRs das subnets públicas | `["10.0.1.0/24","10.0.2.0/24"]` |
| `private_subnets` | `list(string)` | CIDRs das subnets privadas | `["10.0.6.0/24","10.0.10.0/24"]` |
| `mongo_uri` | `string` | URI do MongoDB Atlas (sensível) | `""` |
| `datadog_api_key` | `string` | API Key do Datadog (sensível) | `""` |
| `tags` | `map(string)` | Tags aplicadas a todos os recursos | `{ Owner = "nexTime-frame" }` |

> As variáveis `mongo_uri` e `datadog_api_key` são injetadas em tempo de `plan/apply` via GitHub Secrets e nunca devem ser commitadas em `terraform.tfvars`.

---

## Outputs

Estes valores são lidos pelos demais stacks via `terraform_remote_state` (bucket `nextime-frame-state-bucket-s3`, key `infra-core/infra.tfstate`):

| Output | Descrição |
|---|---|
| `vpc_id` | ID da VPC |
| `public_subnet_ids` | Lista de IDs das subnets públicas |
| `private_subnet_ids` | Lista de IDs das subnets privadas |
| `internet_gateway_id` | ID do Internet Gateway |
| `route_table_id` | ID da Route Table pública |
| `security_group_api_id` | ID do Security Group da API |
| `network_acl_id` | ID da Network ACL |
| `ms_video_ecr_url` | URL do repositório ECR do `ms-video` |
| `process_video_ecr_url` | URL do repositório ECR do `process-video` |
| `ecr_repository_urls` | Mapa com todas as URLs de repositórios ECR |
| `docdb_secret_arn` | ARN do segredo do MongoDB Atlas |
| `datadog_api_key_secret_arn` | ARN do segredo da API Key do Datadog |

---

## Como Usar

```bash
cd infra-core/infra

# Inicializar (conecta ao backend S3)
terraform init

# Validar configuração
terraform validate

# Visualizar plano
terraform plan \
  -var="mongo_uri=$MONGO_URI" \
  -var="datadog_api_key=$DATADOG_API_KEY"

# Aplicar
terraform apply \
  -var="mongo_uri=$MONGO_URI" \
  -var="datadog_api_key=$DATADOG_API_KEY"

# Verificar outputs
terraform output
```

---

## Backend Remoto

```hcl
backend "s3" {
  bucket  = "nextime-frame-state-bucket-s3"
  key     = "infra-core/infra.tfstate"
  region  = "us-east-1"
  encrypt = true
}
```

---

## CI/CD

O pipeline `.github/workflows/cd-infra.yml` é acionado em push para `main`.

| Etapa | Comando |
|---|---|
| Checkout + configure AWS | `aws-actions/configure-aws-credentials` via OIDC (`AWS_ROLE_ARN`) |
| Init | `terraform init` |
| Validate | `terraform validate` |
| Plan | `terraform plan -var="mongo_uri=..." -var="datadog_api_key=..."` |
| Apply | `terraform apply -auto-approve ...` |

**Secrets do GitHub necessários:**

| Secret | Usado em |
|---|---|
| `AWS_ACCOUNT_ID` | Construção do ARN da role |
| `AWS_ROLE_ARN` | Autenticação OIDC |
| `MONGO_URI` | Injeta URI do MongoDB no Secrets Manager |
| `DATADOG_API_KEY` | Injeta API Key do Datadog no Secrets Manager |

---

## Ordem de Deploy

> O `infra-core` **deve ser o primeiro stack aplicado**. Os stacks seguintes dependem dos seus outputs.

```
1. infra-core          ← este repositório
2. infra-messaging
3. infra-gateway
4. Infra-ecs
5. lambda-sender
```

---

## Estrutura do Projeto

```
infra-core/
├── infra/
│   ├── main.tf              # Instancia todos os módulos
│   ├── variables.tf         # Declaração de variáveis
│   ├── outputs.tf           # Outputs exportados para outros stacks
│   ├── providers.tf         # Provider AWS + backend S3
│   ├── terraform.tfvars     # Valores não-sensíveis das variáveis
│   ├── vpc_endpoints.tf     # VPC Interface/Gateway Endpoints
│   └── modules/
│       ├── vpc/
│       ├── subnet/
│       │   ├── public_subnet/
│       │   └── private_subnet/
│       ├── internet_gateway/
│       ├── nat_gateway/
│       ├── route_table/
│       ├── route_table_private/
│       ├── security_group/
│       │   └── public_sg/
│       ├── acl/
│       ├── ecr/
│       ├── documentdb/
│       └── datadog/
└── README.md
```

---

## Contribuição

Este repositório faz parte do hackathon FIAP — nexTime-frame. Siga o padrão de commits convencional (`feat:`, `fix:`, `docs:`, `chore:`) e mantenha a estrutura modular do Terraform.
