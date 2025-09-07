#!/bin/bash

# Nama file tempat tugas disimpan
TUGAS_FILE="tugas.txt"

# Memastikan file tugas ada. Jika belum ada, buat file dan inisialisasi dengan status.
if [ ! -f "$TUGAS_FILE" ]; then
    touch "$TUGAS_FILE"
fi

# Fungsi untuk menambahkan tugas baru
tambah_tugas() {
    read -p "Masukkan tugas baru: " tugas_baru
    # Tambahkan status default '[ ]' di awal setiap tugas baru
    echo "[ ] $tugas_baru" >> "$TUGAS_FILE"
    echo "Tugas berhasil ditambahkan."
}

# Fungsi untuk menampilkan semua tugas dengan status
tampilkan_tugas_dengan_status() {
    if [ -s "$TUGAS_FILE" ]; then
        echo "Daftar Tugas:"
        nl -s '. ' "$TUGAS_FILE"
    else
        echo "Tidak ada tugas saat ini."
    fi
}

# Fungsi untuk mengubah status tugas (menandai selesai atau belum)
ubah_status() {
    tampilkan_tugas_dengan_status
    if [ ! -s "$TUGAS_FILE" ]; then
        return
    fi
    read -p "Masukkan nomor tugas untuk diubah statusnya: " nomor

    if [[ "$nomor" =~ ^[0-9]+$ ]] && [ "$nomor" -gt 0 ]; then
        # Ambil baris yang dipilih
        line=$(sed -n "${nomor}p" "$TUGAS_FILE")

        if [[ "$line" == "[ ]"* ]]; then
            # Jika statusnya belum selesai, ubah menjadi selesai
            sed -i "${nomor}s/\[ \] /\[x\] /" "$TUGAS_FILE"
            echo "Tugas berhasil ditandai sebagai selesai."
        elif [[ "$line" == "[x]"* ]]; then
            # Jika statusnya sudah selesai, ubah menjadi belum
            sed -i "${nomor}s/\[x\] /\[ \] /" "$TUGAS_FILE"
            echo "Tugas berhasil ditandai sebagai belum selesai."
        else
            echo "Format baris tidak valid."
        fi
    else
        echo "Nomor tidak valid."
    fi
}

# Fungsi untuk menampilkan menu utama
tampilkan_menu() {
    echo "---------------------------"
    echo "  Pengelola Tugas (TUI)"
    echo "---------------------------"
    echo "1. Tambah Tugas"
    echo "2. Tampilkan Semua Tugas"
    echo "3. Ubah Status Tugas"
    echo "4. Ubah Teks Tugas"
    echo "5. Hapus Tugas"
    echo "6. Keluar"
    echo "---------------------------"
    read -p "Pilih opsi (1-6): " pilihan
}

# Loop utama program
while true; do
    tampilkan_menu
    case "$pilihan" in
        1)
            tambah_tugas
            ;;
        2)
            tampilkan_tugas_dengan_status
            ;;
        3)
            ubah_status
            ;;
        4)
            # Menggunakan kembali fungsi ubah_tugas lama
            read -p "Masukkan nomor tugas yang ingin diubah: " nomor
            read -p "Masukkan tugas yang baru: " tugas_baru

            if [[ "$nomor" =~ ^[0-9]+$ ]] && [ "$nomor" -gt 0 ]; then
                # Mengganti seluruh baris dengan teks baru, sambil mempertahankan status
                current_status=$(sed -n "${nomor}p" "$TUGAS_FILE" | grep -o "\[.\]")
                sed -i "${nomor}s/.*/$current_status $tugas_baru/" "$TUGAS_FILE"
                echo "Tugas berhasil diubah."
            else
                echo "Nomor tidak valid."
            fi
            ;;
        5)
            # Menggunakan kembali fungsi hapus_tugas lama
            tampilkan_tugas_dengan_status
            if [ ! -s "$TUGAS_FILE" ]; then
                continue
            fi
            read -p "Masukkan nomor tugas yang ingin dihapus: " nomor
            if [[ "$nomor" =~ ^[0-9]+$ ]] && [ "$nomor" -gt 0 ]; then
                sed -i "${nomor}d" "$TUGAS_FILE"
                echo "Tugas berhasil dihapus."
            else
                echo "Nomor tidak valid."
            fi
            ;;
        6)
            echo "Semua tugas berhasil dihapus."
            rm "$TUGAS_FILE"
            echo "Keluar dari program. Sampai jumpa!"
            exit 0
            ;;
        *)
            echo "Opsi tidak valid. Silakan pilih 1-6."
            ;;
    esac
    echo ""
done
