#!/bin/bash

while [ $# -gt 0 ]; do
  case $1 in
    -c|-cpp)
		SOURCE_FILE="$2"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# Set default output name for the compiled program

# Source file (first argument)
if [[ "$(basename "$SOURCE_FILE")" == *.c ]]  
then
	echo "C FILE DETECTED"
elif [[ "$(basename "$SOURCE_FILE")" == *.cpp ]]
then
	echo "CPP FILE DETECTED"
else
	echo "PASS A C OR CPP FILE"
	exit 1
fi

# If an optional second argument is provided, set it as the output file name
OUTPUT_NAME="$(basename "${SOURCE_FILE%.c}".o)"



# Compile the C program
echo "Compiling $SOURCE_FILE..."
g++ "$SOURCE_FILE" -o "$OUTPUT_NAME"

# Check if the compile was successful
if [ $? -eq 0 ]; then
  echo "Compilation successful!"
  echo "Running $OUTPUT_NAME..."
  # Run the compiled program
  ./$OUTPUT_NAME
else
  echo "Compilation failed!"
  exit 1
fi

