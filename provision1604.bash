#!/usr/bin/env bash
set -e

gsettings set com.canonical.Unity.Lenses remote-content-search 'none'

sudo apt-get install build-essential
sudo apt-get update

basics() {
sudo apt-get -y install git vim python-pip vlc gparted screen cython
}

pips() {
pip install --upgrade pip
sudo pip install tqdm nltk word2vec tensorflow ipython --upgrade
# conda install tensorflow
}

nltkdownloads() {
python -m nltk.downloader all
}

sublime() {
sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get update
sudo apt-get -y --purge remove sublime-text*
sudo apt-get -y install sublime-text
}

dropbox() {
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd
#sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
#sudo add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main"
#sudo apt-get update
#sudo apt-get install -y nautilus-dropbox
echo 'deb http://linux.dropbox.com/ubuntu saucy main'>>'dropbox.list'
chmod 644 'dropbox.list'
sudo chown root:root 'dropbox.list'
sudo mv 'dropbox.list' '/etc/apt/sources.list.d/dropbox.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5044912E
sudo apt-get update
sudo apt-get -y install dropbox
}

games() {
sudo apt-get install -y visualboyadvance mupen64plus zsnes
}

playonlinux() {
wget https://www.playonlinux.com/script_files/PlayOnLinux/4.2.10/PlayOnLinux_4.2.10.deb
sudo dpkg -i PlayOnLinux_4.2.10.deb
rm PlayOnLinux_4.2.10.deb
}

wine() {
sudo add-apt-repository -y ppa:wine/wine-builds
sudo apt-get update
sudo apt-get --assume-yes install --install-recommends winehq-devel
}

steam() {
sudo apt-get --assume-yes install steam
}

jdk8() {
sudo apt install python-software-properties -y
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt update
sudo apt -y install oracle-java8-installer
sudo apt -y install oracle-java8-set-default
}

clementine() {
sudo add-apt-repository ppa:me-davidsansome/clementine -y
#sudo add-apt-repository ppa:gstreamer-developers/ppa
sudo apt-get update
sudo apt-get -y install clementine
}

dconftools() {
sudo apt-get -y install dconf-tools
}

clam() {
sudo apt-install -y clamav
sudo apt-install -y clamtk
}

chromium() {
sudo apt-get -y install chromium-browser
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

calibre() {
# Calibre
# You must have xdg-utils, wget and python ≥ 2.6 installed on your system before running the installer. (Those are standard in Ubuntu)
sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
# If you get an error about an untrusted certificate, that means your computer does not have any root certificates installed and so cannot download the installer securely. If you still want to proceed, pass the --no-check-certificate option to wget, like this:
# sudo -v && wget --no-check-certificate -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
# You can uninstall calibre by running sudo calibre-uninstall. Alternately, simply deleting the installation directory will remove 99% of installed files.
}

new_public_key() {
	# generate public key for git and other purposes
	mkdir -p "$HOME/.ssh"
	keypath="$HOME/.ssh/id_rsa"
	ssh-keygen -t rsa -C "$user_email" -N "" -f "$keypath"
	chmod 0600 "$keypath"
}

anaconda() {
	# install Anaconda (Python 2.7 version)
	# NOTE that we prefer system python by default; user can specify anaconda
	# python path if they want that one
	anaconda_installer_file=$(basename "$anaconda_download_url")
	if [ ! -f "$anaconda_installer_file" ]
	then
		wget "$anaconda_download_url"
	fi
	chmod +x "$anaconda_installer_file"
	"./$anaconda_installer_file" -b -p "$anaconda_prefix"
	export ANACONDA="$anaconda_prefix"
	export PATH="$PATH:$anaconda_prefix/bin"
}

anaconda_bashrc() {
	echo "ANACONDA=\"$anaconda_prefix\"" >> $HOME/.bashrc
	echo "PATH=\"\$PATH:$anaconda_prefix/bin\"" >> $HOME/.bashrc
}

install_glances_with_plugins() {
	# https://github.com/nicolargo/glances
	
	apt install python-pip python-dev -y
	pip install glances[gpu,ip]

	# install nvidia-ml-py dependency from source, because authors didn't update their pip module
	# https://github.com/jonsafari/nvidia-ml-py
	curl -O -J "https://pypi.python.org/packages/72/31/378ca145e919ca415641a0f17f2669fa98c482a81f1f8fdfb72b1f9dbb37/nvidia-ml-py-7.352.0.tar.gz"
	tar -xzf "nvidia-ml-py-7.352.0.tar.gz"
	cd "nvidia-ml-py-7.352.0/"
	python setup.py install
	cd ..
	rm -rf "./nvidia-ml-py-7.352.0"*

	# write a config that adds some port RTTs to the monitor
	glances_conf_dir="/etc/glances"
	mkdir -p $glances_conf_dir
	cat <<-EOF > $glances_conf_dir/glances.conf
		[ports]
		refresh=5

		port_1_description=pccfs
		port_1_host=pccfs.cs.byu.edu
		port_1_port=22
		port_1_rtt_warning=5

		port_2_description=google.com
		port_2_host=google.com
		port_2_port=443
		port_2_rtt_warning=250
	EOF

	# TODO: Print some basic usage instructions? (-1 and -6 hotkeys, and how to sort process list?)
	glances -V
}

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
#playonlinux
#wine
steam
jdk8
clementine
dconftools

sudo apt-get -y upgrade
sudo apt autoremove

clear
echo 'Reboot now.'
