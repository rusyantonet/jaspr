---
title: Home Server Using STB
description: Build Home Server Using STB HG680P.
---

Untuk mendevelopment sebuah hosting di Linux pada dasarnya kita memerlukan 3 item utama yang biasanya dikenal dengan `LNMP ( Linux Nginx MySql Php )` atau `LAMP ( Linux Apache MySql Php )`

Dasarnya itu adalah componen Webserver dan database dan sistem managemnet basis data

- Webserver : menerima permintaan dari browser untuk diolah di sitem yang dibangun
- Mysql : untuk menyimpan, mengelola, dan mengambil data dengan menggunakan Structured Query Language (SQL)
- PHP : bahasa pemrograman server-side yang digunakan untuk membuat website

Semua memiliki versi tertentu yang dapat disesuaikan dengan project yang dibangun

Eksperimen kali ini saya ingin membuat sebuah website dengan hosting saya taruh di STB HG680P.  dan websitenya dapat diakses oleh semua orang secara public. tanpa kita harus memiliki IP Publik.

## Requirements

- STB HG680P
- MicroSD Card
- MicroSD Card Reader
- Rufus / Balena Etcher
- Putty

Silahkan pastikan STB Anda sudah di root dan bisa menjalankan os linux / openwrt

- Download Linux Untuk STB / board yang anda pakai bisa perhatikan tabel berikut ini. saya sudah mencoba beberapa versi linux namun saya lebih cenderung cocok menggunakan ubuntu 22.04 . paket-paket di aapanel berjalan dengan sempurna

sumber : https://github.com/ophub/amlogic-s9xxx-armbian/releases

acces melalui ssh

ip adrress linux

usename : root

password: 1234

lakukan update pada repository linux untuk memastikan apakah internet mengalir ke server kita

```dart
sudo apt update
```
## Install aapanel

sumber : https://www.aapanel.com/new/download.html

autoskrip installasi aapanel

```dart
URL=https://www.aapanel.com/script/install_7.0_en.sh && if [ -f /usr/bin/curl ];then curl -ksSO "$URL" ;else wget --no-check-certificate -O install_7.0_en.sh "$URL";fi;bash install_7.0_en.sh aapanel
```

## Langkah-Langkah yang dilakukan ketika aapanel terinstall

sintaks untuk mengconfigurasi aapanel

```dart
bt
```

- mengganti username
- mengganti password
- mengganti port
- mengganti security entrance
- mematikan panel SSL

saya mengambil tema dari:

https://themewagon.com/theme-category/landing-website/

skema membuat website

![Skema Build Website](images/content/whatever/skema-web-serve.svg)

# langkah-langkah meng-onlinekan web

- membeli domain
- konekkan ke cloudflare
- tunnel dengan zerotrust