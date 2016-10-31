FROM cviebig/arch-build-ocl

RUN pacman -S --noprogressbar --noconfirm unzip && \
    mkdir -v -p /var/abs/local && \
    cd /var/abs/local && \
    git clone https://aur.archlinux.org/libpng12.git && \
    git clone https://aur.archlinux.org/ncurses5-compat-libs.git && \
    git clone https://github.com/cviebig/arch-aur-intel-opencl-sdk.git intel-opencl-sdk && \
    git clone https://aur.archlinux.org/intel-opencl-runtime.git && \
    useradd -ms /bin/bash build || true && \
    chown -R build:build /var/abs/local && \
    chmod -R 744 /var/abs/local && \
    su -c "cd /var/abs/local/libpng12 && makepkg" - build && \
    su -c "gpg --recv-keys 702353E0F7E48EDB" - build && \
    su -c "cd /var/abs/local/ncurses5-compat-libs && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/libpng12/libpng12-*-x86_64.pkg.tar.xz && \
    pacman -U --noconfirm /var/abs/local/ncurses5-compat-libs/ncurses5-compat-libs-*-x86_64.pkg.tar.xz && \
    pacman -S --noconfirm rpmextract libcl intel-tbb numactl && \
    su -c "cd /var/abs/local/intel-opencl-sdk && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/intel-opencl-sdk/intel-opencl-sdk-*-x86_64.pkg.tar.xz && \
    su -c "cd /var/abs/local/intel-opencl-runtime && makepkg" - build && \
    pacman -U --noconfirm /var/abs/local/intel-opencl-runtime/intel-opencl-runtime-*-x86_64.pkg.tar.xz && \
    rm -rf /var/abs/local/* && \
    pacman -Scc --noconfirm
