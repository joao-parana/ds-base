#!/bin/bash

set -e

export HUB_USER_NAME=parana

FIRST_PARAM=$1
# set -x

if [ "$FIRST_PARAM." = '.' ]; then
    FIRST_PARAM='change-this'
    echo "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
    echo "••• `date` ATENÇÃO: Assumindo senha do root como sendo 'change-this'  •••"
    echo "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
fi

echo "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
echo "••• `date` Gerando contêiner BASE                                     •••"
echo "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"

# Gerado a imagem base
docker build --build-arg root_passwd=$FIRST_PARAM -t $HUB_USER_NAME/ds-base .

echo "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
echo "••• `date` ATENÇÃO: Assumindo senha do root como sendo $FIRST_PARAM   •••"
echo "••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
