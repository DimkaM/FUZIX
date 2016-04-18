image:
	truncate --size=33M mbr
	sudo parted mbr mktable msdos
	sudo parted mbr mkpart primary fat16 1MiB 17MiB
	sudo parted mbr mkpart primary 17MiB 33MiB
	truncate --size=1M mbr
	truncate --size=16M p1
	mkfs.fat p1
	sudo mount p1 ./img
	sudo cp ../fuzix.bin ./img/
	sudo cp fuzstart ./img/fuzstart.^$C
#	sudo mv ./img/fuzstart ./img/fuzstart.\$$C
	sudo umount ./img
	cat mbr p1 ../../filesystem-zxevo.img > fuzix.img
	rm p1 
	rm mbr