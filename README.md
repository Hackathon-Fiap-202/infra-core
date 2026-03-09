# Infra-Core

Infraestrutura como código (IaC) para provisionamento de recursos na AWS utilizando Terraform. Este projeto fornece uma base de infraestrutura modular e reutilizável para o projeto nexTime-frame.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Arquitetura](#arquitetura)
- [Recursos Provisionados](#recursos-provisionados)
- [Pré-requisitos](#pré-requisitos)
- [Configuração](#configuração)
- [Uso](#uso)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Módulos](#módulos)
- [Outputs](#outputs)
- [Backend](#backend)

## 🎯 Visão Geral

Este repositório contém a definição de infraestrutura core para provisionamento automatizado de recursos AWS, incluindo:

- **VPC** com configuração de DNS
- **Subnets públicas e privadas** em múltiplas zonas de disponibilidade
- **Internet Gateway** e **NAT Gateway** para conectividade
- **Route Tables** configuradas
- **Security Groups** para controle de tráfego
- **Network ACLs** para segurança adicional
- **API Gateway** (HTTP API v2)

## 🏗️ Arquitetura

A infraestrutura é projetada seguindo boas práticas de segurança e alta disponibilidade:

```
┌─────────────────────────────────────────────────┐
│                    VPC                          │
│              (10.0.0.0/16)                     │
│                                                 │
│  ┌──────────────┐      ┌──────────────┐       │
│  │ Public Subnet│      │ Public Subnet│       │
│  │ 10.0.1.0/24  │      │ 10.0.2.0/24  │       │
│  │   us-east-1a │      │   us-east-1b │       │
│  │              │      │              │       │
│  │  [NAT GW]    │      │              │       │
│  └──────┬───────┘      └──────┬───────┘       │
│         │                     │                │
│         └─────────┬───────────┘                │
│                   │                            │
│            [Internet GW]                       │
│                                                 │
│  ┌──────────────┐      ┌──────────────┐       │
│  │Private Subnet│      │Private Subnet│       │
│  │ 10.0.6.0/24  │      │ 10.0.10.0/24 │       │
│  │   us-east-1a │      │   us-east-1b │       │
│  └──────────────┘      └──────────────┘       │
└─────────────────────────────────────────────────┘
```

## 🔧 Recursos Provisionados

### Rede
- **VPC**: Rede virtual isolada com suporte a DNS
- **Subnets Públicas**: 2 subnets em zonas de disponibilidade diferentes
- **Subnets Privadas**: 2 subnets para recursos que não precisam de acesso direto à internet
- **Internet Gateway**: Conectividade de saída para subnets públicas
- **NAT Gateway**: Conectividade de saída para subnets privadas
- **Route Tables**: Tabelas de roteamento configuradas

### Segurança
- **Security Groups**: Grupos de segurança para controle de tráfego de rede
- **Network ACLs**: Controle adicional de acesso à rede

### API
- **API Gateway**: HTTP API v2 configurado (módulo disponível)

## 📦 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Credenciais AWS configuradas (via `aws configure` ou variáveis de ambiente)
- Acesso ao bucket S3 `nextime-frame-state-bucket-s3` na região `us-east-1`

## ⚙️ Configuração

### 1. Configurar o Backend S3

O projeto utiliza um backend S3 remoto para armazenar o estado do Terraform. O bucket deve ser criado previamente usando o módulo bootstrap:

```bash
cd infra/bootstrap
terraform init
terraform apply
```

### 2. Configurar Variáveis

Edite o arquivo `infra/terraform.tfvars` com os valores desejados:

```hcl
# VPC
vpc_name   = "infra-vpc"
cidr_block = "10.0.0.0/16"
region     = "us-east-1"

# Subnets
subnet_name     = "infra-subnet"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.6.0/24", "10.0.10.0/24"]
subnet_group_name = "infra-subnet-private"

# Gateways
nat_name = "infra-nat-gateway"
igw_name = "infra-igw"

# Route Table
route_table_name = "infra-public-route-table"
route_cidr = "0.0.0.0/0"

# Security Groups
sg_api_name = "infra-sg-api"

# ACL
acl_name = "infra-acl"

# Tags
tags = {
  Owner = "nexTime-frame"
}
```

## 🚀 Uso

### Inicializar o Terraform

```bash
cd infra
terraform init
```

### Validar a Configuração

```bash
terraform validate
```

### Visualizar o Plano de Execução

```bash
terraform plan
```

### Aplicar a Infraestrutura

```bash
terraform apply
```

### Destruir a Infraestrutura

```bash
terraform destroy
```

## 📁 Estrutura do Projeto

```
infra-core/
├── infra/
│   ├── main.tf                 # Configuração principal dos módulos
│   ├── variables.tf            # Definição de variáveis
│   ├── outputs.tf              # Outputs da infraestrutura
│   ├── providers.tf            # Configuração de providers e backend
│   ├── terraform.tfvars        # Valores das variáveis
│   ├── bootstrap/              # Scripts para criar o bucket S3
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── modules/                # Módulos reutilizáveis
│       ├── vpc/
│       ├── subnet/
│       │   ├── public_subnet/
│       │   └── private_subnet/
│       ├── internet_gateway/
│       ├── nat_gateway/
│       ├── route_table/
│       ├── security_group/
│       │   └── public_sg/
│       ├── acl/
│       └── api_gateway/
└── README.md
```

## 🧩 Módulos

### VPC
Cria uma VPC com suporte a DNS habilitado.

### Subnets
- **Public Subnet**: Subnets públicas com acesso à internet via Internet Gateway
- **Private Subnet**: Subnets privadas com acesso à internet via NAT Gateway

### Internet Gateway
Gateway para permitir comunicação entre a VPC e a internet.

### NAT Gateway
Gateway para permitir que recursos em subnets privadas acessem a internet.

### Route Table
Tabela de roteamento configurada para as subnets públicas.

### Security Group
Grupos de segurança para controle de tráfego de rede (configurado para API).

### ACL
Network Access Control List para controle adicional de segurança.

### API Gateway
Módulo para criação de HTTP API Gateway (v2) - disponível para uso.

## 📤 Outputs

Após a aplicação, os seguintes outputs estarão disponíveis:

- `vpc_id`: ID da VPC criada
- `public_subnet_ids`: Lista de IDs das subnets públicas
- `private_subnet_ids`: Lista de IDs das subnets privadas
- `internet_gateway_id`: ID do Internet Gateway
- `route_table_id`: ID da Route Table
- `security_group_api_id`: ID do Security Group da API
- `network_acl_id`: ID do Network ACL

Para visualizar os outputs:

```bash
terraform output
```

## 💾 Backend

O estado do Terraform é armazenado remotamente no S3:

- **Bucket**: `nextime-frame-state-bucket-s3`
- **Key**: `infra-core/infra.tfstate`
- **Região**: `us-east-1`
- **Criptografia**: Habilitada (AES256)
- **Versionamento**: Habilitado

## 🔐 Segurança

- O estado do Terraform é armazenado em S3 com criptografia
- Versionamento do bucket S3 está habilitado
- Security Groups e ACLs configurados para controle de acesso
- Subnets privadas para recursos sensíveis

## 📝 Notas

- Certifique-se de que o bucket S3 do backend existe antes de executar `terraform init`
- Ajuste os CIDRs conforme necessário para evitar conflitos
- As tags são aplicadas a todos os recursos criados
- O projeto está configurado para a região `us-east-1` por padrão

## 👥 Contribuição

Este projeto faz parte do hackaton SOAT para o projeto nexTime-frame.

## 📄 Licença

Este projeto é propriedade da equipe nexTime-frame.

