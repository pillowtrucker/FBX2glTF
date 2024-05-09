{ lib, llvmPackages_18, fetchFromGitHub, fetchzip, cmake, pkgs }:
let
  sdk = (fetchzip {
    url =
      "https://github.com/V-Sekai/FBXSDK-Linux/archive/refs/tags/2020.2.zip";
    hash = "sha256-X12mFTOJfaZpo5icESTuqpZL5PJMcl5IGwGiQEaGdpE=";
    name = "fbxsdk";
  });
  mathfu = (fetchFromGitHub {
    name = "mathfu";
    owner = "google";
    repo = "mathfu";
    rev = "v1.1.0";
    hash = "sha256-lYQrH6wgx0n5ZQcUyH1P/5RmopEdjRHa6NYXBDbUwBY=";
    fetchSubmodules = true;
  });
  fifo_map = (fetchFromGitHub {
    name = "fifo_map";
    owner = "nlohmann";
    repo = "fifo_map";
    rev = "v1.0.0";
    hash = "sha256-GJgiXMGeSr2u9SscE4u6fQdZ6FCS8UiTpfJl5s10qXg=";
    #    fetchSubmodules = true;
  });
  thishere = builtins.path {
    path = ./.;
    name = "fbx2gltf";
  };
in llvmPackages_18.stdenv.mkDerivation rec {
  pname = "fbx2gltf";
  version = "7cf9f0acf005bdf89e8b4b18746aa687872da403";
  srcs = [ thishere sdk mathfu fifo_map ];
  stdenv = llvmPackages_18.stdenv;
  nativeBuildInputs = [ cmake ];
  sourceRoot = "fbx2gltf";
  preConfigure = ''
    chmod ug+rwx ../fifo_map -R
    mv ../fifo_map ./
    chmod ug+rwx ../mathfu -R
    mv ../mathfu ./
    chmod ug+rwx ../fbxsdk -R
    mv ../fbxsdk/sdk ./
    zstd -d -r --rm ./sdk || true
  '';

  buildInputs = with pkgs; [
    conan
    llvmPackages_18.bintools # why the fuck is this not in stdenv but other shit is
    #    llvmPackages_18.clang
    #    llvmPackages_18.clang-tools
    python3
    git
    boost
    fmt_8
    libxml2
    cmake
    cmakeCurses
    ninja
    python3
    git
    draco

    cppcodec
    # Development time dependencies
    #    gtest
    vulkan-validation-layers
    # Build time and Run time dependencies
    vulkan-loader
    vulkan-headers
    vulkan-tools
    pkg-config
    xorg.libX11
    libdrm
    libxkbcommon
    xorg.libXext
    xorg.libXv
    xorg.libXrandr
    xorg.libxcb
    zlib
    libuuid
    wayland
    pulseaudio
  ];
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = with lib; {
    homepage = "https://github.com/pillowtrucker/retarded_sisyphus";
    description = ''
      Fourth rewrite";
    '';
    license = licenses.agpl3Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.breakds ];
  };
}
