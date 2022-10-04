# turn off virus scanner
sudo systemctl stop clamav-daemon.service
sudo systemctl disable clamav-daemon.service
sudo systemctl stop clamav-freshclam.service
sudo systemctl disable clamav-freshclam.service
