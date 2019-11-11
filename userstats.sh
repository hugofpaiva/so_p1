#!/bin/bash

path="/var/log/wtmp"

file_array=() #Array onde vai ser guardado o ficheiro

# Leitura de ficheiro:
# -r: opção passada para o comando read que evita o "backslash escape" de ser interpretado
# IFS=:Opção antes do comando read que previne os espaços de serem cortados
function read_file() {
   while IFS= read -r line; do
      file_array+=("$line")
   done <"$path" #Vou buscar a variável path, logo uso $
}
#read_file

# Usage - Como se usa o script
function usage() {
   echo "Usage: $0 -g [grupo] -u [nome] -s [data1] -p [data2] -r -n -t -a -i"
   echo ""
   echo "[grupo] = Grupo de utilizadores"
   echo "[nome] = Nome dos utilizadores"
   echo "[data1] = Data de início da sessão a partir da qual as sessões devem ser consideradas"
   echo "[data2] = Data de início de sessão a partir da qual as sessões não devem ser consideradas"
   echo ""
   echo "Todas estas opções são opcionais, sendo que o script corre sem nenhuma opção"
   echo ""
   exit 1
}

#Tratamento de opções
# -z: vai testar se o "$1" é uma string nula ou não. Se for uma string nula, é executado.
#    [ -z "$1" ] )
if [ -z "$1" ]; then #Este if verifica se é passada algum arguemto ou não. Tem de ter espaços a toda a volta do "[" "]"
   echo "Nenhum argumento ou opção"
   exit
else

   while getopts g:u:s:e:f:rntai option; do # As opções são passadas todas a seguir ao getopts. Se tiver ":" quer dizer que aceita argumentos. O "${OPTARG}" são os argumentos
      case "${option}" in
      g)
         echo "A opção g foi ativada."
         #echo "$file_array"
         #eval "last"
         $(last >last.txt)
         ;;
      u) argumento_b="${OPTARG}" ;;
      s) recebi_c=1 ;;
      e) recebi_d=1 ;;
      f)
         echo "O script vai ler do ficheiro ${OPTARG}"
         $(last -f ${OPTARG} >last.txt) #corre o last com um novo ficheiro de texto
         ;;
      r) ;;
      n) ;;
      t) ;;
      a) ;;
      i) ;;
      *)
         usage
         ;;
      esac
   done

   if [ $OPTIND -eq 1 ]; then #Este if corre se não houve nenhuma opção mas forem passado argumentos
      usage
      echo "Nenhuma opção mas foram passado argumentos"
   fi

fi

#shift $((OPTIND-1)) Este shitf vai fazer desaparecer dos argumentos $1, $2, ... as opções e argumentos passado ao getopts

#Logo, ao fazer echo "$1" vai-me dar os outros argumentos não utilizados em getopts
#echo "$1"