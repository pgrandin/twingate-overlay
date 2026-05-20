# twingate-overlay

Gentoo overlay for the Twingate client.

`net-vpn/twingate` packages the official Twingate Linux client and makes it
work on OpenRC systems, where the upstream client (which assumes systemd)
otherwise fails. The ebuild adds:

- A **polkit rule** granting the `plugdev` group the
  `org.freedesktop.NetworkManager.settings.modify.system` action. The client
  uses NetworkManager for split-DNS; without systemd-resolved that action must
  be authorized or DNS configuration fails. Installed to
  `/etc/polkit-1/rules.d/`.
- An **OpenRC service** (`/etc/init.d/twingate`) for the `twingated` daemon,
  since upstream ships only a systemd unit.
- A **`systemctl` shim**. The `twingate` CLI hard-codes `systemctl` calls for
  `setup`, `start` and `stop`; with no systemd present these fail with ENOENT
  and abort the command. The CLI is fronted by a small wrapper that, on
  non-systemd hosts only, puts a shim on `$PATH` translating those calls to
  `rc-service` / `rc-update`. On systemd hosts the real `systemctl` is used, so
  the ebuild is safe there too.

Current ebuild: `twingate-2026.140.6512-r2`. Older Twingate releases required
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

Configure once, then connect:
```
twingate setup   # network name + options
twingate start   # starts the daemon and connects (SSO)
```
