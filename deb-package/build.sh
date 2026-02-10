#!/bin/bash
# Build script for rotarymars-setup-ubuntu deb package
# Uses dpkg-deb to build the package

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_DIR="${SCRIPT_DIR}/rotarymars-setup-ubuntu"
OUTPUT_DIR="${SCRIPT_DIR}"

echo "=== Building rotarymars-setup-ubuntu deb package ==="

# Set correct permissions for DEBIAN scripts
chmod 755 "${PACKAGE_DIR}/DEBIAN/preinst"
chmod 755 "${PACKAGE_DIR}/DEBIAN/postinst"

# Set correct permissions for config files
find "${PACKAGE_DIR}/etc" -type f -exec chmod 644 {} \;
find "${PACKAGE_DIR}/etc" -type d -exec chmod 755 {} \;

# Build the deb package
dpkg-deb --build "${PACKAGE_DIR}" "${OUTPUT_DIR}/rotarymars-setup-ubuntu.deb"

echo "=== Build complete ==="
echo "Package: ${OUTPUT_DIR}/rotarymars-setup-ubuntu.deb"

# Show package info
echo ""
echo "=== Package info ==="
dpkg-deb --info "${OUTPUT_DIR}/rotarymars-setup-ubuntu.deb"

echo ""
echo "=== Package contents ==="
dpkg-deb --contents "${OUTPUT_DIR}/rotarymars-setup-ubuntu.deb"
