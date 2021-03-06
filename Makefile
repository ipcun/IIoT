include $(TOPDIR)/rules.mk

PKG_NAME:=ipcun-gateway
PKG_VERSION:=4.21
PKG_RELEASE:=9613
#PKG_EDITION:=rtm
PKG_EDITION:=beta
PKG_DATE:=2018.04.24

PKG_BUILD_DIR:=$(BUILD_DIR)/v$(PKG_VERSION)-$(PKG_RELEASE)
PKG_SOURCE:=softether-src-v4.21-9613-beta.tar.gz
PKG_SOURCE_URL:=https://sources.lede-project.org/
#PKG_MD5SUM:=928d882d5fc23e00f0a5fa4ebf292ab9

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/ipcun-gateway
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=VPN
	TITLE:=Open-Source Free Cross-platform Multi-protocol VPN
	URL:=http://vpn.ipcun.com/
	DEPENDS:=+libpthread +librt +libreadline +libopenssl +libncurses +zlib +kmod-tun
endef

define Package/ipcun-gateway/conffiles
	/usr/bin/vpn_bridge.config
endef

ifeq ($(ARCH),mips)
	SE4WRT_OPTIONS := -minterlink-mips16
endif
ifeq ($(ARCH),mipsel)
	SE4WRT_OPTIONS := -minterlink-mips16
endif

define Build/Configure
endef

define Build/Compile
	make \
		-C $(PKG_BUILD_DIR) \
		-f src/makefiles/linux_32bit.mak \
		clean

	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/authors.txt
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/backup_dir_readme.txt
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/DriverPackages/
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/empty.config
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/empty_sevpnclient.config
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/eula.txt
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/install_src.dat
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/lang.config
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/languages.txt
 	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/legal.txt
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/openvpn_readme.pdf
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/openvpn_readme.txt
#	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/openvpn_sample.ovpn
#	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/root_certs.dat
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/SOURCES_OF_BINARY_FILES.TXT
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/strtable_cn.stb
#	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/strtable_en.stb
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/strtable_ja.stb
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/vpn16.exe
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/vpninstall_cn.inf
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/vpninstall_en.inf
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/vpninstall_ja.inf
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/vpnweb_sample_cn.htm
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/vpnweb_sample_en.htm
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/vpnweb_sample_ja.htm
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/warning_cn.txt
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/warning_en.txt
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/warning_ja.txt
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/webui/
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/winpcap_installer.exe
	rm -fr $(PKG_BUILD_DIR)/src/bin/hamcore/winpcap_installer_win9x.exe
	make \
		-C $(PKG_BUILD_DIR) \
		-f src/makefiles/linux_32bit.mak \
		src/bin/BuiltHamcoreFiles/unix/hamcore.se2
	mv $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2 $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2.1

	make \
		-C $(PKG_BUILD_DIR) \
		-f src/makefiles/linux_32bit.mak \
		clean
	mv $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2.1 $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2
	#touch -d "`date -d 1day`" $(PKG_BUILD_DIR)/tmp/hamcorebuilder
	touch -d "`date -d 1day`" $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2

	$(MAKE) \
		$(TARGET_CONFIGURE_OPTS) \
		CCFLAGS="-I$(STAGING_DIR)/usr/include $(ICONV_CFLAGS) $(SE4WRT_OPTIONS)" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib $(ICONV_LDFLAGS) -liconv" \
		-C $(PKG_BUILD_DIR) \
		-f src/makefiles/linux_32bit.mak
endef

define Package/ipcun-gateway/install
 $(INSTALL_DIR) $(1)/usr/bin
 $(INSTALL_DIR) $(1)/etc/init.d
 $(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/vpnbridge/* $(1)/usr/bin
 $(INSTALL_BIN) $(PKG_BUILD_DIR)/rc/vpnbridge $(1)/etc/init.d/softethervpnbridge
endef
$(eval $(call BuildPackage,softethervpnbridge))
