# WireGuard Server Role

This role is meant to install a WireGuard server.  
You're meant to have at least defined those config variables in your environment:

```yaml
wireguard_ui:
  http_host: "wireguard.domain.fqdn"
  user: "admin" # defaults to `admin`
  password: "{{ wireguard_ui_pw }}" # defaults to `admin`
  nameservers: "1.1.1.1" # comma separated list, defaults to `1.1.1.1`
```
