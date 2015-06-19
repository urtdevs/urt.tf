variable "location" {
    default = "nyc1"
}

variable "size" {
    default = "512mb"
}

variable "sshkeyfp" {
    default = "6d:ca:a0:de:47:b1:45:62:87:aa:b1:3c:0f:a0:bc:91"
}

resource "digitalocean_droplet" "urt" {
    image = "ubuntu-14-04-x64"
    name = "urt1"
    region = "${var.location}"
    size = "${var.size}"
    ipv6 = false
    private_networking = false
    ssh_keys = ["${split(",", var.sshkeyfp)}"]

    connection {
        type = "ssh"
        user = "root"
        agent = true
    }

    provisioner "remote-exec" {
        script = "urt_install"
    }
}

output "ip_addr" {
    value = "${digitalocean_droplet.urt.ipv4_address}"
}
