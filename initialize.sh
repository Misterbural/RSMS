#!/bin/bash
# Ce script permet d'initialiser proprement RSMS. Il est à lancer depuis le répertoire racine de RSMS

#Verifie si sqlite3 est installé
command -v 'sqlite3'
if [ "$?" -ne "0" ]
then
	echo 'Installation de sqlite3'
	apt-get install sqlite3
fi

#Verifie si nodejs est installé
command -v 'nodejs'
if [ "$?" -ne "0" ]
then
	echo 'Installation de nodejs'
	apt-get install nodejs
fi

#Verifie si gammu est installé
command -v 'gammu'
if [ "$?" -ne "0" ]
then
	echo 'Installation de Gammu'
	apt-get install gammu
fi

#Verifie si gammu-smsd est installé
command -v 'gammu-smsd'
if [ "$?" -ne "0" ]
then
	echo 'Installation de Gammu-smsd'
	apt-get install gammu-smsd
fi

#Installation des bundles, migration des données, etc
bundle install
rake db:migrate
rake db:seed

# Verifie si il faut configurer automatiquement gammu
while [[ "$autogammu" != "y" && "$autogammu" != "n" ]]
do
	echo 'Il est possible de configurer automatiquement gammu. Pour cela, le module GSM gérant la carte SIM doit-être connecté à la Raspberry Pi. Voulez-vous le faire ? [y/n]';
	read autogammu;
done

if [ "$autogammu" == "y" ]
then
	echo 'Gammu va etre configure automatiquement.'

	#On va recupérer la conf générée avec gammu-detect
	echo "Creation des fichier de configuration /etc/gammurc et /etc/gammu-smsdrc"
	gammu-detect > /etc/gammurc
	gammu-detect > /etc/gammu-smsdrc
	
	#On va demander le code PIN
	echo "Rentrez le code PIN de votre carte SIM. (Laissez vide si elle n'a pas de code PIN)"
	read pin

	#On ajoute la configuration de gammu-smsd
	echo "# SMSD configuration, see gammu-smsdrc(5)" >> /etc/gammu-smsdrc
	echo "[smsd]" >> /etc/gammu-smsdrc
	echo "service = files" >> /etc/gammu-smsdrc
	echo "logfile = syslog" >> /etc/gammu-smsdrc
	echo "# Increase for debugging information" >> /etc/gammu-smsdrc
	echo "debuglevel = 0" >> /etc/gammu-smsdrc
	echo "RunOnReceive = $PWD/parseSMS.sh" >> /etc/gammu-smsdrc

	echo "# Paths where messages are stored" >> /etc/gammu-smsdrc
	echo "inboxpath = /var/spool/gammu/inbox/" >> /etc/gammu-smsdrc
	echo "outboxpath = /var/spool/gammu/outbox/" >> /etc/gammu-smsdrc
	echo "sentsmspath = /var/spool/gammu/sent/" >> /etc/gammu-smsdrc
	echo "errorsmspath = /var/spool/gammu/error/" >> /etc/gammu-smsdrc

	#Si on a bien un code PIN
	if [ "$pin" != "" ]
	then
		#On l'ajoute au fichier de configuration
		echo "Le code PIN $pin a été ajouté à la configuration de gammu"
		echo "pin = $pin" >> /etc/gammu-smsdrc
	else
		echo "Aucun code PIN ne sera utilisé."
	fi

	echo "Le fichier de configuration /etc/gammu-smsdrcrc a été généré correctement."
else
	echo "Le fichier de configuration /etc/gammu-smsdrcrc n'a pas pu être généré. Vous devrez le configurer à la main."
fi

echo "RSMS a été installé avec succès.";

#On va donner les bon droits aux différents fichiers
echo "Création du dossier $PWD/receiveds"
mkdir $PWD/receiveds
echo "Attribution du dossier $PWD/receiveds à l'utilisateur gammu";
chmod -R 755 $PWD/receiveds
chown -R gammu:gammu $PWD/receiveds
echo "Le dossier a bien été donné à gammu, avec les droits 755";
echo "Ajout droit d'execution sur $PWD/lib/tasks/cron.rake";
chmod +x $PWD/lib/tasks/cron.rake
echo "Droit d'execution ajoute";
echo "Ajout droit d'execution sur $PWD/parseSMS.sh";
chmod +x $PWD/parseSMS.sh
echo "Droit d'execution ajoute";

echo "Redémarrage de Gammu"
service gammu-smsd stop
service gammu-smsd start

#Ajout des taches CRON

echo "Ajout des tâches dans la crontab"
line="* * * * * cd $PWD && `command -v rake` cron:receive"
(crontab -u root -l; echo "$line" ) | crontab -u root -
line="* * * * * cd $PWD && `command -v rake` cron:send"
(crontab -u root -l; echo "$line" ) | crontab -u root -

echo "Installation terminée avec succès."
