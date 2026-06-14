#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing GPU Vulkan driver (hardware-detected)"

# Q40 hardware-script starter: install the right open-source Vulkan
# driver for the detected GPU so Chrome (and other GPU consumers)
# stop falling back to SwiftShader / CPU rendering. NVIDIA proprietary
# driver setup is more involved (DKMS, kernel module loading order)
# and is deferred to a dedicated Q40 iter.
#
# Detection: `lspci -nn` for GPU class (VGA = 0300, 3D = 0302, Display = 0380).
gpu_info="$(lspci -nn 2> /dev/null | grep -E '0300|0302|0380' || true)"

if [[ -z ${gpu_info} ]]; then
  echo "No GPU detected via lspci. Skipping Vulkan driver install."
  exit 0
fi

driver=""
case "${gpu_info}" in
  *AMD* | *ATI* | *Advanced\ Micro\ Devices* | *Radeon*)
    driver="vulkan-radeon"
    ;;
  *Intel*)
    driver="vulkan-intel"
    ;;
  *NVIDIA*)
    echo "NVIDIA GPU detected. Proprietary driver install deferred — see Q40."
    echo "(GPU info: ${gpu_info})"
    exit 0
    ;;
  *)
    echo "Unrecognized GPU vendor; skipping. (GPU info: ${gpu_info})"
    exit 0
    ;;
esac

if paco-pkg-present "${driver}"; then
  echo "${driver} already installed."
  exit 0
fi

paco-pkg-add "${driver}"
echo "Installed ${driver}."
echo "(Takes effect on next session restart; current Chrome instances still use SwiftShader.)"
