#!/bin/bash
#--------------------------------------------------------------------------------------------------------------------------------
#
# SISTEMA_CADASTRO_USUARIO.sh - Script de cadastro de usuários em base de dados .txt 
#
# Autor: Marcus Vinicius de Freitas Costa
# Data de Criação: 03/09/2021
# Testado em: bash 5.0.17
#
#------------------------------------------------- VARIAVEIS ---------------------------------------------------------------------

#Arquivos
ARQUIVO_BANCO_DE_DADOS="BANCO_DADOS.txt"
TEMP="temp.$$"

SEP=":"

#Cores de saída
VERDE="\033[32;1m"
VERMELHO="\033[31;1m"

#------------------------------------------------- VALIDACOES ---------------------------------------------------------------------

[ ! -f "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO! Arquivo não existe." && exit 1
[ ! -r "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO! Arquivo não permissão de leitura." && exit 1
[ ! -w "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO! Arquivo não permissão de escrita." && exit 1

#------------------------------------------------- FUNÇÕES -------------------------------------------------------------------------

MostraUsuarioTela(){
    local id="$(echo $1 | cut -d $SEP -f 1)"
    local nome="$(echo $1 | cut -d $SEP -f 2)"
    local email="$(echo $1 | cut -d $SEP -f 3)"

    echo -e "${VERDE}ID: ${VERMELHO}$id"
    echo -e "${VERDE}Nome: ${VERMELHO}$nome"
    echo -e "${VERDE}Email: ${VERMELHO}$email"
}

ListaUsuarios(){
    while read -r linha
    do
        [ "$(echo $linha | cut -c1)" = "#" ] && continue
        [ ! "$linha" ] && continue
        MostraUsuarioTela "$linha"        
    done < "$ARQUIVO_BANCO_DE_DADOS" 
}

InserirUsuario(){
    local nome="$(echo $1 | cut -d $SEP -f 2)"

    if ValidaExistenciaUsuario "$nome"
    then
        echo "Erro. Usuário já existente!"
    else
        echo "$*" >> "$ARQUIVO_BANCO_DE_DADOS" 
        echo "Usuário cadastrado com sucesso!"   
    fi
    OrdernaLista
}

ExcluirUsuario(){
    ValidaExistenciaUsuario "$1" || return
    
    grep -i -v "$1$SEP" "$ARQUIVO_BANCO_DE_DADOS" > "$TEMP"
    mv "$TEMP" "$ARQUIVO_BANCO_DE_DADOS"

    echo "Usuário excluído com sucesso!"
    OrdernaLista
}

ValidaExistenciaUsuario(){
    grep -i -q "$1$SEP" "$ARQUIVO_BANCO_DE_DADOS"
}

OrdernaLista(){
    sort "$ARQUIVO_BANCO_DE_DADOS" > "$TEMP"
    mv "$TEMP" "$ARQUIVO_BANCO_DE_DADOS"
}

#------------------------------------------------- EXECUÇÃO -------------------------------------------------------------------------
