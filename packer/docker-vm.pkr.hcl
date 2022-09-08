#override using -var-file=<varsfile>
variable "project_id" {
	 type = string
}

variable "ssh_username" {
	 type = string
}

variable "gcp_zone" {
	 type = string
	 default = "us-central1-a"
}

variable "ubuntu_baseline_image" {
	 type = string
	 #potentially overwrite with a late release of 20.04
	 default = "ubuntu-2004-focal-v20220905"
}

source "googlecompute" "dockervm" {
  project_id              = "${var.project_id}"
  image_description  = "Docker VM baseline"
  image_name         = "dockervm"
  source_image            = "${var.ubuntu_baseline_image}"
  source_image_project_id = ["ubuntu-os-cloud"]
  pause_before_connecting = "15s"
  ssh_username            = "${var.ssh_username}"
  ssh_timeout             = "5m"
  
  #config of the builder VM
  use_internal_ip         = "true"
  omit_external_ip        = "true"
  use_os_login            = "true"
  metadata = {
    enable-oslogin = "TRUE"
  }
  enable_secure_boot = "true"
  enable_vtpm        = "true"
  zone               = "${var.gcp_zone}"
}


build {
  sources = ["source.googlecompute.dockervm"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    inline = ["sudo apt update; sudo apt upgrade -y; sudo apt autoremove -y; sync; sleep 5"]
  }

  provisioner "shell" {
    inline      = ["sudo apt install -y ansible"]
    max_retries = "3"
  }

  provisioner "ansible-local" {
    playbook_dir  = "../ansible"
    playbook_file = "../ansible/base-os.yaml"
  }

  provisioner "ansible-local" {
    playbook_dir  = "../ansible"
    playbook_file = "../ansible/docker.yaml"
  }

  provisioner "ansible-local" {
    playbook_dir  = "../ansible"
    playbook_file = "../ansible/gcs-fuse_install.yaml"
  }

  provisioner "ansible-local" {
    playbook_dir  = "../ansible"
    playbook_file = "../ansible/mount-gcs-buckets.yaml"
  }

}
