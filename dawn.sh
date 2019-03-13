#!/bin/bash
#Terraform variables
cd terraform
terraform init && terraform plan 
if [ $? -eq 0 ]; then
    terraform validate && terraform apply -auto-approve
    echo "Se ha desplegado safistactoriamente"
    exit 0
else
    echo "Verificar errores"
    exit 1
fi