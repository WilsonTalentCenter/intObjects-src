#!/bin/bash

# Check if a passkey was provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <passkey>"
  exit -1
fi

# Define the passkey for decryption
PASSKEY="$1"

# Decrypt all files in the "test" subdirectory
if [ -d "Test" ]; then
  for enc_file in Test/*.enc; do
    if [ -e "$enc_file" ]; then
      decrypted_file="${enc_file%.enc}"
      openssl enc -d -aes-256-cbc -in "$enc_file" -out "$decrypted_file" -pass pass:"$PASSKEY" 2>/dev/null
      if [ $? -ne 0 ]; then
        exit -1
      fi
    fi
  done
else
  echo "'test' directory does not exist."
fi


# Find all .class files and remove them
find . -name "*.class" -type f -exec rm -f {} \;

# Find all Java files in the current directory and subdirectories
# -name "*.java" specifies the pattern to match Java files
# -print0 and -0 work together to handle file names with spaces

find . -name "*.java" -print0 | while IFS= read -r -d '' file; do
  echo "Compiling $file"
  javac "$file"
done

# Check the exit status of the javac command
if [ $? -eq 0 ]; then
  echo "Compilation successful."
else
  echo "Compilation failed."
  exit -1
fi
