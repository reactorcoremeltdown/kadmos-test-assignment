resource "hcloud_ssh_key" "kadmos" {
  name       = "kadmos"
  public_key = file("/mnt/files/ssh/id_rsa.pub")
}
