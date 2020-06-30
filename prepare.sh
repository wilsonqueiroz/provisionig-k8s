#!/bin/sh

username=$1
password=$2
url=$3

create (){

    if [ $username != "" ]; then

        if [ $password != "" ]; then

            if [ $url != "" ]; then

                oc login $url --username='$username' --password='$password'

                oc new-project cicd-tools --description='This is a project to cicd tools' --display-name='CI/CD Tools Project'
                
                if ! echo "$(oc status)"  | grep -q 'project "cicd-tools"'; then 
                    sh ./jenkins.sh
                    #sh ./nexus3.sh

                    if echo $? | grep 1; then

                        echo "Do you have one error in jenkins: code: $?"
                        oc delete project cicd-tools

                        return $?
                    fi

                    return 0;
                else 
                    
                    echo "The project no was created"
                    oc delete project cicd-tools
                    
                    return 1;
                fi

            else
                echo "Inform the url"
                return 1;
            fi

        else
            echo "Inform the password"
            return 1;
        fi

    else
        echo "Inform the username"
        return 1;
    fi

}

help (){

    echo "prepare --username --password --url"
}

"$@"
