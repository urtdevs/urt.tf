variable "location" {
    default = "nyc1"
}

variable "size" {
    default = "512mb"
}

variable "sshkeyfp" {
    default = "6d:ca:a0:de:47:b1:45:62:87:aa:b1:3c:0f:a0:bc:91"
}

variable "install_mumble" {
    default = "true"
}

variable "mumble_superuser_password" {
    default = "R5onueepeij3Oaejae9ES"
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
        inline = [
            "mkdir -p /opt/urt/"
        ]
    }

    provisioner "file" {
        source = "server.cfg"
        destination = "/opt/urt/server.cfg"
    }

    provisioner "remote-exec" {
        script = "urt_install"
    }

    provisioner "file" {
        source = "mumble_install"
        destination = "/opt/mumble_install"
    }

    provisioner "file" {
        source = "mumble-server.ini"
        destination = "/opt/mumble-server.ini"
    }

    provisioner "remote-exec" {
        inline = [
            "if [ '${var.install_mumble}' == 'true' ]; then /opt/mumble_install ; fi",
            "sudo -i murmurd -ini /etc/mumble-server.ini -supw ${var.mumble_superuser_password} || true",
            "update-rc.d -f mumble-server defaults || true",
            "if [ '${var.install_mumble}' == 'true' ]; then cp /opt/mumble-server.ini /etc/mumble-server.ini ; fi",
            "rm -rf /opt/{mumble_install,mumble-server.ini}",
            "service mumble-server restart || true"
        ]
    }
}

output "ip_addr" {
    value = "${digitalocean_droplet.urt.ipv4_address}"
}
