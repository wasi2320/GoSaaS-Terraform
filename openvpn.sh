#!/bin/bash


sudo mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
rm amazon-ssm-agent.deb




exec 1>OpenVPNServer-Initial.log 2>&1
sudo su
apt -y update
echo -e "\n *****************************************************************************************" 
echo -e "\n *****************************************************************************************" 
apt -y install expect
echo -e "\n *****************************************************************************************" 
echo -e "\n *****************************************************************************************" 
wget https://git.io/vpn -O openvpn-install.sh
echo -e "\n *****************************************************************************************" 
echo -e "\n *****************************************************************************************" 
echo 
chmod +x openvpn-install.sh
/usr/bin/expect << EOF
spawn ./openvpn-install.sh
expect "This server is behind NAT" { send "\r" }
expect -ex {Protocol [1]} { send "1\r" }
expect -ex {Port [1194]} { send "2000\r" }
expect -ex {DNS server [1]} { send "1\r" }
expect "Enter a name for the first client" { send "Test\r" }
expect "Press any key to continue..." { send "\r" }
expect eof
EOF
echo -e "\n *****************************************************************************************" 
echo -e "\n *****************************************************************************************" 
mv OpenVPNServer-Initial.log /home/ubuntu/OpenVPNServer-Initial.log
chown ubuntu:ubuntu /home/ubuntu/OpenVPNServer-Initial.log
mv /root/Test.ovpn /home/ubuntu/Test.ovpn
chown ubuntu:ubuntu /home/ubuntu/Test.ovpn
exit
