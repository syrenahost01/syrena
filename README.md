# syrena

dans /home/$currentuser :

git clone https://github.com/syrenahost01/syrena.git

cd syrena

chmod +x install-base.sh

./install-base.sh

Puis, selon CENTRAL, LOCAL, TABLETTE, aller dans le répertoire syrena-.... correspondant.

Puis modifier dans le .env les variables KAFKA_LOCAL_BROKER_HOSTNAME et KAFKA_REMOTE_BROKER_HOSTNAME.

Puis lancer l'installation avec le fichier : ./syrena-install.sh

Accès à PORTAINER sur le port 9000 / Kafka Control Center sur port 9021 / Grafana sur port 3000
