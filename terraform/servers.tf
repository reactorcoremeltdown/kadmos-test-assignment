resource "hcloud_server" "loadbalancer" {
  name        = "loadbalancer"
  image       = "debian-12"
  server_type = "cx11"
  ssh_keys = [ hcloud_ssh_key.kadmos.name ]
  firewall_ids = [ hcloud_firewall.kadmos.id ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "local_file" "ansible_inventory" {
  filename = "inventory.txt"
  content = join("\n", ["[loadbalancers]", hcloud_server.loadbalancer.ipv4_address])
}
