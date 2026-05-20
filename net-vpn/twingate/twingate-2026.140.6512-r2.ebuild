EAPI=8

DESCRIPTION="twingate a high performance, easy to use zero trust solution that enables access to private resources from any device with better security than a VPN."
HOMEPAGE="https://docs.twingate.com/docs/linux"
SRC_URI="https://binaries.twingate.com/client/linux/ARCH/x86_64/stable/twingate-amd64.pkg.tar.zst"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="sys-fs/cryptsetup sys-apps/dbus dev-libs/libnl"
RDEPEND="${DEPEND} sys-auth/polkit"

src_unpack()
{
	mkdir -p ${P}
	cd $_
	tar --use-compress-program=unzstd -xvf ${DISTDIR}/${A} -C ${S}
	rm -rf ${S}/run
	rm -rf ${S}/var
}

src_install()
{
	mkdir -p ${D}/usr/sbin/ || die "Install failed!"
	mv ${S}/usr/bin/twingated ${D}/usr/sbin/twingated || die "Install failed!"
	cp -R ${S}/* "${D}/" || die "Install failed!"

	# OpenRC systems lack systemd-resolved; the client uses NetworkManager
	# for split-DNS, which needs polkit authorization to modify system
	# connections. Grant it to the plugdev group.
	insinto /etc/polkit-1/rules.d
	doins "${FILESDIR}"/01-org.freedesktop.NetworkManager.settings.modify.system.rules

	# Upstream ships only a systemd unit; provide an OpenRC service too.
	newinitd "${FILESDIR}"/twingate.initd twingate

	# The twingate CLI hard-codes `systemctl` calls (setup, start, stop).
	# Install a shim that translates them to OpenRC and front the CLI with a
	# wrapper that puts the shim on PATH only when systemd is not the init
	# system, so the package stays correct on systemd hosts as well.
	exeinto /usr/libexec/twingate/shims
	doexe "${FILESDIR}"/systemctl
	mv "${D}"/usr/bin/twingate "${D}"/usr/libexec/twingate/twingate || die "Install failed!"
	newbin "${FILESDIR}"/twingate.wrapper twingate
}
