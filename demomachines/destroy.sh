#!/bin/bash
source ../commonsettings.sh


if [[ -x "../commonsettings_local.sh" ]]
then
    echo "Includuje lokalne commonsettings"
    source ../commonsettings_local.sh

else
    echo "Nie includuje lokalnych commonsettings"
fi

../terraform destroy -auto-approve -var-file=${COMMONVARS} $@ 
