#!/bin/bash

# Program brankas digital untuk mengenskripsi dan mendekripsi file.
# Menggunakan OpenSSL dengan enkripsi AES-256-CBC.
# Pengguna harus memasukkan kata sandi (kunci) untuk setiap operasi.

ENCRYPT_COMMAND="encrypt"
DECRYPT_COMMAND="decrypt"

show_help() {
    echo "--- Bantuan untuk Brankas Digital ---"
    echo "Perintah yang tersedia:"
    echo "  ./brankas.sh $ENCRYPT_COMMAND <nama_file>      - Mengenkripsi file."
    echo "  ./brankas.sh $DECRYPT_COMMAND <nama_file>      - Mendekripsi file."
    echo ""
    echo "Catatan: Program ini memerlukan OpenSSL yang terinstal."
    echo "Pastikan Anda mengingat kata sandi yang digunakan untuk enkripsi."
    echo "File terenkripsi akan memiliki ekstensi '.enc'."
}

encrypt_file() {
    local file_to_encrypt="$1"
    if [ ! -f "$file_to_encrypt" ]; then
        echo "Error: File '$file_to_encrypt' tidak ditemukan."
        exit 1
    fi
    echo "Masukkan kata sandi untuk mengenkripsi file '$file_to_encrypt':"
    read -s password
    echo "Memproses enkripsi..."

    # Menambahkan opsi -pbkdf2 untuk metode turunan kunci yang lebih kuat dan aman.
    openssl enc -aes-256-cbc -pbkdf2 -e -in "$file_to_encrypt" -out "${file_to_encrypt}.enc" -pass pass:"$password"

    if [ $? -eq 0 ]; then
        echo "File berhasil dienkripsi dan disimpan sebagai '${file_to_encrypt}.enc'."
        echo "File asli '$file_to_encrypt' tidak dihapus."
    else
        echo "Error: Gagal mengenkripsi file. Pastikan kata sandi sudah benar."
    fi
}

decrypt_file() {
    local file_to_decrypt="$1"
    if [ ! -f "$file_to_decrypt" ]; then
        echo "Error: File '$file_to_decrypt' tidak ditemukan."
        exit 1
    fi
    echo "Masukkan kata sandi untuk mendekripsi file '$file_to_decrypt':"
    read -s password
    echo "Memproses dekripsi..."

    # Mengambil nama file asli dari file terenkripsi (menghapus ekstensi .enc)
    local original_filename=$(echo "$file_to_decrypt" | sed 's/\.enc$//')

    # Menambahkan opsi -pbkdf2 untuk metode turunan kunci yang lebih kuat dan aman.
    openssl enc -aes-256-cbc -pbkdf2 -d -in "$file_to_decrypt" -out "$original_filename" -pass pass:"$password"

    if [ $? -eq 0 ]; then
        echo "File berhasil didekripsi dan disimpan sebagai '$original_filename'."
    else
        echo "Error: Gagal mendekripsi file. Pastikan kata sandi sudah benar."
    fi
}

# Logika utama program
if [ "$#" -lt 2 ]; then
    show_help
    exit 1
fi

COMMAND="$1"
FILE="$2"

case "$COMMAND" in
    "$ENCRYPT_COMMAND")
        encrypt_file "$FILE"
        ;;
    "$DECRYPT_COMMAND")
        decrypt_file "$FILE"
        ;;
    *)
        echo "Perintah tidak valid: $COMMAND"
        show_help
        exit 1
        ;;
esac
