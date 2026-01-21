#!/bin/bash

export NB="http://192.168.255.130:8000"
export TOKEN="0123456789abcdef0123456789abcdef01234567"

set -euo pipefail
NB="${NB:?set NB}"
TOKEN="${TOKEN:?set TOKEN}"

outdir="netbox_export_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$outdir"

fetch () {
  local path="$1"
  local file="$2"
  echo "GET $path -> $file"
  curl -sS -H "Authorization: Token $TOKEN" "$NB$path" | jq '.' > "$outdir/$file"
}

# DCIM
fetch "/api/dcim/sites/?limit=0" "dcim_sites.json"
fetch "/api/dcim/regions/?limit=0" "dcim_regions.json"
fetch "/api/dcim/racks/?limit=0" "dcim_racks.json"
fetch "/api/dcim/manufacturers/?limit=0" "dcim_manufacturers.json"
fetch "/api/dcim/device-types/?limit=0" "dcim_device_types.json"
fetch "/api/dcim/device-roles/?limit=0" "dcim_device_roles.json"
fetch "/api/dcim/platforms/?limit=0" "dcim_platforms.json"
fetch "/api/dcim/devices/?limit=0" "dcim_devices.json"
fetch "/api/dcim/interfaces/?limit=0" "dcim_interfaces.json"
fetch "/api/dcim/cables/?limit=0" "dcim_cables.json"

# IPAM
fetch "/api/ipam/vrfs/?limit=0" "ipam_vrfs.json"
fetch "/api/ipam/vlans/?limit=0" "ipam_vlans.json"
fetch "/api/ipam/prefixes/?limit=0" "ipam_prefixes.json"
fetch "/api/ipam/ip-addresses/?limit=0" "ipam_ip_addresses.json"

# Tenancy / Users (必要に応じて)
fetch "/api/tenancy/tenants/?limit=0" "tenancy_tenants.json"

echo "DONE: $outdir"
