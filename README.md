# helm-wordpress

para instalar um novo ambiente

```
$ ./install.sh
install.sh --namespace=project-namespace --host=mysite.com [--wp-image=hacklab/wp:latest] [--db-image=mariadb:10.3]

    --namespace        namespace do projeto a ser instalado.
    --host             hostname do projeto
    
    --wp-image         imagem utilizada para o pod wordpress. (padrão: hacklab/wp:latest)
    --wp-volume-size   tamanho do volume do wordpress, montado em /var/www/html (padrão: 5Gi).
    --wp-volume-sc     storage class do volume do wordpress (padrão: cephfs).

    --db-image         imagem utilizada para o pod do banco de dados. (padrão: mariadb:10.4)
    --db-volume-size   tamanho do volume do banco de dados, montado em /var/lib/mysql (padrão: 2Gi).
    --db-volume-sc     storage class do volume do banco de dados (padrão: sc-database).
```
```
exemplo:
```
./install.sh --namespace=teste1 --host=teste.hacklab.com.br --db-image=mysql:5.4 --db-volume-size=3Gi --wp-volume-size=4Gi --wp-volume-sc=gp2 --db-volume-sc=gp2
```