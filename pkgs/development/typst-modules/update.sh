#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq
# shellcheck shell=bash

set -euo pipefail

# https://stackoverflow.com/a/246128/1368502
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SRC=$(nix eval .#typst-packages.src.outPath | tr -d '"')/packages/preview
PREVIEW="share/typst/packages/preview"

for pkg in "$SRC"/*
do
    bpkg=$(basename "$pkg")
    for ver in "$pkg"/*
    do
        bver=$(basename "$ver")
        mkdir -p "$SCRIPT_DIR/$bpkg/$bver"
        {
            echo "{ stdenvNoCC, typst-packages }:"
            echo "stdenvNoCC.mkDerivation {"
            echo "  pname = \"$bpkg\";"
            echo "  version = \"$bver\";"
            echo "  dontUnpack = true;"
            echo "  installPhase = ''"
            echo "    mkdir -p \$out/$PREVIEW/$bpkg/$bver"
            echo "    cp -r \${typst-packages.src}/packages/preview/$bpkg/$bver \$out/$PREVIEW/$bpkg"
            echo "  '';"
            echo "}"
        } > "$SCRIPT_DIR/$bpkg/$bver/package.nix"
        break
    done
    break
done
