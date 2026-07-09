---
title: Cloud Server dari STB Bekas Indihome
description:
---

Beberapa waktu lalu saya selalu berlangganan 2 provider cloud Google Drive & iCloud untuk kerpeluan sharing files dan backup file tipis-tipis. Tapi saya rasa terasa mubazir berlangganan tiap bulan sekitar 100K++ hanya untuk menjaga file saya disana, tapi disisi lain saya ingin bisa tetap mengakses file saya dimana aja.

Tak berpikir lama saya langsung download semua file yang ada di Gdrive & iCloud dan dipindahkan ke SSD External saya. Tiap kali iPhone saya penuh sama foto & video saya selalu backup ke SSD External tapi sangat tidak praktis.

<Info>
Pastikan versi yang dipakai adalah B860v2 Unlocked dan OS bawaan STB menggunakan android rooted
</Info>

## Instalasi OS Armbiarn

### Membuat Bootable Image Armbian

Hardware:
1. MicroSD Card Reader
2. MicroSD Card (8GB)
3. SSD External
4. Monitor Display
5. Kabel HDMI
6. Keyboard
7. Mouse
8. STB

Software dan Dependency:
1. Rufus
2. Image OS Armbian
3. extlinux.conf
4. u-boot.ext
5. uboot.bin

Resource yang dibutuhkan:
[Download](https://drive.google.com/drive/folders/1gt4GDVZABZF49IML9fiBQ9EnG3aRzkC1?usp=sharing)

Jika kalian sudah download semuanya, extract file `Armbian_20.10_Arm-64_bionic_current_5.9.0.img.xz` menggunakan 7z atau winrar.

Nanti akan muncul file baru hasil extract berukuran 5gb-an, file itu nantinya kita akan jadikan bootable.

Kemudian colokan SdCard ke Card Reader dan buka software Rufus, kemudian pilih file img yang barusan diextract dan pilih SdCard yang dicolok tadi. Setelah itu klik Start.

Sampai sini bootable kalian sudah jadi, tapi kita butuh sedikit modifikasi. Kita harus copy file `uboot.bin` dan `u-boot.ext` ke folder root dari SdCard yang sudah dibuat bootable.

Kemudian copy dan replace file extlinux.conf juga ke dalam folder **extlinux**.

### Instal Bootable Armbian

Sekarang kita bisa colokan SdCard ke STB lalu nyalakan. Saya sarankan gunakan keyboard & mouse dan dicolok ke monitor melalui HDMI, Jika sudah booting dan masuk ke Androidnya kita buka File Manager terlebih dahulu untuk meng-copy file `uboot.bin` ke eMMC STB nya.

![Buka File Exploler](images/content/whatever/armbian_1.webp)

Cari file `uboot.bin` didalam SdCard yang sudah kita colok ke STB nya.

![File uboot.bin dari SdCard](images/content/whatever/armbian_2.webp)

Kemudian copy ke folder Download, disini saya simpan di folder Download agar nanti mudah diakses.

![Copy File ke folder Download](images/content/whatever/armbian_3.webp)

Selanjutnya, buka Terminal Emulator lalu ketik perintah 

```dart
su
```

Jika perintah tersebut sudah dijalankan akan muncul popup root access, pilih Grant access agar kita bisa menggunakan akses root di Terminal Emulator.

Kemudian, kita arahkan ke folder Download.

```dart
cd /sdcard/Download
```

Selanjutnya kita replace bootloader bawaan STB dengan uboot.bin yang tadi kita copy. 

```dart
dd if=uboot.bin of=/dev/block/bootloader
```

Terakhir jalankan perintah agar perubahan bootloader ter-update.

```dart
reboot update
```

<Warning>
Ditahap ini STB kalian akan restart, pastikan saat proses restart jangan dicabut tunggu sampai berhasil booting 
</Warning>

![Tampilan booting armbian](images/content/whatever/booting-armbian.webp)

Tunggu proses log booting armbian selesai, sampai nanti kalian akan diminta untuk input New Password. Sampai disini kalian tinggal masukkan password aja, passwordnya bebas diatas 5 karakter.

<!-- ![Input Password](images/content/whatever/stb.webp) -->

Langkah berikut nya kalian hanya perlu memasukkan Username & Password untuk akun baru di OS Armbian.

Langkah berikutnya jalankan perintah agar STB kalian tidak memerlukan SdCard lagi ketika ingin booting ke Armbian

```dart
sudo ./install-aml.sh
```
 
<Warning>
  Tidak semua STB bisa melakukan booting tanpa SDCard, beberapa ada yang lock eMMC sehingga perintah diatas gagal dilakukan. Seperti punya saya yang lock eMMC jadi jangan cabut SDCard!
</Warning>

Langkah terakhir untuk proses ini tinggal colok STB ke Ethernet untuk melakukan update repository package

```dart
sudo apt update
```
Selesai sampai disini kalian sudah berhasil instalasi OS Armbian di STB, berikutnya kita akan lakukan setup Infrastruktur untuk NAS / Cloud Drive.

## Setup Infrastruktur (Docker, Nextcloud, Mounting Drive)

Ada beberapa software yang nanti kita gunakan yaitu:
1. Docker
2. Nextcloud
3. openssh-server

###  Install openssh-server

Agar proses instalasi bisa dilakukan melalui laptop atau pc saya akan instal openssh-server terlebih dahulu dengan perintah

```dart
sudo apt install openssh-server
```

kemudian kita bisa aktifkan daemon untuk openssh-server nya dengan perintah

```dart
sudo systemctl enable ssh
```

Jika openssh-server sudah terinstall kalian bisa remote melalui local network dengan cara pada umumnya

```
ssh root@<ip-lokal-dari-stb>
```

### Instalasi Docker

Untuk melakukan instalasi docker mirip seperti ketika kita pakai ubuntu, kita bisa tambahkan GPG key dan update repository sebelum menginstall Docker dengan perintah berikut.

**Add Docker's official GPG key**

```dart
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```
**Add the repository to Apt sources**
```dart
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
**Update repository**
```dart
sudo apt-get update
```
Jika sudah dijalankan, kita bisa lanjut ke perintah selanjutnya untuk menginstall docker nya.

```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Jika sudah silahkan kalian running command untuk memastikan docker berhasil di install.

```
docker ps
```

### Mount HDD / SSD Dari external

Untuk mounting HDD / SSD kalian bisa langsung colok melalui port USB, dan jalankan perintah untuk mengecek apakah HDD / SSD External sudah masuk.

```dart
lsblk
```

Saya membuat folder spesifik tempat dimana kita akan akses file dari SSD External yang kita mount. Disini saya letakkan di directory `/mnt/deffcon-ssd`

```
sudo mkdir /mnt/deffcon-ssd
sudo mount /dev/sda7 /mnt/deffcon-ssd
```

Jika sudah, sekarang coba cek folder tampat kalian mount SSD External.

### Setup Compose File Nexcloud

Selanjutnya kita harus setup nextcloud, disini saya membuat path baru untuk menyimpan konfigurasi compose di directory: `~/Infra/NextCloud` dengan perintah

```dart
mkdir ~/Infra/NextCloud && cd ~/Infra/NextCloud
```
Kemudian kita buat file `docker-compose.yml` di dalam folder tersebut. Kemudian berikut konfigurasi docker-compose.yml

```dart
version: '3.8'

services:
  nextcloud:
    image: nextcloud
    container_name: nextcloud
    restart: always
    ports:
      - 8080:80
    environment:
      - MYSQL_HOST=localhost
      - MYSQL_PASSWORD=[PASSWORD ANDA]
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - NEXTCLOUD_ADMIN_USER=admin
      - NEXTCLOUD_ADMIN_PASSWORD=[PASSWORD ANDA]
      - REDIS_HOST=redis
    volumes:
      - nextcloud_data:/var/www/html
      - /mnt/deffcon-ssd:/mnt/deffcon-ssd # Sesuaikan dengan path SSD External anda
    depends_on:
      - db
      - redis

  db:
    image: mariadb
    container_name: nextcloud-db
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=[PASSWORD ANDA]
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=[PASSWORD ANDA]
    volumes:
      - db_data:/var/lib/mysql

  redis:
    image: redis:alpine
    container_name: nextcloud-redis
    restart: always
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

  traefik:
    image: traefik
    container_name: traefik
    restart: always
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.tlschallenge=true"
      - "--certificatesresolvers.myresolver.acme.email=[EMAIL ANDA]"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
    ports:
      - 80:80
      - 443:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - traefik_letsencrypt:/letsencrypt

volumes:
  nextcloud_data:
  db_data:
  redis_data:
  traefik_letsencrypt:
```

Jika sudah kita bisa jalankan perintah agar container dibuat dan jalan di daemon.

```dart
docker compose up -d
```

### Setting Trusted Domain di nextcloud

Sampai disini seharusnya kalian sudah bisa mengakses halaman nextcloud dari STB di port 8080.

![Trusted Domain](images/content/whatever/trusteddomain.webp)

Namun jika kita akses akan menampilkan halaman error **Access through untrusted domain**. Disini kita harus atur konfigurasi trusted domain yang nantinya akan kita akses, dalam kasus ini saya ingin mengakses dari ip lokal 192.168.1.13 dan domain pribadi saya misalnya cloud.deffcon.com.

Caranya kita akses ke dalam container nextcloud nya kemudian akses ke folder `www/html/config/config.php`, dengan perintah berikut.

```dart
# akses ke dalam container nextcloud
docker exec -it nextcloud /bin/bash

# masuk ke dalam folder config
cd config/

# lakukan edit ke file config.php
nano config.php

# jika terjadi error "bash: nano: command not found" jalankan command ini
apt update && apt install nano -y
```

Kemudian cari array item dengan key `trusted_domains`, dan tambahkan ip lokal kalian dan domain yang ingin dipakai.

![Trusted Domain Setting](images/content/whatever/trusteddomain_2.webp)

Jika sudah, kembali ke browser lalu refresh halaman nextcloud. Seharusnya kalian sudah bisa login dengan akun admin yang sudah diatur di docker-compose.yml tadi.

![Trusted Domain](images/content/whatever/trusteddomain_3.webp)

### Setting SSD External di nextcloud

Ada beberapa step untuk mounting HDD / SSD External kita ke nextcloud agar terbaca. Pertama colok HDD / SSD kalian ke STB lalu cek apakah HDD / SSD sudah masuk atau belum dengan perintah

```dart
lsblk
```

Disini terlihat sudah ada SSD saya yang berukuran 256gb dengan nama `sda`, disini saya akan mounting pada partisi `sda7`. Namun sebelum kita mounting kita harus membuat dulu mount pointnya.

Disini saya akan membuat mount point di `/mnt/derffcon-ssd` caranya sederhana tinggal jalankan printah 

```dart
mkdir /mnt/deffcon-ssd
```

Jika mount point sudah dibuat kita bisa langsung mounting SSD pada partisi `sda7` tadi dengan perintah 

```dart
mount /dev/sda7 /mnt/deffcon-ssd
```

<Info>
sda7 adalah nama partisi yang saya miliki, tiap device mungkin bisa berbeda nama
</Info>

Lalu kita coba lihat isi folder `/mnt/deffcon-ssd`, seharusnya akan menampilkan isi folder dan files yang ada di SSD tersebut. Press enter or click to view image in full size

Sampai sini kita sudah berhasil mounting SSD External kita namun nextcloud belum bisa mengaksesnya, kita harus atur Permission, Mount volume pada docker dan mengatur di pengaturan nextcloud nya.

Pertama kita atur permission mount point tadi agar menjadi “www-data”, disini mount point saya adalah `/mnt/deffcon-ssd` so kita atur permissionnya dengan perintah 

```dart
sudo chown -R 33:33 /mnt/deffcon-ssd
```

pastikan sesuaikan dengan mount point kalian. Jika kita lihat isi foldernya maka akan terlihat permissionnya menjadi `www-data`.

Langkah kedua kita pastikan mount volume pada `docker-compose.yml` sudah sesuai.

Pastikan mount point yang tadi kalian buat sudah didefinisikan di volumes `docker-compose.yml`. Jika belum definisikan lalu restart container kalian dengan perintah 

```dart
docker compose stop && docker compose up -d
```

Langkah ketiga kita bisa atur ke dashboard nextcloudnya, lakukan login lalu ke administration settings.

Kemudian cari menu disebelah kiri dengan nama **System** klik menu tersebut, lalu cari section dengan nama **Disks**, terlihat disini SSD saya belum terdeteksi hanya Sdcard yang terbaca di nextcloud.

Agar SSD External kita terdeteksi nextcloud kita buka menu **Apps**, lalu navigasi ke **Disabled Apps**, Kemudian cari **External Storage** lalu klik **enable** disebelah kanan.

Jika sudah di enable maka kita bisa kembali lagi ke **Administration settings**. Di dalam menu Administration settings akan muncul menu baru yaitu **External Storage** klik menu tersebut, Lalu tambahkan SSD External.

Disini kita bisa menambahkan berbagai external storage selain dari Hard Drive kita bisa menambahkan juga dengan format lain seperti S3, FTP, WebDav, SFTP, dll. Untuk **Folder name** bebas, itu adalah nama yang nantinya akan tampil di file manager nextcloud.

Jika sudah di simpan, coba cek kembali bagian menu **System** dan scroll ke section **Disks** apakah SSD / HDD External kalian sudah terdeteksi atau belum. Jika belum coba lakukan restart pada container kalian dengan perintah 

```dart
docker compose stop && docker compose up -d
```

Jika sudah refresh halaman tadi.

Seharusnya SSD / HDD External sudah terdeteksi seperti ini. dan kalian bisa navigasi ke File manager nextcloud untuk mulai upload atau melihat isi file didalam drive kalian.

<Error>
Disini saya mengalami masalah, dimana file yang ada di SSD External saya tidak muncul apapun di nextcloud, seharusnya ada 2 folder deffcon tapi di nextcloud tidak tampil sama sekali.
</Error>

Jika kalian mengalami hal yang serupa seperti saya, coba jalankan perintah ini.

```dart
$ docker exec -u www-data nextcloud php /var/www/html/occ files:scan --all -vvv
```

Fungsi perintah itu untuk me-refresh atau me-scan ulang folder dan files yang ada didrive external kita.

Jika sudah running perintah tersebut lakukan refresh dihalaman nextcloud, dan seharusnya folder dan files kita sudah terbaca dan bisa diakses di nextcloud.

### Setup Cloudflare Tunnel & Custom Domain

Langkah pertama kita setting nameserver pada domain kita menggunakan nameserver dari cloudflare. Klik **Add Domain** lalu masukkan nama domain kita, kemudian klik **Next** dan pilih **Free plan**.

<!-- ![Free Plan Cloudflare](images/content/whatever/cloudflare_setup.webp) -->

Kemudian update nameservers kalian pada domain provider kalian menggunakan nameservers dari cloudflare.

![Update NameServer](images/content/whatever/cloudflare_nameserver.webp)

Jika kita sudah setting nameservers nya biasanya membutuhkan waktu 1x24jam untuk perubahan nameservers, tunggu dan coba cek berkala pada cloudflare, pastikan statusnya sudah **Active**.

![Status Nameserver](images/content/whatever/cloudflare_nameserver_status.webp)

Langkah selanjutnya kita setting tunneling dengan mengakses ke menu **Zero Trust** > **Networks** > **Tunnels**

Kemudian jika menu tersebut sudah terbuka kita bisa menambahkan tunnel baru dengan klik **Create a tunnel** > **Select Cloudflared** dan masukkan nama Tunnel (bebas).

Selanjutnya kita install cloudflared pada STB dengan menjalankan perintah yang ditampilkan di website cloudflare, sebelumnya pilih OS Debian dengan arsitektur `arm64`.

![Create Thunnel](images/content/whatever/cloudflare_thunnel.webp)

Jika sudah diinstall kita **configure** kembali tunnel yang telah kita buat, lalu tambahkan **Public Hostname**, lalu kalian bisa masukkan subdomain, domain, path sesuai yang kalian inginkan. Untuk port pastikan **:8080** karena itu adalah port yang kita gunakan pada container nextcloud

![Thunnel Config](images/content/whatever/thunnel_config_1.webp)

Sampai disini pastikan Tunnel yang kita buat sudah berstatus **Healthy**, terakhir silahkan akses subdomain kalian, Jika muncul error Untrusted domain silahkan ulangi langkah No. 5 dan masukkan ke daftar whitelist subdomain kalian.

![Whitelist Domain](images/content/whatever/whitelist_domain.webp)

<Success>
Dan berikut STB Server saya yang sudah online 😁😁
</Success>

![Nextcloud Online](images/content/whatever/nextcloud_online.webp)

Kita dapat mengubah STB IndiHome menjadi server Nextcloud yang berfungsi penuh. Proses ini memungkinkan Kita untuk memanfaatkan perangkat STB yang tidak terpakai untuk kebutuhan penyimpanan cloud pribadi. Selain hemat biaya, solusi ini juga memberikan kontrol penuh atas data Kita, memastikan privasi dan keamanan.