#!/bin/bash
set -e

echo "Instalando Servidor Gráfico Xorg"

install_packages xorg-server xfce4 xfce4-goodies xfce4-whiskermenu-plugin

echo "Aplicando Estética DelgadoOS (Dark Mode + Fontes)"

mkdir -p /usr/share/fonts/TTF
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip FiraCode.zip -d /usr/share/fonts/TTF/
unzip JetBrainsMono.zip -d /usr/share/fonts/TTF/
fc-cache -fv

mkdir -p /usr/share/themes
git clone https://github.com/catppuccin/gtk.git /tmp/catppuccin
cp -r /tmp/catppuccin/src/Catppuccin-Mocha-Standard-Blue-Dark /usr/share/themes/DelgadoOS-Dark

mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
cat <<EOF > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="DelgadoOS-Dark"/>
    <property name="IconThemeName" type="string" value="Papirus-Dark"/>
  </property>
</channel>
EOF

# Define terminal padrão (xfce4-terminal) em esquema escuro
mkdir -p /etc/skel/.config/xfce4/terminal
cat <<EOF > /etc/skel/.config/xfce4/terminal/terminalrc
[Configuration]
FontName=JetBrainsMono Nerd Font 11
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
ColorBackground=#1e1e2e
ColorForeground=#cdd6f4
ColorPalette=#45475a;#f38ba8;#a6e3a1;#f9e2af;#89b4fa;#f5c2e7;#94e2d5;#bac2cc;#585b70;#f38ba8;#a6e3a1;#f9e2af;#89b4fa;#f5c2e7;#94e2d5;#a6adc8
EOF
