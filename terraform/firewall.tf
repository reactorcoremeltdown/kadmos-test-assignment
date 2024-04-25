resource "hcloud_firewall" "kadmos" {
  name = "kadmos"
  rule {
    direction = "in"
    port = "22"
    protocol = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    port = "443"
    protocol = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}
