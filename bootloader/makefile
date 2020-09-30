os.img:    bootsect loader
	dd if=/dev/zero of=$@ bs=1MiB count=16
	dd if=bootsect  of=$@ bs=512  count=1
	dd if=loader    of=$@ seek=1  bs=512

disasm:    bootsect loader
	ndisasm bootsect > disasm.bootsect
	ndisasm loader   > disasm.loader

bootsect:  bootsect.asm meminfo.inc
	nasm -f bin bootsect.asm

loader:   loader.asm meminfo.inc
	nasm -f bin loader.asm

.PHONY clean:
	rm -rf os.img bootsect loader  disasm.*

disasm_clean:
	rm -rf disasm.*

qemu:    os.img
	qemu-system-x86_64 -hda os.img -nographic

