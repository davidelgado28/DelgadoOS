#!/bin/bash
set -e

echo "Instalando Toolchain de Desenvolvimento"
install_packages git python3 nodejs gcc make cmake curl wget

echo "Instalando Brave Browser (Único Navegador Web)"
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
wget "https://github.com/brave/brave-browser/releases/latest/download/brave-browser-linux-amd64.zip"
unzip brave-browser-linux-amd64.zip -d /opt/brave
ln -sf /opt/brave/brave-browser /usr/bin/brave

echo "Instalando Visual Studio Code"
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64" -O vscode.tar.gz
tar -xzf vscode.tar.gz -C /opt/
mv /opt/VSCode-linux-x64 /opt/vscode
ln -sf /opt/vscode/bin/code /usr/bin/code

mkdir -p /etc/skel/.config/Code/User
cat <<EOF > /etc/skel/.config/Code/User/settings.json
{
    "workbench.colorTheme": "Default Dark Modern",
    "editor.fontFamily": "'JetBrainsMono Nerd Font', 'Fira Code', monospace",
    "editor.fontLigatures": true,
    "editor.formatOnSave": true,
    "window.menuBarVisibility": "toggle"
}
EOF

echo "export EDITOR=code" >> /etc/profile
echo "export PATH=\$PATH:/opt/vscode/bin:/opt/brave" >> /etc/profile
