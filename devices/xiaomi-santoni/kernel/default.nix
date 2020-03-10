{ mobile-nixos
, fetchFromGitHub
, kernelPatches ? []
, dtbTool
, buildPackages
}:
let inherit (buildPackages) dtc; in
(mobile-nixos.kernel-builder {
  version = "3.18.140";
  configfile = ./config.aarch64;
  file = "Image.gz-dtb";
  hasDTB = true;
  src = fetchFromGitHub {
    owner = "bitrvmpd";
    repo = "msm-3.18";
    rev = "4363b5070938d177ece5ce6b3b4d0c814009516d";
    sha256 = stdenv.lib.fakeSha256;
  };
  patches = [
    ./99_framebuffer.patch
    ./bt-hci-smd.patch
  ];

  postPatch = ''
    # Remove -Werror from all makefiles
    local i
    local makefiles="$(find . -type f -name Makefile)
    $(find . -type f -name Kbuild)"
    for i in $makefiles; do
      sed -i 's/-Werror-/-W/g' "$i"
      sed -i 's/-Werror//g' "$i"
    done
    echo "Patched out -Werror"
  '';

  isModular = false;
}).overrideAttrs ({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "Image.gz" "zinstall" "Image.gz-dtb" "install" ];
  postInstall = postInstall + ''
    cp $buildRoot/arch/arm64/boot/Image.gz-dtb $out/
  '';
})
