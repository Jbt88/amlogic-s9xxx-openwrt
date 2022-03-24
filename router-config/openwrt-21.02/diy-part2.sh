#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: 21.02
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile

# change ssid
sed -i "s/OpenWrt/FynN/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i "s/iw /ipconfig /g" package/kernel/mac80211/files/lib/netifd/wireless/mac80211.sh

# change hostname
sed -i "s/OpenWrt/FynN/g" package/base-files/files/bin/config_generate

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='openwrt'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#

# Add p7zip
svn co https://github.com/hubutui/p7zip-lede/trunk package/lean/p7zip

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/depends/luci-lib-fs package/luci-lib-fs

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk package/luci-app-amlogic

# Add luci-app-3ginfo-lite
svn co https://github.com/4IceG/luci-app-3ginfo-lite/trunk package/luci-app-3ginfo-lite

# Intel XMM 7650 LTE-A Pro modem.
# svn co https://github.com/koshev-msk/xmm-modem/trunk package/xmm-modem

# A Qos luci app filter device by MAC address
svn co https://github.com/WROIATE/luci-app-mqos/trunk package/luci-app-mqos

# luci-app-modeminfo
svn co https://github.com/koshev-msk/luci-app-modeminfo/trunk package/luci-app-modeminfo

# luci-app-smstools3 
svn co https://github.com/koshev-msk/luci-app-smstools3/trunk package/luci-app-smstools3

# luci-app-mqos
svn co https://github.com/WROIATE/luci-app-mqos/trunk package/luci-app-mqos

# Add luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk package/openwrt-passwall
rm -rf package/openwrt-passwall/{kcptun,xray-core} 2>/dev/null

# Add luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/openwrt-openclash
pushd package/openwrt-openclash/tools/po2lmo && make && sudo make install 2>/dev/null && popd

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------
