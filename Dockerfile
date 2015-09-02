FROM cviebig/arch-build-ocl

RUN pacman -S --noprogressbar --noconfirm opencl-headers java-environment unzip

RUN mkdir -v -p /var/abs/local
RUN cd /var/abs/local && \
    curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/libpng12.tar.gz && \
    curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/intel-opencl-sdk.tar.gz && \
    curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/intel-opencl-runtime.tar.gz && \
    curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/clinfo.tar.gz && \
    tar -xzvf libpng12.tar.gz && \
    tar -xzvf intel-opencl-sdk.tar.gz && \
    tar -xzvf intel-opencl-runtime.tar.gz && \
    tar -xzvf clinfo.tar.gz

RUN useradd -ms /bin/bash buildbot
RUN chown -R buildbot:buildbot /var/abs/local
RUN chmod -R 744 /var/abs/local
RUN su -c "cd /var/abs/local/libpng12 && makepkg" - buildbot
RUN pacman -U --noconfirm /var/abs/local/libpng12/libpng12-*-x86_64.pkg.tar.xz
RUN pacman -S --noconfirm rpmextract libcl intel-tbb numactl
RUN su -c "cd /var/abs/local/intel-opencl-sdk && makepkg" - buildbot
RUN pacman -U --noconfirm /var/abs/local/intel-opencl-sdk/intel-opencl-sdk-*-x86_64.pkg.tar.xz
RUN su -c "cd /var/abs/local/intel-opencl-runtime && makepkg" - buildbot
RUN pacman -U --noconfirm /var/abs/local/intel-opencl-runtime/intel-opencl-runtime-*-x86_64.pkg.tar.xz
RUN pacman -S --noconfirm git
RUN su -c "cd /var/abs/local/clinfo && makepkg" - buildbot
RUN pacman -U --noconfirm /var/abs/local/clinfo/clinfo-*-x86_64.pkg.tar.xz
