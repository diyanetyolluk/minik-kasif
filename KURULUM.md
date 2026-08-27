# Minik Kâşif — Kuruluma Hazır Proje

Bu klasör, telefona kurulabilir gerçek bir Flutter uygulamasının **tam kaynak kodudur.**
İçinde 3 dünya var: Eşleştirme Adası (8 bölüm), Harf-Sayı Ormanı (10 bölüm),
Boyama Vadisi (6 bölüm) — hepsi seviyeli, yıldızlı, çıkartma ödüllü.

## APK'yı almak için (ücretsiz, GitHub üzerinden)

1. **github.com**'a git, ücretsiz hesap aç.
2. Sağ üstten **+ → New repository** — adı `minik-kasif`, **Private** seç, oluştur.
3. Açılan sayfada **"uploading an existing file"** linkine tıkla.
4. Bu klasördeki **tüm dosya ve klasörleri** (gizli `.github` klasörü dahil!) sürükleyip bırak.
   ⚠️ `.github` klasörünü mutlaka yükle — APK'yı otomatik derleyen sistem onun içinde.
5. Sayfanın altından **Commit changes**'e bas.
6. Üstteki **Actions** sekmesine tıkla → "Android APK derle" adında bir işlem otomatik başlayacak
   (birkaç dakika sürer, sarı nokta yeşile dönene kadar bekle).
7. İşlem bitince üzerine tıkla, en altta **Artifacts** bölümünden **minik-kasif-apk** dosyasını indir.
8. İndirdiğin `.zip`'i aç, içindeki `app-release.apk`'yı Android telefonuna aktarıp kur.

Bu APK, Google Play'e yüklenmeden önce kendi telefonunda test etmen için.
Play Store'a çıkış aşamasında bir sonraki adımı ben yönlendireceğim.

## iPhone sürümü

iPhone derlemesi için ek bir adım (Codemagic + Apple Developer hesabı, 99$/yıl) gerekiyor —
bunu Android sürümü sende çalışıp onayladıktan sonra kuracağız.
