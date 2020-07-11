#!/bin/bash

package() {
  if [ ! -d "$1" ]; then
    echo "Missing package directory"
    exit 1
  fi

  local ver=$(cat Include/Module/Protocol/OcQuirks.h | grep OCQUIRKS_PROTOCOL_REVISION | cut -f4 -d' ' | cut -f2 -d'"' | grep -E '^[0-9.]+$')
  if [ "$ver" = "" ]; then
    echo "Invalid version $ver"
  fi

  rm -rf "$1"/tmp || exit 1
  mkdir -p "$1"/tmp/Drivers || exit 1
  cp OcQuirks.plist "$1"/tmp/Drivers || exit 1
  pushd "$1" || exit 1
  cp OcQuirks.efi tmp/Drivers/ || exit 1
  cp OpenRuntime.efi tmp/Drivers/ || exit 1
  pushd tmp || exit 1
  zip -qry -FS ../"OcQuirks-${ver}-${2}.zip" * || exit 1
  popd || exit 1
  rm -rf tmp || exit 1
  popd || exit 1
}

cd $(dirname "$0")
ARCHS=(X64)
SELFPKG=OcQuirks
DEPNAMES=('OpenCorePkg')
DEPURLS=('https://github.com/acidanthera/OpenCorePkg')
DEPBRANCHES=('master')
src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/ocbuild/master/efibuild.sh) && eval "$src" || exit 1