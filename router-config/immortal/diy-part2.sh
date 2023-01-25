#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: 21.02
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# change timezone
sed -i -e "s/CST-8/WIB-7/g" -e "s/Shanghai/Jakarta/g" package/emortal/default-settings/files/99-default-settings-chinese

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# oh-my-zsh
mkdir -p files/root
pushd files/root
git clone https://github.com/robbyrussell/oh-my-zsh ./.oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ./.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ./.oh-my-zsh/custom/plugins/zsh-completions
cp $GITHUB_WORKSPACE/amlogic-s9xxx/common-files/patches/zsh/.zshrc .
cp $GITHUB_WORKSPACE/amlogic-s9xxx/common-files/patches/zsh/example.zsh ./.oh-my-zsh/custom/example.zsh
popd

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk package/luci-app-amlogic

# Add p7zip
svn co https://github.com/hubutui/p7zip-lede/trunk package/lean/p7zip

# Add luci-app-3ginfo-lite
svn co https://github.com/4IceG/luci-app-3ginfo-lite/trunk package/luci-app-3ginfo-lite

# Intel XMM 7650 LTE-A Pro modem.
# svn co https://github.com/koshev-msk/xmm-modem/trunk package/xmm-modem

# A Qos luci app filter device by MAC address
# svn co https://github.com/WROIATE/luci-app-mqos/trunk package/luci-app-mqos

# luci-app-modeminfo
# svn co https://github.com/koshev-msk/luci-app-modeminfo/trunk package/luci-app-modeminfo

# luci-app-smstools3 
# svn co https://github.com/koshev-msk/luci-app-smstools3/trunk package/luci-app-smstools3

# luci-app-mqos
# svn co https://github.com/WROIATE/luci-app-mqos/trunk package/luci-app-mqos

# Add luci-app-passwall
# svn co https://github.com/xiaorouji/openwrt-passwall/trunk package/openwrt-passwall
# rm -rf package/openwrt-passwall/{kcptun,xray-core} 2>/dev/null

# Add luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/openwrt-openclash
pushd package/openwrt-openclash/tools/po2lmo && make && sudo make install 2>/dev/null && popd

# Add luci-app-amlogic
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
# svn co https://github.com/ophub/luci-app-amlogic/trunk/depends/luci-lib-fs package/luci-lib-fs

# Add autocore
# svn co https://github.com/ophub/amlogic-s9xxx-openwrt/trunk/amlogic-s9xxx/common-files/patches/autocore package/lean/autocore

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
