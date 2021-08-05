#!/bin/bash

WP_IMAGE="hacklab/wp:latest"
DB_IMAGE="mariadb:10.4"

WP_VOLUME_SIZE="5Gi"
DB_VOLUME_SIZE="2Gi"

WP_VOLUME_STORAGE_CLASS="cephfs"
DB_VOLUME_STORAGE_CLASS="sc-database"


install_help () {
   echo "

install.sh --namespace=project-namespace --host=mysite.com [--wp-image=$WP_IMAGE] [--db-image=mariadb:10.3]

    --namespace        namespace do projeto a ser instalado.
    --host             hostname do projeto
    
    --wp-image         imagem utilizada para o pod wordpress. (padrão: $WP_IMAGE)
    --wp-volume-size   tamanho do volume do wordpress, montado em /var/www/html (padrão: $WP_VOLUME_SIZE).
    --wp-volume-sc     storage class do volume do wordpress (padrão: $WP_VOLUME_STORAGE_CLASS).

    --db-image         imagem utilizada para o pod do banco de dados. (padrão: $DB_IMAGE)
    --db-volume-size   tamanho do volume do banco de dados, montado em /var/lib/mysql (padrão: $DB_VOLUME_SIZE).
    --db-volume-sc     storage class do volume do banco de dados (padrão: $DB_VOLUME_STORAGE_CLASS).
"
}


for i in "$@"
do
case $i in
    --namespace=*)
            NAMESPACE="${i#*=}"
	    shift
    ;;
    --host=*)
            HOST="${i#*=}"
	    shift
    ;;
    --wp-image=*)
            WP_IMAGE="${i#*=}"
	    shift
    ;;
    --db-image=*)
            DB_IMAGE="${i#*=}"
	    shift
    ;;
    --wp-volume-size=*)
            WP_VOLUME_SIZE="${i#*=}"
	    shift
    ;;
    --db-volume-size=*)
            DB_VOLUME_SIZE="${i#*=}"
	    shift
    ;;
    --wp-volume-sc=*)
            WP_VOLUME_STORAGE_CLASS="${i#*=}"
	    shift
    ;;
    --db-volume-sc=*)
            DB_VOLUME_STORAGE_CLASS="${i#*=}"
	    shift
    ;;
    --help)
    	    install_help
    	    exit
    ;;
esac
done

if [ -z "${NAMESPACE}" ] || [ -z "${HOST}" ]; then
    install_help
    exit
fi

echo "
parâmetros para a crianção do ambiente:
- namespace:                   $NAMESPACE 
- host:                        $HOST

- WP Imagem:                   $WP_IMAGE
- WP Volume Size:              $WP_VOLUME_SIZE
- WP Volume Storage Class      $WP_VOLUME_STORAGE_CLASS

- DB Imagem:                   $DB_IMAGE
- DB Volume Size:              $DB_VOLUME_SIZE
- DB Volume Storage Class      $DB_VOLUME_STORAGE_CLASS
"

read -p 'Os parâmetros acima estão corretos? [y|N]: ' CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo ""
    echo "Corriga os parâmetros e rode novamente o comando."
    install_help
    exit
fi

echo "Instalando ambiente";


helm install --namespace=$NAMESPACE --set "image=$WP_IMAGE,db.image=$DB_IMAGE,ingress.hosts[0].host=$HOST,ingress.hosts[0].paths[0]='/',ingress.secretName=$NAMESPACE-crt,persistence.size=$WP_VOLUME_SIZE,persistence.storageClass=$WP_VOLUME_STORAGE_CLASS,db.persistence.size=$DB_VOLUME_SIZE,db.persistence.storageClass=$DB_VOLUME_STORAGE_CLASS" $NAMESPACE ./