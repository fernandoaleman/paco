#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring power management (power-profiles-daemon)"

# Enable + start power-profiles-daemon. Provides the 3-mode picker
# (power-saver / balanced / performance) via `powerprofilesctl` + the
# waybar power module (deferred). Safe on desktops too — without a
# battery the daemon still exposes the profiles, they just have no
# performance effect.
#
# Per Q26: omarchy auto-switches profile on AC plug/unplug via udev
# rules gated on battery presence. paco defers that to a future iter
# — for v0.1.0 the manual picker is enough.
if systemctl is-enabled power-profiles-daemon.service > /dev/null 2>&1; then
  echo "power-profiles-daemon.service already enabled."
else
  sudo systemctl enable power-profiles-daemon.service
  echo "Enabled power-profiles-daemon.service."
fi

if systemctl is-active power-profiles-daemon.service > /dev/null 2>&1; then
  echo "power-profiles-daemon.service already active."
else
  sudo systemctl start power-profiles-daemon.service
  echo "Started power-profiles-daemon.service."
fi

# Arch ships /usr/bin/powerprofilesctl with `#!/usr/bin/env python3`.
# paco activates mise in the shell (Q21), so `env python3` resolves to
# mise's Python, which doesn't see the system `gi` bindings installed
# by python-gobject — and the CLI throws ModuleNotFoundError on `gi`.
# Force the shebang to the absolute system Python.
ppctl_bin="/usr/bin/powerprofilesctl"
if [[ -f "${ppctl_bin}" ]]; then
  if head -1 "${ppctl_bin}" | grep -q '^#!/usr/bin/python3$'; then
    echo "${ppctl_bin} shebang already pinned to system python3."
  else
    sudo sed -i '1c\#!/usr/bin/python3' "${ppctl_bin}"
    echo "Pinned ${ppctl_bin} shebang to /usr/bin/python3 (mise interop)."
  fi
fi
