sudo mkdir /var/run/salt
sudo chown -R $USER:$USER /var/run/salt
xrdb -merge .Xresources
#dbus-update-activation-environment --all
exec i3
