#!/bin/bash

# Extract all target names from Package.swift, excluding test targets
# This script parses the Package.swift file and outputs target names
# that should be included in documentation generation

set -euo pipefail

PACKAGE_FILE="${1:-Package.swift}"

if [[ ! -f "${PACKAGE_FILE}" ]]; then
    echo "Error: Package.swift not found at ${PACKAGE_FILE}" >&2
    exit 1
fi

# Extract target names from .target() declarations (excluding .testTarget())
# Using grep and sed for better compatibility with macOS
targets=$(grep -A 2 "\.target(" "${PACKAGE_FILE}" | \
    grep "name:" | \
    sed -E 's/.*name:[[:space:]]*"([^"]+)".*/\1/')

if [[ -z "${targets}" ]]; then
    echo "Error: No targets found in ${PACKAGE_FILE}" >&2
    exit 1
fi

# Output each target on a separate line
echo "${targets}"
