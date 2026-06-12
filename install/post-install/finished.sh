#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "paco install complete"
echo
echo "Installed:"
echo "  /usr/bin/paco               — dispatcher"
echo "  /usr/share/paco/bin/paco-*  — subcommands"
echo "  /usr/share/paco/version     — version file"
echo
echo "Try:"
echo "  paco --help"
echo "  paco --version"
echo
echo "Install log: ${PACO_INSTALL_LOG_FILE}"
