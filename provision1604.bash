#!/usr/bin/env bash
set -e

gsettings set com.canonical.Unity.Lenses remote-content-search 'none'

sudo apt-get update

basics() {
sudo apt-get -y install git vim pip vlc gparted screen
}

pips() {
pip install tqdm nltk cython word2vec tensorflow ipython --upgrade
# conda install tensorflow
}

nltkdownloads() {
python -m nltk.downloader all
}

sublime() {
sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get update
sudo apt-get --purge remove sublime-text*
sudo apt-get install sublime-text
}

dropbox() {
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sudo add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main"
sudo apt-get update
sudo apt-get install -y nautilus-dropbox
}

games() {
sudo apt-get install -y visualboyadvance mupen64plus zsnes
}

playonlinux() {
wget https://www.playonlinux.com/script_files/PlayOnLinux/4.2.10/PlayOnLinux_4.2.10.deb
dpkg -i PlayOnLinux_4.2.10.deb
rm PlayOnLinux_4.2.10.deb
}

wine() {
add-apt-repository -y ppa:wine/wine-builds
sudo apt-get update
apt-get --assume-yes install --install-recommends winehq-devel
}

steam() {
sudo apt-get --assume-yes install steam
}

jdk8() {
sudo apt install python-software-properties -y
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt update
sudo apt install oracle-java8-installer -y
}

clementine() {
sudo add-apt-repository ppa:me-davidsansome/clementine
#sudo add-apt-repository ppa:gstreamer-developers/ppa
sudo apt-get update
sudo apt-get install clementine
}

dconftools() {
sudo apt-get install dconf-tools
}

chromium() {
sudo apt-get install chromium-browser
}

chrome() {
sudo apt-get -y install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get -y install -f
sudo dpkg -i google-chrome*.deb
}

cuda() {
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda
}

# Calibre
# You must have xdg-utils, wget and python ≥ 2.6 installed on your system before running the installer. (Those are standard in Ubuntu)
sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
# If you get an error about an untrusted certificate, that means your computer does not have any root certificates installed and so cannot download the installer securely. If you still want to proceed, pass the --no-check-certificate option to wget, like this:
# sudo -v && wget --no-check-certificate -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
# You can uninstall calibre by running sudo calibre-uninstall. Alternately, simply deleting the installation directory will remove 99% of installed files.

plex() {
sudo gpasswd -a plex plugdev
maybe sudo gpasswd -a plex dan
check with: groups plex
find the name of the drive with: sudo fdisk -l
then: sudo gedit /etc/fstab
/dev/sdb1 /media/Seagate Backup Plus Drive/My Movies ntfs defaults 0 0
/dev/sdb1 /media/Seagate Backup Plus Drive/TV Shows ntfs defaults 0 0
sudo apt-get install ntfs-config ntfs-3g
run: ntfs-config
cd /media/your_external_drive
sudo chmod -R -v 777 *
/dev/sdb2 /media/Seagate\040Backup\040Plus\040Drive/My\040Movies	ntfs-3g	defaults,nosuid,nodev,locale=en_US.UTF-8	0	0
/dev/sdb2 /media/Seagate\040Backup\040Plus\040Drive/TV\040Shows	ntfs-3g	defaults,nosuid,nodev,locale=en_US.UTF-8	0	0

sudo apt-get install ntfs-config ntfs-3g
ntfs-config???

sudo vim /etc/default/plexmediaserver
cd /media/
sudo chmod -R -v 777 *

sudo vim /var/lib/plexmediaserver/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml 

#sudo start plexmediaserver
#sudo restart plexmediaserver
#sudo stop plexmediaserver
}

install_opencv() {
	# this installs cv2 with the contrib packages (ximgproc, etc) included
	# instructions: http://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html
	mkdir opencv
	cd opencv
	git clone https://github.com/opencv/opencv.git
	git clone https://github.com/opencv/opencv_contrib.git
	mkdir build
	cd build
	cmake -D CMAKE_BUILD_TYPE=Release \
		-D CMAKE_INSTALL_PREFIX=/usr/local \
		-D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
		-D PYTHON2_EXECUTABLE=/usr/bin/python \
		-D PYTHON_INCLUDE_DIR=/usr/include/python2.7 \
		-D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python2.7 \
		-D PYTHON_LIBRARY=/usr/lib/x86_64-linux_gnu/libpython2.7.so \
		-D PYTHON2_NUMPY_INCLUDE_DIRS=/usr/lib/python2.7/dist-packages/numpy/core/include/ \
		-D OPENCV_ENABLE_NONFREE=1 \
		../opencv
	make -j7
	sudo make install
	cd ../..
	rm -rf opencv/
}

echo 'Installing everything...'
basics
pips
nltkdownloads
sublime
dropbox
games
playonlinux
wine
steam
jdk8
clementine
dconftools

apt-get -y upgrade

clear
echo 'Reboot now.'
