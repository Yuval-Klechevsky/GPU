#!/bin/bash 

# Entering Namespace/project from the user

echo "Please enter your Namespace or project"
read NAMESPACE

# waiting if we have any deleting from the user
sleep 3


# checking if the Namespace/project exist

if [[ $(oc get project | awk '{print $1}' | grep "$NAMESPACE") =~ ^$  ]]; then
    echo "The Namespace is not exist , it on creating"
    oc new-project "$NAMESPACE" 
    echo "The Namespace "$NAMESPACE" is successfully created \n"
else
    echo "THE Namespace/project "$NAMESPACE" is already created, You can countine"
fi

# Entering the name of the ResourceQuota from user

echo "Please enter the name of the ResourceQuota"
read QUOTA_NAME


if [[ $(oc get resourcequota -n "$NAMESPACE"  | awk '{print $1}' |grep "$QUOTA_NAME") =~ ^$  ]]; then
    echo "The resourc equota is not exist , it on creating"
    
    # Entering request Memory from user
    echo "Please enter your request MEMORY"
    read REQUEST_MEMORY

    # Entering request CPU from user

    echo "Please enter your request CPU"
    read REQUEST_CPU

    # Entering limit Memory from user

    echo "Please enter your limit MEMORY"
    read LIMIT_MEMORY

    # Entering limit CPU from user

    echo "Please enter your limit CPU"
    read LIMIT_CPU


    # creating a new ResourceQuota 

    oc create quota $QUOTA_NAME --hard=requests.cpu="$REQUEST_CPU",requests.memory="$REQUEST_MEMORY",limits.cpu="$LIMIT_CPU",limits.memory="$LIMIT_MEMORY" -n "$NAMESPACE"
    CURRENT_QUOTA=$(oc get resourcequota "$QUOTA_NAME" -n "$NAMESPACE" -o yaml)
    mkdir -p  ~/gpu/resource-quotas 2> /dev/null
    oc get resourcequota "$QUOTA_NAME" -n "$NAMESPACE" -o yaml > ~/gpu/resource-quotas/"$QUOTA_NAME".yaml
    echo "The ResourceQuota "$QUOTA_NAME" is successfully created"
else

    # Option to edit the ResourceQuota

    CURRENT_QUOTA=$(oc get resourcequota "$QUOTA_NAME" -n "$NAMESPACE" -o yaml)
    mkdir -p  ~/gpu/ 2> /dev/null
    mkdir -p  ~/gpu/resource-quotas 2> /dev/null
    chmod -R a+rwx ~/gpu/resource-quotas
    oc get resourcequota "$QUOTA_NAME" -n "$NAMESPACE" -o yaml > ~/gpu/resource-quotas/"$QUOTA_NAME".yaml
    echo "The ResourceQuota "$QUOTA_NAME" is already created"
    echo "Do you want to edit ResourceQuota? (Yes/No)"
    read CHOISE
    if [[ "$CHOISE" == "Yes" || "$CHOISE" == "YES" || "$CHOISE" == "yes" ]] ; then

        echo "Do you want to change the request memory? (Yes/NO)"
        read Q_REQUEST_MEMORY

        if [[ "$Q_REQUEST_MEMORY" == "Yes" || "$Q_REQUEST_MEMORY" == "YES" || "$Q_REQUEST_MEMORY" == "yes" ]]; then
            echo "Please enter your new request memory"
            read REQUEST_MEMORY
        else
            REQUEST_MEMORY=$(grep requests ~/gpu/resource-quotas/"$QUOTA_NAME".yaml | tail -6 | grep requests.memory | head -1 | awk '{print $2}' | tr -d \")                                                                                            
        fi


        echo "Do you want to change the request CPU? (Yes/NO)"
        read Q_REQUEST_CPU

        if [[ "$Q_REQUEST_CPU" == "Yes" || "$Q_REQUEST_CPU" == "YES" || "$Q_REQUEST_CPU" == "yes" ]] ; then
            echo "Please enter your new request CPU"
            read REQUEST_CPU
        else
            REQUEST_CPU=$(grep requests ~/gpu/resource-quotas/test.yaml | tail -6 | grep requests.cpu | head -1 | awk '{print $2}' | tr -d \")                                                                                             
        fi


        echo "Do you want to change the limit memory? (Yes/NO)"
        read Q_LIMIT_MEMORY

        if [[ "$Q_LIMIT_MEMORY" == "Yes" || "$Q_LIMIT_MEMORY" == "YES" || "$Q_LIMIT_MEMORY" == "yes" ]] ; then
            echo "Please enter your new limit memory"
            read LIMIT_MEMORY
        else
            LIMIT_MEMORY=$(grep limits ~/gpu/resource-quotas/test.yaml | tail -6 | grep limits.memory | head -1 | awk '{print $2}' | tr -d \")
        fi


        echo "Do you want to change the limit CPU? (Yes/NO)"
        read Q_LIMIT_CPU

        if [[ "$Q_LIMIT_CPU" == "Yes" || "$Q_LIMIT_CPU" == "YES" || "$Q_LIMIT_CPU" == "yes" ]] ; then
            echo "Please enter your new limit CPU"
            read LIMIT_CPU
        else
            LIMIT_CPU=$(grep limits ~/gpu/resource-quotas/test.yaml | tail -6 | grep limits.cpu | head -1 | awk '{print $2}' | tr -d \")
        fi

        echo "Do you want to change for the ResourceQuota? (Yes/NO)"
        read Q_QUOTA_NAME

        if [[ "$Q_QUOTA_NAME" == "Yes" || "$Q_QUOTA_NAME" == "YES" || "$Q_QUOTA_NAME" == "yes" ]] ;then
            echo "Please enter your new ResourceQuota"
            read NEW_QUOTA_NAME
        else
            NEW_QUOTA_NAME=$(grep name  ~/gpu/resource-quotas/test.yaml | tail -2 | head -1 | awk '{print $2}' |tr -d \")
        fi


        echo "Do you want to change for the Namespace? (Yes/NO)"
        read Q_NAMESPACE

        if [[ "$Q_NAMESPACE" == "Yes" || "$Q_NAMESPACE" == "YES" || "$Q_NAMESPACE" == "yes" ]] ;then
            echo "Please enter your Namespace"
            read NEW_NAMESPACE
        else
            NAMESPACE=$(grep name  ~/gpu/resource-quotas/test.yaml | tail -2 | head -2 | tail -1 | awk '{print $2}' |tr -d \")
        fi

        if [  "$NEW_NAMESPACE" != "$NAMESPACE" ]; then
            if [[ $(oc get project | awk '{print $1}' | grep "$NEW_NAMESPACE") =~ ^$  ]]; then
                echo "The Namespace is not exist , it on creating"
                oc new-project "$NEW_NAMESPACE" 
                echo "The Namespace "$NEW_NAMESPACE" is successfully created \n"
            fi
        else
            echo "THE Namespace/project "$NEW_NAMESPACE" is already created, You can countine"
        fi


        # Change to the new values

        sed -e "s/metadata.name:.*/metadata.name: \"${NEW_QUOTA_NAME}\"/g"  \
        -e "s/metadata.namespace:.*/metadata.namespace: \"${NEW_NAMESPACE}\"/g" \
        -e "s/requests.memory:.*/requests.memory: \"${REQUEST_MEMORY}\"/g" \
        -e "s/requests.cpu:.*/requests.cpu: \"${REQUEST_CPU}\"/g" \
        -e "s/limits.cpu:.*/limits.cpu: \"${LIMIT_CPU}\"/g" \
        -e "s/limits.memory:.*/limits.memory: \"${LIMIT_MEMORY}\"/g" ~/gpu/resource-quotas/"$QUOTA_NAME".yaml > ~/gpu/resource-quotas/"NEW-$NEW_QUOTA_NAME".yaml


        # Apply the changes 

        if [ "$NEW_QUOTA_NAME" != "$QUOTA_NAME" ] ; then
            rm -f ~/gpu/resource-quotas/"$QUOTA_NAME".yaml
            mv ~/gpu/resource-quotas/"NEW-$NEW_QUOTA_NAME".yaml ~/gpu/resource-quotas/"$NEW_QUOTA_NAME".yaml
            oc delete resourcequota "$QUOTA_NAME" -n "$NAMESPACE"
            oc apply -f ~/gpu/resource-quotas/"$NEW_QUOTA_NAME".yaml

        else
            mv ~/gpu/resource-quotas/"NEW-$NEW_QUOTA_NAME".yaml ~/gpu/resource-quotas/"$QUOTA_NAME".yaml
            oc apply -f ~/gpu/resource-quotas/"$QUOTA_NAME".yaml
        fi

        
        echo "ResourceQuota updated successfully in namespace "$NAMESPACE""


    elif [[ "$CHOISE" == "No" || "$CHOISE" == "NO" || "$CHOISE" == "no" ]] ; then
        echo "ResourceQuota not changed"
    else
        echo "invalid input"
        exit 1
    fi
fi