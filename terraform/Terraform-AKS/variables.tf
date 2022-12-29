
variable "resource_group_name" {
  description = "The resource_group_name is used for Kubernetes's resource"
  default = "rg-k8s_aks-lab"
}

variable "location" {
  description = "Define the location you want to put these resources to. (example: Southeast Asia) "
  default = "eastasia"
}
# ===============================================

variable "tags" {
  default = {
    project-env = "aks-lab"
  }
}

variable "cluster_name" {
  default = "aks-aks-lab"
}

variable "dns_prefix" {
  default = "aks-lab-dns"
  description = "DNS name prefix to use with the hosted Kubernetes API server. Use this to connect to the Kubernetes API when managing containers after creating the cluster."
}

# ====== variable for K8S ======
variable "k8s_linux_profile_username" {
  default = "sysadmin"
  description = "this is username for linux os of nodes"
}

variable "k8s_node_count" {
  default = 2
}

variable "k8s_vm_size" {
  default = "Standard_B2ms"
}

variable "k8s_version" {
  default = "1.21.14"
}

variable "k8s_node_pool_type" {
  default = "VirtualMachineScaleSets"
}

variable "k8s_node_pool_enable_auto_scaling" {
  default = false
}
