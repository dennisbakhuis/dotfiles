# Use Wayland and NVidida


1. comment `WaylandEnable=false` in /etc/gdm/custom.conf
2. disable udev rule to disable wayland: `sudo ln -s /dev/null /etc/udev/rules.d/61-gdm.rules`
3. turn on kms-modifiers: `gsettings set org.gnome.mutter experimental-features '["kms-modifiers"]'`
4. make sure xorg-wayland is installed: `sudo pacman -Syu --needed xorg-xwayland libxcb egl-wayland`
5. reboot

For actual NVidia for display rules, enable DRM in kernel/mkinitcpio:

1. Add `nvidia-drm.modeset=1` to /etc/default.grub and `sudo grub-mkconfig -o /boot/grub/grub.cfg`
2. Possibly update `MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)` in /etc/mkinitcpio.conf and `sudo mkinitcpio -P`
