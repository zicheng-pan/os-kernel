BUILD:=./build
HD_IMG_NAME:= "a.img"

all: ${BUILD}/boot/boot.o
	$(shell rm -rf $(BUILD)/$(HD_IMG_NAME))
	# 这里创建的是软盘 fd可以在控制台输入bxiamge一步一步创建
	bximage -q -fd=1.44M -func=create -imgmode=flat $(BUILD)/$(HD_IMG_NAME)
	dd if=${BUILD}/boot/boot.o of=$(BUILD)/$(HD_IMG_NAME) bs=512 seek=0 count=1 conv=notrunc

${BUILD}/boot/%.o: oskernel/boot/%.asm
	$(shell mkdir -p ${BUILD}/boot)
	nasm $< -o $@

clean:
	$(shell rm -rf ${BUILD})

bochs: all
	bochs -q -f bochsrc

qemu: all
	qemu-system-x86_64 \
	-m 32M \
	-hda ./build/hd.img
