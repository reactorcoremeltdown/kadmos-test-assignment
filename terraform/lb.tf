resource "hcloud_server" "loadbalancer" {
  name        = "loadbalancer"
  image       = "debian-12"
  server_type = "cx11"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
