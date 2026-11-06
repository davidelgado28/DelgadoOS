# DelgadoOS

Uma distribuição Linux focada em desenvolvedores, construída do zero (LFS/BLFS). Otimizada, com interface gráfica nativa em Dark Mode e ferramentas essenciais para programação pré-instaladas.

## Características
- **Base:** LFS/BLFS (Total controle e zero bloatware).
- **Interface:** XFCE4 customizado com painel inferior e Whisker Menu (Estilo Linux Mint).
- **Tema:** Catppuccin Dark (Sistema e VS Code).
- **Navegador:** Brave Browser (Foco em privacidade e zero anúncios, único navegador do sistema).
- **Dev Stack:** GCC, Make, Git, Python3, Node.js, VS Code.
- **Fontes:** JetBrains Mono e Fira Code.

## Como compilar a ISO
Requisitos do Host: Debian 12 ou Arch Linux com `build-essential`, `bison`, `gawk`, `texinfo`, `squashfs-tools`, `xorriso`, `grub-pc-bin`.

1. Clone o repositório: `git clone https://github.com/seu-usuario/delgadoos.git`
2. Entre na pasta: `cd delgadoos`
3. Execute como root: `sudo ./build.sh`

O processo automatizado criará a pasta `out/` contendo o arquivo `delgadoos.iso` pronto para boot em máquinas virtuais ou pendrives.
