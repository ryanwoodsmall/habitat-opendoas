pkg_name="opendoas"
pkg_origin="ryanwoodsmall"
pkg_version="6.8.2"
pkg_license=("ISC")
pkg_maintainer="ryanwoodsmall <rwoodsmall@gmail.com>"
pkg_description="A portable fork of the OpenBSD 'doas' command (minimal sudo-alike)"
pkg_upstream_url="https://github.com/Duncaen/OpenDoas"
pkg_dirname="${pkg_name}-${pkg_version}"
pkg_filename="${pkg_dirname}.tar.gz"
pkg_source="https://github.com/Duncaen/OpenDoas/releases/download/v${pkg_version}/${pkg_filename}"
pkg_shasum="28dca29adec5f4336465812d9e2243f599e62a78903de71c24f0cd6fe667edac"
pkg_build_deps=("core/gcc" "core/musl" "core/make" "core/bison")
pkg_bin_dirs=("bin")

do_build() {
  local CC="$(hab pkg path core/musl)/bin/musl-gcc"
  export CC
  ./configure \
    --prefix="${pkg_prefix}" \
    --sysconfdir="${pkg_prefix}/etc" \
    --enable-static \
    --without-pam
  make CC="${CC}"
  unset CC
}

do_install() {
  make install
  local dc="${pkg_prefix}/etc/doas.conf"
  mkdir -p "${pkg_prefix}/etc"
  echo -n > "${dc}"
  echo 'permit hab' >> "${dc}"
  echo 'permit :hab' >> "${dc}"
  echo 'permit nopass hab cmd ls' >> "${dc}"
  chmod 0600 "${dc}"
  unset dc
}
