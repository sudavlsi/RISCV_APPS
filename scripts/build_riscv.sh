#!/bin/bash

MARCH="rv32i"
MABI="ilp32"

while [ $# -gt 0 ]; do
  case $1 in
    -c)
		C_FILE="$2"
      shift
      ;;
	 -cpp)
		CPP_FILE="$2"
		shift
		;;
	 -s)
		ASM_FILE="$2"
      shift
      ;;
   -march)
		MARCH="$2"	
      ;;
	-mabi)
		MABI="$2"
		shift
		;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# Configuration
SOURCE_DIR_C="./../Riscv/verif/riscv_apps/c"          # Directory where source files are located
SOURCE_DIR_ASM="./../Riscv/verif/riscv_apps/asm"          # Directory where source files are located
BUILD_DIR="$SCRIPTS_DIR/riscv_build"         # Directory for build artifacts
#EXECUTABLE="program"        # Name of the final executable

# Ensure the directories exist
mkdir -p "$SOURCE_DIR_C" "$SOURCE_DIR_ASM" "$BUILD_DIR"

# Compile C source files
compile_c() {
    echo "Compiling C source files..."
	 src_c_file="$C_FILE"
    #for src_c_file in "$SOURCE_DIR_C"/*.c; do
        #[ -e "$src_c_file" ] || continue
        obj_file="$BUILD_DIR/$(basename "${src_c_file%.c}.o")"
		  asm_file="$BUILD_DIR/$(basename "${src_c_file%.c}.s")"
		  exe_file="$BUILD_DIR/$(basename "${src_c_file%.c}")"
		  elf_file="$BUILD_DIR/$(basename "${src_c_file%.c}".elf)"
		  hex_file="$BUILD_DIR/$(basename "${src_c_file%.c}".hex)"
		  bin_file="$BUILD_DIR/$(basename "${src_c_file%.c}".bin)"
		  dis_file="$BUILD_DIR/$(basename "${src_c_file%.c}".txt)"
		  obj_dis_file="$BUILD_DIR/$(basename "${src_c_file%.c}".obj_dis)"
		  elf_dis_file="$BUILD_DIR/$(basename "${src_c_file%.c}".elf_dis)"
		  text_bin_file="$BUILD_DIR/$(basename "${src_c_file%.c}".txt_bin)"
		  riscv64-unknown-elf-gcc -DRISCV -nostdlib -ffreestanding -march=$MARCH -mabi=$MABI -S  "$src_c_file" -o  "$asm_file" -O0 || exit 1 
		  riscv64-unknown-elf-as  -DRISCV -march=$MARCH -mabi=$MABI  -o "$obj_file"  "$asm_file" || exit 1  
		  riscv64-unknown-elf-gcc -DRISCV -nostdlib -ffreestanding -T $SCRIPTS_DIR/Riscv_linker_script.ld -march=$MARCH -mabi=$MABI -o $elf_file $obj_file || exit 1 
		  riscv64-unknown-elf-objdump -D $obj_file >     "$obj_dis_file"
		  riscv64-unknown-elf-objdump -D $elf_file | tee "$elf_dis_file"
		  riscv64-unknown-elf-objdump -D -j .text  $elf_file  |  grep -v "file format\|\.\.\.\|Disassembly\|>\:\|^$" |  awk '{print $1 $2}' > $hex_file
		  riscv64-unknown-elf-objdump -D -j .data  $elf_file  |  grep -v "file format\|\.\.\.\|Disassembly\|>\:\|^$" |  awk '{print $1 $2}' >> $hex_file
		  cp $hex_file $BUILD_DIR/vivado_pgm.hex
    #done
}

# Compile C source files
compile_asm() {
    echo "Compiling ASM source files..."
	 src_asm_file="$ASM_FILE"
    #for src_asm_file in "$SOURCE_DIR_ASM"/*.s; do
    #    [ -e "$src_asm_file" ] || continue
        obj_file="$BUILD_DIR/$(basename "${src_asm_file%.s}.o")"
		  asm_file="$BUILD_DIR/$(basename "${src_asm_file%.s}.s")"
		  exe_file="$BUILD_DIR/$(basename "${src_asm_file%.s}")"
		  elf_file="$BUILD_DIR/$(basename "${src_asm_file%.s}".elf)"
		  hex_file="$BUILD_DIR/$(basename "${src_asm_file%.s}".hex)"
		  bin_file="$BUILD_DIR/$(basename "${src_asm_file%.s}".bin)"
		  dis_file="$BUILD_DIR/$(basename "${src_asm_file%.s}".txt)"
		  obj_dis_file="$BUILD_DIR/$(basename "${src_asm_file%.s}".obj_dis)"
		  elf_dis_file="$BUILD_DIR/$(basename "${src_asm_file%.s}".elf_dis)"
		  text_bin_file="$BUILD_DIR/$(basename "${src_asm_file%.s}".txt_bin)"
		  riscv64-unknown-elf-as   -march=$MARCH -mabi=$MABI  -o "$obj_file"  "$src_asm_file"  || exit 1  
		  riscv64-unknown-elf-gcc  -nostdlib -ffreestanding -T $SCRIPTS_DIR/Riscv_linker_script.ld -march=$MARCH -mabi=$MABI -o $elf_file $obj_file || exit 1 
		  riscv64-unknown-elf-objdump -D $obj_file >     "$obj_dis_file"
		  riscv64-unknown-elf-objdump -D $elf_file | tee "$elf_dis_file"
		  riscv64-unknown-elf-objdump -D -j .text  $elf_file  |  grep -v "file format\|\.\.\.\|Disassembly\|>\:\|^$" |  awk '{print $1 $2}' > $hex_file
		  riscv64-unknown-elf-objdump -D -j .data  $elf_file  |  grep -v "file format\|\.\.\.\|Disassembly\|>\:\|^$" |  awk '{print $1 $2}' >> $hex_file
	 	  cp $hex_file $BUILD_DIR/vivado_pgm.hex 
    #done
}

# Compile CPP source files
compile_cpp() {
    echo "Compiling CPP source files..."
	 src_c_file="$CPP_FILE"
    #for src_c_file in "$SOURCE_DIR_C"/*.cpp; do
        #[ -e "$src_c_file" ] || continue
        obj_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}.o")"
		  asm_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}.s")"
		  exe_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}")"
		  elf_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}".elf)"
		  hex_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}".hex)"
		  bin_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}".bin)"
		  dis_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}".txt)"
		  obj_dis_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}".obj_dis)"
		  elf_dis_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}".elf_dis)"
		  text_bin_file="$BUILD_DIR/$(basename "${src_c_file%.cpp}".txt_bin)"
		  riscv64-unknown-elf-g++  -DRISCV -nostdlib -ffreestanding -march=$MARCH -mabi=$MABI -S  "$src_c_file" -o  "$asm_file" -O0 || exit 1 
		  riscv64-unknown-elf-as   -DRISCV -march=$MARCH -mabi=$MABI  -o "$obj_file"  "$asm_file" || exit 1  
		  riscv64-unknown-elf-g++  -DRISCV -nostdlib -ffreestanding -T $SCRIPTS_DIR/Riscv_linker_script.ld -march=$MARCH -mabi=$MABI -o $elf_file $obj_file || exit 1 
		  riscv64-unknown-elf-objdump -D $obj_file >     "$obj_dis_file"
		  riscv64-unknown-elf-objdump -D $elf_file | tee "$elf_dis_file"
		  riscv64-unknown-elf-objdump -D -j .text  $elf_file  |  grep -v "file format\|\.\.\.\|Disassembly\|>\:\|^$" |  awk '{print $1 $2}' > $hex_file
		  riscv64-unknown-elf-objdump -D -j .data  $elf_file  |  grep -v "file format\|\.\.\.\|Disassembly\|>\:\|^$" |  awk '{print $1 $2}' >> $hex_file
		  cp $hex_file $BUILD_DIR/vivado_pgm.hex
    #done
}

# Run the build process
main() {
	if [ "$C_FILE" == "" ] && [ "$ASM_FILE" == "" ] && [ "$CPP_FILE" == "" ]
	then
		echo "PASS C CPP OR ASM FILE"
		exit
	fi

	if [[ "$C_FILE" != "" ]] 
	then
		if [[ ! -f "$C_FILE" ]]
		then
			echo "INVALID C FILE PATH"
			exit
		fi
		compile_c
	fi

	if [[ "$ASM_FILE" != "" ]] 
	then
		if [[ ! -f "$ASM_FILE" ]]
		then
			echo "INVALID ASM FILE PATH"
			exit
		fi
		compile_asm
	fi

	if [[ "$CPP_FILE" != "" ]] 
	then
		if [[ ! -f "$CPP_FILE" ]]
		then
			echo "INVALID CPP FILE PATH"
			exit
		fi
		compile_cpp
	fi

    echo "Build complete."
}

main

