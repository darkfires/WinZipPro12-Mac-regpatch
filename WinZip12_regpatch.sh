#!/bin/bash
# WinZip Pro v12.0.7282

BIN=/Applications/WinZip.app/Contents/MacOS/WinZip

# $1 - binary $2 - offset $3 - original opcode $4 - new opcode
function PatchBinary() {
	echoop=""

	for ((i=0; i<${#4}; i+=2)); do
	        echoop="${echoop}\\x${4:i:2}"
	done

	echo "Checking if binary needs to be patched at $2..."

	CUROP=$(od -A x -t x1 -j $(($2)) -N $(($i/2)) -v $1 | head -1 | sed -e 's/^[^ ]* //' -e 's/\ //g')

	if [ "$CUROP" == "$3" ]; then
		echo "Current opcode at $2 in $1 is ${CUROP}, patching to $4..."
		echo -en "${echoop}" | dd seek=$(($2)) of=$1 bs=1 count=$(($i/2)) conv=notrunc
	else
		echo "$1 is already patched."
	fi
}

# x86_64
PatchBinary ${BIN} 0x1377D4 7435 9090
PatchBinary ${BIN} 0x1855DD ba02 BA03
PatchBinary ${BIN} 0x1E7A13 4e6f742052656769737465726564 5265676973746572656400000000
PatchBinary ${BIN} 0x1E2754 50524f 535444

# arm64
PatchBinary ${BIN} 0x5975A8 42 62
PatchBinary ${BIN} 0x559FD0 c0000036 1F2003D5
PatchBinary ${BIN} 0x62045C 4e6f742052656769737465726564 5265676973746572656400000000
PatchBinary ${BIN} 0x61B19D 50524f 535444

