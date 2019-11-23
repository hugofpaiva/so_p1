#!/bin/bash

# Arrays para guardar users e a sua informaçao
users1=() #Array para os user do input1
users2=() #Array para os user do input2
file_array=()
declare -A argOpt=()      #Array associativo onde são guardadas os argumento correspondentes às opções passadas
declare -A userInfo=()    #Array associativo onde são guardados os dados para serem imprimidos de cada user
declare -A userInfo1=()
declare -A userInfo2=()
options_control=(n t a i) #Array com as opções que não podem ser repetidas

# Criação dos inputs ####FALTA VERIFICAÇÃO E AINDA NÃO PERMITE OPÇÕES - estava a morrer de sono
input1=$1
input2=$2

# Usage das opções - Como se usa o script
function usage() {
    echo "Usage: $0  -r -n -t -a -i [ficheiro1] [ficheiro2]"
    echo ""
    echo "[ficheiro1] = Ficheiro mais recente para ser comparado"
    echo "[ficheiro2] = Ficheiro mais antigo para ser comparado"
    echo ""
    exit
}

# Tratamento de opções
function args() {

    while getopts g:u:s:e:f:rntai option; do
        case "${option}" in
        r | n | t | a | i) ;;
        *)
            usage
            ;;
        esac

        #Controlo das opções que não podem ser repetidas
        for i in "${options_control[@]}"; do #Vou percorrer o array das opções que não podem ser repetidas
            if [[ -v argOpt[$i] ]]; then #Verifico se já existe umas dessas opções
                usage
            fi
        done

        if [[ -z "$OPTARG" ]]; then #Este if corre se forem passadas opções mas nenhum argumentos
            argOpt[$option]="none" #Guarda no array associativo com a key correspondente à opção, o value none pois não foram passados argumentos
        fi

    done

    shift $((OPTIND - 1))

}

# Tratamento e leitura de dados

function getUsers() {
    users1=$(cat $input1 | awk '{print $1}' | sort | uniq | sed '/reboot/d' | sed '/wtmp/d')
    users2=$(cat $input2 | awk '{print $1}' | sort | uniq | sed '/reboot/d' | sed '/wtmp/d')
}


function getUserInfo() { #Amanhã acabo
    echo "I may take a while to process, but I'll get there. Please have a little faith!"

    for user1 in ${users1[@]}; do
        sessions1=$(cat $input1 | awk '{print $1}')
        total1=$(cat $input1 | awk '{print $2}')
        max1=$(cat $input1 | awk '{print $2}')
        min1=$(cat $input1 | awk '{print $2}')

        for user2 in ${users2[@]}; do
            if [ "$user2" = "$user1" ];then
                sessions=sessions1-$(cat $input2 | awk '{print $1}')
                total=total1-$(cat $input2 | awk '{print $2}')
                max=max1-$(cat $input2 | awk '{print $2}')
                min=min1-$(cat $input2 | awk '{print $2}')
                userInfo[$user2]=$(printf "%-8s %-5s %-6s %-5s %-5s\n" "$user2" "$sessions" "$total" "$max" "$min")
            else
 echo "ok"
            fi
 
        done

    done

    
   
    printIt
}

function printIt() {
    if [[ -v argOpt[r] ]]; then
        # ordem decrescente(nome user)
        order="-r"
    else
        order=""
    fi

    if [[ -v argOpt[n] ]]; then
        # ordenar por numero de sessoes
        printf "%s\n" "${userInfo[@]}" | sort -k1,1n ${order}

    elif [[ -v argOpt[t] ]]; then
        # por tempo total
        printf "%s\n" "${userInfo[@]}" | sort -k2,2n ${order}

    elif [[ -v argOpt[a] ]]; then
        # por tempo máximo
        printf "%s\n" "${userInfo[@]}" | sort -k3,3n ${order}

    elif [[ -v argOpt[i] ]]; then
        # por tempo mínimo
        printf "%s\n" "${userInfo[@]}" | sort -k5,5n ${order}

    else
        #ordem crescente (nome user)
        printf "%s\n" "${userInfo[@]}" | sort -k1,1n ${order}
    fi
}

args "$@"
getUsers
getUserInfo
