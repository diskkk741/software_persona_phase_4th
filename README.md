# Mini Katalog Uygulaması (Flutter)

## Proje Tanımı

Bu proje, Flutter haftalık eğitim süreci kapsamında geliştirilen temel seviyede bir mobil uygulamadır. Amaç; Flutter kullanarak widget yapısını, sayfa geçişlerini, veri modelleme mantığını ve basit state yönetimini uygulamalı olarak öğrenmektir.

Uygulama, ürün verilerini yerel bir JSON dosyasından okuyarak dinamik şekilde listeleyen ve basit bir sepet simülasyonu içeren bir “Mini Katalog” uygulamasıdır.

---

## Kullanılan Teknolojiler

- Flutter SDK
- Dart
- Material Design (material.dart)
- Android Emulator
- Visual Studio Code

Ekstra paket kullanılmamıştır. Uygulama yalnızca Flutter’ın temel bileşenleri ile geliştirilmiştir.

---

## Uygulama Özellikleri

- JSON dosyasından ürün verisi okuma
- Model sınıfı ile veri mapleme (fromJson)
- GridView ile kart tabanlı ürün listeleme
- Ürün arama ve filtreleme
- Ürün detay sayfası
- Navigator.push / pop ile sayfa geçişi
- Route argument ile veri taşıma
- Sepete ürün ekleme
- Aynı üründe adet artırma (quantity mantığı)
- Sepette toplam tutar hesaplama
- AppBar üzerinde sepet badge gösterimi
- Basit UI tema düzenlemesi

---

## Proje Yapısı

lib/
 ├── main.dart
 ├── models/
 │    ├── product.dart
 │    └── cart_item.dart
 ├── pages/
 │    ├── product_detail_page.dart
 │    └── cart_page.dart
 └── utils/
      └── format.dart

- `models/` klasörü veri modellerini içerir.
- `pages/` klasörü ekran bileşenlerini içerir.
- `utils/` yardımcı fonksiyonları içerir.
- `assets/` klasöründe JSON ve görseller yer almaktadır.

---

## Çalıştırma Talimatı

Projeyi çalıştırmak için:

flutter pub get
flutter run

Android Emulator veya fiziksel cihaz bağlı olmalıdır.

---

## Öğrenme Kazanımları

Bu proje ile:

- Flutter widget mimarisi kavranmıştır.
- Stateless ve Stateful widget farkı uygulanmıştır.
- Navigator ile sayfa geçişleri gerçekleştirilmiştir.
- JSON veri yapısı ile modelleme yapılmıştır.
- GridView ve dinamik listeleme uygulanmıştır.
- Basit state yönetimi ile sepet simülasyonu geliştirilmiştir.
- Mobil uygulama klasör yapısı ve asset yönetimi öğrenilmiştir.

---

## Not

Bu proje eğitim amaçlı geliştirilmiştir. Gerçek bir e-ticaret altyapısı veya ödeme sistemi içermez. Sepet işlemleri simülasyon niteliğindedir.
