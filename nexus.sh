#!/bin/bash

# Print information and ask for confirmation
echo -e "\033[0;36m════════════════════════════════════════════════════════════"
echo -e "║       Welcome to Nexus BOT!                                  ║"
echo -e "║                                                              ║"
echo -e "║     Follow us on Twitter:                                   ║"
echo -e "║     https://twitter.com/cipher_airdrop                      ║"
echo -e "║                                                              ║"
echo -e "║     Join us on Telegram:                                    ║"
echo -e "║     - https://t.me/+tFmYJSANTD81MzE1                       ║"
echo -e "╚════════════════════════════════════════════════════════════\033[0m"

read -p "Do you want to continue with Nexus Installation? (Y/N): " answer
if [[ "$answer" != [Yy] ]]; then
    echo "Aborting installation."
    exit 1
fi

sleep 2

function print_message() {
    echo "===================================================================="
    echo "$1"
    echo "===================================================================="
}

print_message "Updating package list and installing CMake"
sudo apt update
sudo apt install -y cmake

print_message "Installing build-essential"
sudo apt install -y build-essential

print_message "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

print_message "Adding RISC-V target for Rust"
rustup target add riscv32i-unknown-none-elf

print_message "Installing Nexus zkVM"
cargo install --git https://github.com/nexus-xyz/nexus-zkvm nexus-tools --tag 'v1.0.0'

print_message "Creating a new Nexus project"
cargo nexus new nexus-project

print_message "Editing the main.rs file"
cd nexus-project/src

cat > main.rs <<EOL
#![no_std]
#![no_main]

fn fib(n: u32) -> u32 {
    match n {
        0 => 0,
        1 => 1,
        _ => fib(n - 1) + fib(n - 2),
    }
}

#[nexus_rt::main]
fn main() {
    let n = 7;
    let result = fib(n);
    assert_eq!(result, 13);
}
EOL

print_message "Running your program"
cd ..
cargo nexus run

print_message "Running your program with verbose output"
cargo nexus run -v

print_message "Generating a proof for your program"
cargo nexus prove

print_message "Verifying the proof"
cargo nexus verify

print_message "Nexus zkVM setup and execution completed!"
print_message "Code By: Cipher_Airdrop"
