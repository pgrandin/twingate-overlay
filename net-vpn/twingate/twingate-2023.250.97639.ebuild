EAPI=8
 
DESCRIPTION="twingate a high performance, easy to use zero trust solution that enables access to private resources from any device with better security than a VPN."
HOMEPAGE="https://docs.twingate.com/docs/linux"
SRC_URI="https://binaries.twingate.com/client/linux/ARCH/x86_64/stable/twingate-amd64.pkg.tar.zst"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
 
DEPEND="sys-fs/cryptsetup
        sys-apps/dbus
        dev-libs/libnl
        <net-misc/networkmanager-1.42"
RDEPEND="${DEPEND}"

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
}
