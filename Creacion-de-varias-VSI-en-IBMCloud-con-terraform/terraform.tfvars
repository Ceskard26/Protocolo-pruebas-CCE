# Configuración para despliegue en Dallas
region         = "us-south"
zone_number    = "1"
ssh_keyname    = "ssh-dallas"
vpc_name       = "cce-dallas"
subnet_name    = "subnet-dallas"
vsi_count      = 100
resource_group = "cce-ibm"
environment    = "development"

# Opcional: cambiar perfil si necesitas más/menos recursos
# vsi_profile = "cx2-4x8"

# Opcional: usar imagen específica
# image_name = "ibm-centos-stream-9-amd64-11"