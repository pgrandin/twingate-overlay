# twingate-overlay
Gentoo overlay for twingate setup. 

Twingate 2023.250.97595 | 0.149.1 requires < net-misc/networkmanager-1.42 which is now deprecated in Gentoo's repositories.

# how to use:
```
cat > /etc/portage/repos.conf/twingate.conf
[twingate]
location = /var/db/repos/twingate
sync-type = git
sync-uri = https://github.com/pgrandin/twingate-overlay.git
auto-sync = yes
```

then eix-sync
