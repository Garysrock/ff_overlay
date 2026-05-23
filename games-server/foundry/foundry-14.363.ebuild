# Copyright 2025 Garysrock <master@findingfoundry.com>
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

MY_MAJOR=$(ver_cut 1)
DESCRIPTION="The Foundry VTT Server"
HOMEPAGE="https://foundryvtt.com/"
SRC_URI="FoundryVTT-Node-${PV}.zip"
RESTRICT="fetch strip bindist"

LICENSE="Foundry_VTT_License"
SLOT="${MY_MAJOR}"
KEYWORDS="~amd64"

DEPEND=">=net-libs/nodejs-20
	acct-user/foundry
	acct-group/foundry"
RDEPEND="${DEPEND}"
BDEPEND="acct-user/foundry
	acct-group/foundry"

pkg_nofetch() {
	einfo "You must log into your account on https://foundryvtt.com"
	einfo "and go to your \"Purchased Licenses\" page under your user"
	einfo "profile. There you must select the Download Version ${PV}"
	einfo "with Operating System of \"Node.js\". Then either Download"
	einfo "and Transfer to \${DISTDIR} (usually /var/cache/distfiles"
	einfo "on this computer, or select \"Timed URL\" and execute:"
	einfo " sudo wget -O \${DISTDIR}/FoundryVTT-Node-${PV}.zip <pasted_URL>"
	einfo "If you need to determine what \${DISTDIR} is, try:"
	einfo " sudo emerge --info |grep DISTDIR"
}

src_unpack() {
	mkdir ${S}
	cd ${S}
	unzip ${DISTDIR}/${A}
	sed -e "s/\/opt\/bin\/foundry/\/opt\/bin\/foundry${MY_MAJOR}/" "${FILESDIR}"/foundry.service >foundry${MY_MAJOR}.service
}

src_install() {
	insinto /opt/Foundry/${PV}/
	cp -R ${S}/* ${D}/opt/Foundry/${PV}/
	rm ${D}/opt/Foundry/${PV}/foundry${MY_MAJOR}.service
	chown -R foundry:foundry ${D}/opt/Foundry/${PV}/
	mkdir ${D}/opt/bin
	ln -s /opt/Foundry/${PV}/main.js ${D}/opt/bin/foundry${MY_MAJOR}.js
	systemd_newunit foundry${MY_MAJOR}.service foundry${MY_MAJOR}@.service
}

pkg_postinst() {
	[[ -d /var/cache/foundry-data ]] || mkdir /var/cache/foundry-data
	if [[ ! -d /var/cache/foundry-data ]]; then
		ewarn  "Unable to create Foundry's data directory"
		eerror "Please verify that /var/cache/foundry-data is available for use."
	fi
	chown foundry:foundry /var/cache/foundry-data
}

