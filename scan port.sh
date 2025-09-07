#!/bin/bash

# Pastikan netcat (nc) sudah terpasang
if ! command -v nc &> /dev/null
then
    echo "Error: Perintah 'nc' (Netcat) tidak ditemukan."
    echo "Pastikan Netcat terpasang di sistem Anda."
    exit 1
fi

# Fungsi untuk menampilkan bantuan
tampilkan_bantuan() {
    echo "Penggunaan: $0 <host> <port_awal> <port_akhir>"
    echo "Contoh: $0 127.0.0.1 1 100"
    exit 1
}

# Periksa jumlah argumen
if [ "$#" -ne 3 ]; then
    tampilkan_bantuan
fi

HOST="$1"
PORT_AWAL="$2"
PORT_AKHIR="$3"

echo "Memindai port terbuka pada $HOST dari port $PORT_AWAL hingga $PORT_AKHIR..."
echo "Hasil:"

# Loop untuk memindai setiap port dalam rentang yang ditentukan
for (( PORT=PORT_AWAL; PORT<=PORT_AKHIR; PORT++ ))
do
    # Menggunakan 'nc' untuk mencoba koneksi.
    # Timeout 1 detik dan tanpa output verbose (-w 1 -z).
    # Redirect stderr ke stdout (2>&1) dan filter dengan grep.
    nc -z -w 1 "$HOST" "$PORT" &>/dev/null

    # $? adalah kode keluar dari perintah sebelumnya. 0 berarti berhasil (port terbuka).
    if [ $? -eq 0 ]; then
        echo "Port $PORT [TERBUKA]"
    fi
done

echo "Selesai."
