########################################################
# Install script to get perfect up and running. Run manually top to bottom for now until this is tested to complete successfully.
########################################################

echo -n "Enter a name for your app >"
read NAME
echo -n "Enter a hostname for your new server >"
read HOSTNAME
echo -n "Do you want to install Postgres? 'y/N'"
read INSTALL_POSTGRES

SWIFT_VERSION=swift-2.2-SNAPSHOT-2015-12-22-a-ubuntu14.04.tar.gz

# Basics.
sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y git
sudo echo $HOSTNAME > /etc/hostname

# App dir.
cd /
sudo mkdir apps
sudo chmod 750 /apps
sudo chown ubuntu /apps
cd apps

# Clone repo.
git clone https://github.com/crewshin/perfectly-swift.git $NAME
cd $NAME

# Install postgres.
if [ $INSTALL_POSTGRES = "y" ]; then
    echo "Installing postgres 9.4"
    sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -y postgresql-9.4
fi

# Install perfect. https://github.com/PerfectlySoft/Perfect/tree/master/PerfectLib#perfectlib
sudo apt-get install -y libssl-dev libevent-dev libsqlite3-dev clang libicu-dev
cd ~/
URL=https://swift.org/builds/ubuntu1404/swift-2.2-SNAPSHOT-2015-12-22-a/$SWIFT_VERSION
wget $URL
tar -xvzf $SWIFT_VERSION

# Import PGP keys.
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys '7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD' '1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F'
gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

echo "export PATH=~/$SWIFT_VERSION/usr/bin/:"${PATH}"" >> ~/.bashrc
source ~/.bashrc

# Automatic signing keys.
wget -q -O - https://swift.org/keys/automatic-signing-key-1.asc | gpg --import -

# Clone PerfectLib.
git clone https://github.com/PerfectlySoft/Perfect.git
cd Perfect/PerfectLib
make
sudo make install
ls /usr/local/lib/*Perfect* # This should list "/usr/local/lib/PerfectLib.so  /usr/local/lib/PerfectLib.swiftdoc  /usr/local/lib/PerfectLib.swiftmodule"

# Build PerfectServer.
cd ~/Perfect/PerfectServer/
make
sudo ln -s ~/Perfect/PerfectServer/perfectserverhttp /usr/local/bin/perfectserverhttp
sudo ln -s ~/Perfect/PerfectServer/perfectserverfcgi /usr/local/bin/perfectserverfcgi
