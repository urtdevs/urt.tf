# urt.tf

Terraform files for an Urban Terror server.

## Usage

* Set the `DIGITALOCEAN_TOKEN` environment variable to your digitalocean API key.

* run `terraform apply`

* connect to server via outputted ip address

Note that you won't have access to the server console. However, you do have
access to rcon, so use an rcon client to control your server. Be sure to change
the rcon password in `server.cfg` before running `terraform apply`.

## Configuration

When the server is created, the `server.cfg` file in this directory is put into
place. You can edit the file before running `terraform apply` to fit your needs.

At the very least, you should change the `rconpassword`.
