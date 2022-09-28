#!/bin/bash
#Asking Tccode and Lan Details from user
	read -p "Enter Tc-Code : " value1
	read -p "Enter LAN number (1,2,3,..) : " value2

#Creating Folders and File structure for log files
	sudo mkdir /var/log/"$value1" && \
	sudo chown -R syslog:adm /var/log/"$value1"
	sudo touch /var/log/"$value1"/"$value1"L"$value2".log
	sudo chown -R syslog:adm /var/log/"$value1"/"$value1"L"$value2".log

#Installing Rsyslog,ntp and vim
	sudo apt update -y
	sudo apt install -y rsyslog 
	sudo apt install -y ssh 
	sudo apt install -y ntp
	sudo apt install -y vim

#Editing the rsyslog configuration files
	sudo sed -i 's/#module(load="imudp")/module(load="imudp")/g' /etc/rsyslog.conf
	sudo sed -i 's/#input(type="imudp" port="514")/input(type="imudp" port="514")/g' /etc/rsyslog.conf
	sudo sed -i 's/#module(load="imtcp")/module(load="imtcp")/g' /etc/rsyslog.conf
	sudo sed -i 's/#input(type="imtcp" port="514")/input(type="imtcp" port="514")/g' /etc/rsyslog.conf
	sudo echo local7.* /var/log/"$value1"/"$value1"L"$value2".log >> /etc/rsyslog.d/50-default.conf

#Adding query command 
	sudo cp query.sh /var/log/"$value1"/query.sh
	sudo sed -i 's|replaceme|/var/log/'"$value1"'/'"$value1"'L'"$value2"'.log|g' /var/log/"$value1"/query.sh
	sudo chmod +x /var/log/"$value1"/query.sh
	sudo rm /usr/local/bin/query
	sudo ln -s /var/log/"$value1"/query.sh /usr/local/bin/query

#Adding monitor command
	sudo cp monitor.sh /var/log/"$value1"/monitor.sh
	sudo sed -i 's|replaceme|/var/log/'"$value1"'/'"$value1"'L'"$value2"'.log|g' /var/log/"$value1"/monitor.sh
	sudo chmod +x /var/log/"$value1"/monitor.sh
        sudo rm /usr/local/bin/monitor
        sudo ln -s /var/log/"$value1"/monitor.sh /usr/local/bin/monitor

#Adding filter command
	sudo cp filter.sh /var/log/"$value1"/filter.sh
        sudo sed -i 's|replaceme|/var/log/'"$value1"'/'"$value1"'L'"$value2"'.log|g' /var/log/"$value1"/filter.sh
        sudo chmod +x /var/log/"$value1"/filter.sh
        sudo rm /usr/local/bin/filter
        sudo ln -s /var/log/"$value1"/filter.sh /usr/local/bin/filter


#Removing duplicate entries 	
	sudo vim -esu NONE +'g/\v^(.*)\n\1$/d' +wq /etc/rsyslog.d/50-default.conf

#Restarting rsyslog service	
	sudo service rsyslog restart

#Editing /etc/ssh/ssh_config
	sudo sed -i 's/#   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc/Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc/g' /etc/ssh/ssh_config

#Editing /etc/ntp.conf for local

	sudo sed -i 's/pool 0.ubuntu.pool.ntp.org iburst/#pool 0.ubuntu.pool.ntp.org iburst/g' /etc/ntp.conf
	sudo sed -i 's/pool 1.ubuntu.pool.ntp.org iburst/#pool 1.ubuntu.pool.ntp.org iburst/g' /etc/ntp.conf
	sudo sed -i 's/pool 2.ubuntu.pool.ntp.org iburst/#pool 2.ubuntu.pool.ntp.org iburst/g' /etc/ntp.conf
	sudo sed -i 's/pool 3.ubuntu.pool.ntp.org iburst/#pool 3.ubuntu.pool.ntp.org iburst/g' /etc/ntp.conf
	sudo sed -i 's/pool ntp.ubuntu.com/#pool ntp.ubuntu.com/g' /etc/ntp.conf
        
	sudo echo server 127.127.1.0 >> /etc/ntp.conf
	sudo echo fudge 127.127.1.0 stratum 5 >> /etc/ntp.conf

#Removing Duplicate lines	
	sudo vim -esu NONE +'g/\v^(.*)\n\1$/d' +wq /etc/ntp.conf
