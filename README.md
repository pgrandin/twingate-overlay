# twingate-overlay

Gentoo overlay for the Twingate client.

`net-vpn/twingate` packages the official Twingate Linux client and bundles a
polkit rule (`net-vpn/twingate/files/`) that grants the `plugdev` group the
`org.freedesktop.NetworkManager.settings.modify.system` action. The client uses
NetworkManager for split-DNS; on systems without systemd-resolved that action
must be authorized or DNS configuration fails. The rule is installed to
`/etc/polkit-1/rules.d/` by the ebuild.

Current ebuild: `twingate-2026.140.6512-r1`. Older Twingate releases required
`<net-misc/networkmanager-1.42`; current releases carry no such constraint.

# how to use:
```
cat > /etc/portage/repos.conf/twingate.conf
[twingate]
location = /var/db/repos/twingate
sync-type = git
sync-uri = https://github.com/pgrandin/twingate-overlay.git
auto-sync = yes
```

Accept the proprietary license, then sync and emerge:
```
echo "net-vpn/twingate all-rights-reserved" > /etc/portage/package.license/twingate
emerge --sync twingate
emerge net-vpn/twingate
```
