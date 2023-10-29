#!/bin/bash


prepara_usuarios() {
    echo criando usuarios para teste...
    user1_id=$(curl -s --request POST \
  --url http://localhost:3000/paciente \
  --header 'Content-Type: application/json' \
  --data '{
    "cpf": "14916564251",
    "nome": "jose",
    "email": "jose@email.com",
    "estaAtivo":true,
    "endereco": {
        "cep": 85390000,
        "rua": "Rua 9",
        "numero": 65,
        "complemento": "casa",
        "estado": "ES"
    },
    "senha": "abCD12!@",
    "telefone": "11988887777",
    "possuiPlanoSaude": true,
    "planosSaude": [3,2,5],
    "historico":["bronquite,leve","sinusite,moderado"]
}' | jq -r '.id')

    user2_id=$(curl -s --request POST \
  --url http://localhost:3000/paciente \
  --header 'Content-Type: application/json' \
  --data '{
    "cpf": "12847844520",
    "nome": "joao",
    "email": "joao@email.com",
    "estaAtivo":true,
    "endereco": {
        "cep": 85390000,
        "rua": "Rua 9",
        "numero": 65,
        "complemento": "casa",
        "estado": "ES"
    },
    "senha": "abCD12!@",
    "telefone": "11988887777",
    "possuiPlanoSaude": true,
    "planosSaude": [3,2,5],
    "historico":["bronquite,leve","sinusite,moderado"]
}' | jq -r '.id')

    user1_token=$(curl -s --request POST \
  --url 'http://localhost:3000/auth/login?=' \
  --header 'Content-Type: application/json' \
  --data '{
	"email":"jose@email.com",
	"senha":"abCD12!@"
}' | jq -r '.accessToken')

    user2_token=$(curl -s --request POST \
  --url 'http://localhost:3000/auth/login?=' \
  --header 'Content-Type: application/json' \
  --data '{
	"email":"joao@email.com",
	"senha":"abCD12!@"
}' | jq -r '.accessToken')
}

limpa_usuarios() {
    echo apagando usuarios de teste...
    curl -s --request DELETE \
    --url http://localhost:3000/paciente/$user1_id \
    --header 'Authorization: Bearer '$user1_token
    curl -s --request DELETE \
    --url http://localhost:3000/paciente/$user2_id \
    --header 'Authorization: Bearer '$user2_token
}

roda_o_nuclei() {
    echo rodando o scan com o nuclei

    nuclei -u http://localhost:3000 -t nuclei-test-token-vollmed.yaml -var UserId=$user1_id -var Token=$user2_token
}

prepara_usuarios
roda_o_nuclei
limpa_usuarios
