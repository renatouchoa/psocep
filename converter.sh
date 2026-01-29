#!/bin/bash

# Nome do arquivo de entrada
INPUT_FILE="CEP PARAÍSO.xlsx - exportarLogradouro.csv"
OUTPUT_FILE="ceps.json"

# Comando jq para processar o CSV:
# 1. 'inputs' lê todas as linhas
# 2. 'split' quebra a linha pela vírgula
# 3. Filtra a primeira linha (cabeçalho)
# 4. Agrupa os dados em um objeto estruturado
tail -n +2 "$INPUT_FILE" | jq -Rsn '
  [
    inputs | split("\r\n") | .[] | select(length > 0) | split(",") 
    | { logradouro: .[0], cep: .[1], bairro: .[2] }
  ] 
  | group_by(.bairro) 
  | map({
      key: .[0].bairro, 
      value: (map({key: .logradouro, value: .cep}) | from_entries)
    }) 
  | from_entries
' > "$OUTPUT_FILE"

echo "Sucesso! Arquivo $OUTPUT_FILE gerado."