resource "hcloud_firewall" "ssh" {
  name = "ssh"
  rule {
    direction = "in"
    port = "22"
    protocol = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall" "https" {
  name = "https"
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

resource "hcloud_firewall" "http" {
  name = "http"
  rule {
    direction = "in"
    port = "80"
    protocol = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall" "kubernetes" {
  name = "kubernetes"
  rule {
    direction = "in"
    port = "6443"
    protocol = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}
