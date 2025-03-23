#!/bin/bash

show_banner() {
    clear
    echo -ne "\e[1;32m"
    TEXT="WHOIS by Ozyy"
    
    for ((i = 0; i < ${#TEXT}; i++)); do
        echo -n "${TEXT:$i:1}"
        sleep 0.1
    done
    echo -e "\e[0m\n"
    sleep 0.5
}

whois_lookup() {
    echo -n "Digite o domínio ou IP: "
    read TARGET

    if [[ -z "$TARGET" ]]; then
        echo "Nenhuma entrada fornecida. Retornando ao menu..."
        sleep 1
        return
    fi

    if [[ "$TARGET" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        SERVER="whois.arin.net" 
    else
        SERVER="whois.verisign-grs.com" 
    fi

    echo -e "\nConsultando WHOIS para: \e[1;33m$TARGET\e[0m\n"

    RESULTADO=$(echo -e "$TARGET\r\n" | nc $SERVER 43)

    echo "$RESULTADO"

    echo -n -e "\n\nDeseja salvar o resultado em um arquivo? (s/n): "
    read SAVE_OPTION

    if [[ "$SAVE_OPTION" =~ ^[Ss]$ ]]; then
        FILENAME="whois_$TARGET.txt"
        echo "$RESULTADO" > "$FILENAME"
        echo "Resultado salvo em $FILENAME"
    fi

    echo -e "\nPressione ENTER para voltar ao menu..."
    read
}

while true; do
    show_banner
    echo "1 - Consultar WHOIS"
    echo "2 - Sair"
    echo -n "Escolha uma opção: "
    read OPTION

    case $OPTION in
        1) whois_lookup ;;
        2) echo "Saindo..."; exit ;;
        *) echo "Opção inválida!"; sleep 1 ;;
    esac
done
