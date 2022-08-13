#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/soc/11230000.mmc/by-name/recovery:8861696:73cff793275a3734a5810890f02e19c701a2de72; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/soc/11230000.mmc/by-name/boot:7720960:08d2eeb0a8cee4f46719f315604ab2c285857e9f EMMC:/dev/block/platform/soc/11230000.mmc/by-name/recovery a140fbbf3649fe3978357882e2140c6bafc89a38 8859648 08d2eeb0a8cee4f46719f315604ab2c285857e9f:/system/recovery-from-boot.p && installed=1 && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
  [ -n "$installed" ] && dd if=/system/recovery-sig of=/dev/block/platform/soc/11230000.mmc/by-name/recovery bs=1 seek=8859648 && sync && log -t recovery "Install new recovery signature: succeeded" || log -t recovery "Installing new recovery signature: failed"
else
  log -t recovery "Recovery image already installed"
fi
