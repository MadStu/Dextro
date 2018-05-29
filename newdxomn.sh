#!/bin/bash
clear
sleep 1
if [ -e getdxoinfo.json ]
then
	echo " "
	echo "Script running already?"
	echo " "

else
echo "blah" > getdxoinfo.json

THISHOST=$(hostname -f)

#sudo apt-get install jq pwgen -y

#killall dextrod
#rm -rf dextro*
#rm -rf .dextro*

wget http://80.211.168.44/dextro-linux64-ubuntu1604.tar.gz
tar -xvzf dextro-linux64-ubuntu1604.tar.gz

#wget https://github.com/dextrocoin/dextro/releases/download/1.0.1.1/dextro_ubuntu_16.04_v1.0.1.zip
#unzip dextro_ubuntu_16.04_v1.0.1.zip
#chmod 777 dextro/de*

rm dextro-linux64-ubuntu1604.tar.gz

mkdir ~/.dextro
RPCU=$(pwgen -1 4 -n)
PASS=$(pwgen -1 14 -n)
EXIP=$(curl ipinfo.io/ip)

printf "rpcuser=rpc$RPCU\nrpcpassword=$PASS\nrpcport=39321\nrpcthreads=8\nrpcallowip=127.0.0.1\nbind=$EXIP:39320\nmaxconnections=128\ngen=0\nexternalip=$EXIP\ndaemon=1\n\naddnode=80.211.24.40\naddnode=85.255.10.24\naddnode=77.81.234.190\naddnode=80.211.168.44\naddnode=194.182.80.106\naddnode=194.182.80.69\naddnode=94.177.254.207\naddnode=80.211.27.191\naddnode=185.33.145.138\naddnode=80.211.219.176\naddnode=194.182.81.153\naddnode=80.211.187.187\naddnode=94.177.170.193\naddnode=80.211.134.175\naddnode=seed1.dextro.io\naddnode=seed2.dextro.io\naddnode=seed3.dextro.io\naddnode=seed4.dextro.io\naddnode=seed5.dextro.io\naddnode=seed6.dextro.io\naddnode=seed7.dextro.io\naddnode=seed8.dextro.io\n\n" > ~/.dextro/dextro.conf

~/dextro/dextrod -daemon
sleep 20
MKEY=$(~/dextro/dextro-cli masternode genkey)



~/dextro/dextro-cli stop
printf "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> ~/.dextro/dextro.conf
sleep 60
~/dextro/dextrod -daemon
sleep 10
~/dextro/dextro-cli stop
sleep 30

mkdir ~/backup
cp ~/.dextro/dextro.conf ~/backup/dextro.conf
cp ~/.dextro/wallet.dat ~/backup/wallet.dat



crontab -l > mycron
echo "@reboot ~/dextro/dextrod -daemon && sleep 5 && ~/dextro/dextro-cli masternode start-all >/dev/null 2>&1" >> mycron
crontab mycron
rm mycron




echo "Reindexing blockchain..."

~/dextro/dextro-cli stop
sleep 5
rm ~/.dextro/mncache.dat
rm ~/.dextro/mnpayments.dat
sleep 35
~/dextro/dextrod -daemon -reindex
sleep 2

################################################################################

sleep 10




while true; do

ARRAY=$(~/dextro/dextro-cli getblockchaininfo)
echo "$ARRAY" > getdxoinfo.json
BLOCKCOUNT=$(jq '.headers' getdxoinfo.json)
WALLETBLOCKS=$(jq '.blocks' getdxoinfo.json)

if (( $(echo "$WALLETBLOCKS < 39000" | bc -l) )); then
	clear
	echo " "
	echo " "
	echo "  Keep waiting..."
	echo " "
	echo "    Blocks so far: $WALLETBLOCKS"
	echo " "
	echo " "
	echo " "
	sleep 5
else
	echo " "
	echo " "
	echo "    Complete!"
	echo " "
	echo " "
	sleep 5
	break
fi
	echo " "
	echo " "
	echo " "
done








echo "Now wait for AssetID: 999..."
sleep 1


while true; do

MNSYNC=$(~/dextro/dextro-cli mnsync status)
echo "$MNSYNC" > mndxosync.json
ASSETID=$(jq '.RequestedMasternodeAssets' mndxosync.json)

if (( $(echo "$ASSETID < 900" | bc -l) )); then
	clear
	echo " "
	echo " "
	echo "  Keep waiting..."
	echo " "
	echo "  Looking for: 999"
	echo "      AssetID: $ASSETID"
	echo " "
	echo " "
	echo " "
	sleep 5
else
	echo " "
	echo " "
	echo "    Complete!"
	echo " "
	echo " "
	sleep 5
	break
fi
	echo " "
	echo " "
	echo " "
done


#################




###########################
# ~ Fix to make it work ~ #
###########################

sleep 2
~/dextro/dextro-cli stop
sleep 10
rm ~/.dextro/mn*
~/dextro/dextrod -daemon -reindex
sleep 10


while true; do

MNSYNC=$(~/dextro/dextro-cli mnsync status)
echo "$MNSYNC" > mndxosync.json
ASSETID=$(jq '.RequestedMasternodeAssets' mndxosync.json)

if (( $(echo "$ASSETID < 900" | bc -l) )); then
	clear
	echo " "
	echo " "
	echo "  Keep waiting..."
	echo " "
	echo "  Looking for: 999"
	echo "      AssetID: $ASSETID"
	echo " "
	echo " "
	echo " "
	sleep 5
else
	echo " "
	echo " "
	echo "    Complete!"
	echo " "
	echo " "
	sleep 5
	break
fi
	echo " "
	echo " "
	echo " "
done


###########################

rm mndxosync.json

echo " "
echo " "
echo " "



sleep 2
echo "=================================="
echo " "
echo "Your masternode.conf should look like:"
echo " "
echo "MNxx $EXIP:39320 $MKEY TXID VOUT"
echo " "
echo "=================================="
echo " "
echo " "
echo " "
echo "       Thanks for using MadStu's Install Script"
echo " "

rm getdxoinfo.json
cp ~/.dextro/masternode.conf ~/backup/masternode.conf

fi

