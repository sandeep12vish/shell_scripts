
#!/bin/bash

# ==========================================================
# Script Name : vm_install_config.sh
# Install KVM and create/configure a VM

# ==========================================================

set -euo pipefail

# ---------- VM CONFIGURATION ----------

VM_NAME="ubuntu-devops"
RAM_MB=4096
VCPU=2
DISK_SIZE=30
ISO_PATH="/var/lib/libvirt/images/ubuntu.iso"
DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"

# ---------- LOGGING ----------

log() {
    echo "[$(date '+%F %T')] $1"
}

# ---------- CHECK ROOT ----------

if [[ $EUID -ne 0 ]]; then
    echo "Please execute this script using sudo."
    exit 1
fi

# ---------- CHECK VIRTUALIZATION ----------

log "Checking CPU virtualization support..."

if ! grep -Eq '(vmx|svm)' /proc/cpuinfo; then
    echo "ERROR: CPU virtualization is not enabled."
    echo "Enable Intel VT-x or AMD-V in BIOS/UEFI."
    exit 1
fi

# ---------- INSTALL PACKAGES ----------

log "Updating package repositories..."

apt-get update

log "Installing KVM and virtualization packages..."

apt-get install -y \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    virtinst \
    bridge-utils \
    cpu-checker

# ---------- ENABLE SERVICES ----------

log "Enabling libvirt services..."

systemctl enable --now libvirtd

# ---------- CHECK NETWORK ----------

log "Starting default libvirt network..."

if ! virsh net-info default >/dev/null 2>&1; then
    virsh net-define /usr/share/libvirt/networks/default.xml
fi

virsh net-start default || true
virsh net-autostart default

# ---------- CREATE VM STORAGE ----------

log "Creating VM storage directory..."

mkdir -p /var/lib/libvirt/images

# ---------- CHECK ISO ----------

if [[ ! -f "$ISO_PATH" ]]; then
    echo "ERROR: Ubuntu ISO not found:"
    echo "$ISO_PATH"
    echo "Download Ubuntu ISO and copy it to this location."
    exit 1
fi

# ---------- CREATE VM DISK ----------

if [[ ! -f "$DISK_PATH" ]]; then
    log "Creating virtual disk..."

    qemu-img create -f qcow2 "$DISK_PATH" "${DISK_SIZE}G"
else
    log "Virtual disk already exists. Skipping."
fi

# ---------- CREATE VIRTUAL MACHINE ----------

if virsh dominfo "$VM_NAME" >/dev/null 2>&1; then
    log "VM already exists. Skipping creation."
else
    log "Creating virtual machine..."

    virt-install \
        --name "$VM_NAME" \
        --memory "$RAM_MB" \
        --vcpus "$VCPU" \
        --disk path="$DISK_PATH",format=qcow2,bus=virtio \
        --cdrom "$ISO_PATH" \
        --network network=default,model=virtio \
        --graphics spice \
        --os-variant ubuntu24.04 \
        --boot cdrom,hd \
        --noautoconsole
fi

# ---------- VM STATUS ----------

log "VM installation/configuration completed."

virsh list --all

echo
echo "VM Name     : $VM_NAME"
echo "RAM         : ${RAM_MB} MB"
echo "CPU         : $VCPU"
echo "Disk        : ${DISK_SIZE} GB"
echo "Disk Path   : $DISK_PATH"
echo
echo "Connect using:"
echo "  virt-manager"
echo "  virsh console $VM_NAME"
