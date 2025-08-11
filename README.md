# desafio-dreamsquad


Este projeto contém o código Terraform para provisionar três serviços distintos na AWS. O código foi projetado para ser totalmente portável e executado em qualquer conta da AWS com as permissões adequadas.

## Pré-requisitos

Antes de começar, certifique-se de ter as seguintes ferramentas instaladas e configuradas:

1.  **Terraform (v1.0.0 ou superior)**
2.  **AWS CLI** (configurada com suas credenciais de acesso - `aws configure`)
3.  **Docker**

## Estrutura dos Serviços

* **Serviço 1: Frontend Estático**
    * **Tecnologia:** Um arquivo `index.html` simples.
    * **AWS:** Hosted no **Amazon S3**

* **Serviço 2: Backend em Container**
    * **Tecnologia:** Uma aplicação "Hello World" em Python (Flask) containerizada com Docker.


* **Serviço 3: Tarefa Agendada**
    * **Tecnologia:** Um script Python.
    * **AWS:** Uma função **AWS Lambda** é acionada diariamente às 10:00 AM (UTC) 

## Instruções para Execução e Teste

Siga os passos abaixo para implantar e testar a infraestrutura.

### Passo 1: Inicializar o Terraform

Navegue até a pasta raiz do projeto (`desafio-terraform-aws/`) e execute:

```sh
terraform init
