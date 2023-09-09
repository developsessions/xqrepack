TARGETS_AX3600_SSH:=$(shell cd orig-firmwares/AX3600; ls *.bin | sed 's/\.bin$$/_AX3600_SSH.bin/')
TARGETS_AX6000_SSH:=$(shell cd orig-firmwares/AX6000; ls *.bin | sed 's/\.bin$$/_AX6000_SSH.bin/')
TARGETS_AX3600:=$(shell echo $(TARGETS_AX3600_SSH) | sed 's/ /\n/g' | sort)
TARGETS_AX6000:=$(shell echo $(TARGETS_AX6000_SSH) | sed 's/ /\n/g' | sort)

AX3600: $(TARGETS_AX3600)
AX6000: $(TARGETS_AX6000)
all: $(TARGETS_AX3600) $(TARGETS_AX6000)

clean:
	rm *.bin

%_AX3600_SSH.bin: orig-firmwares/AX3600/%.bin repack-squashfs.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	ubireader_extract_images -w orig-firmwares/AX3600/$*.bin
	fakeroot -- ./repack-squashfs.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs AX3600
	./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
	mv r3600-raw-img.bin $@

%_AX6000_SSH.bin: orig-firmwares/AX6000/%.bin repack-squashfs.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	ubireader_extract_images -w orig-firmwares/AX6000/$*.bin
	fakeroot -- ./repack-squashfs.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs AX6000
	./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
	mv r3600-raw-img.bin $@
