# AkbankPythonBootcamp — Pizza Sipariş Uygulaması

Akbank Python Bootcamp bitirme ödevi. Terminal üzerinden çalışan, **Decorator
tasarım deseni** ile kurulmuş basit bir pizza sipariş uygulaması.

> Bu bir **eğitim/ödev** deposudur, üretim yazılımı değildir.
> Çalıştırmadan önce [Güvenlik uyarısı](#güvenlik-uyarısı-önemli) bölümünü okuyun.

---

## Ne yapar

1. `menu.txt` dosyasını (her çalıştırmada yeniden) yazar ve ekrana basar.
2. Kullanıcıdan bir **pizza tabanı** (1–4) ve bir **sos** (11–16) seçmesini ister.
3. Seçilen sosu, seçilen pizzanın üzerine `Decorator` deseni ile sarar; açıklama
   ve fiyat bu sarmalama zincirinden hesaplanır.
4. Müşteri bilgilerini ve sipariş özetini `Orders_Database.csv` dosyasına
   satır olarak ekler.
5. Toplam tutarı ekrana yazar.

### Menü ve fiyatlar

| Kod | Pizza tabanı | Fiyat (₺) |
|----:|--------------|----------:|
| 1 | Klasik | 25 |
| 2 | Margarita | 30 |
| 3 | Türk Pizza | 30 |
| 4 | Sade | 20 |

| Kod | Sos | Fiyat (₺) |
|----:|-----|----------:|
| 11 | Zeytin | 2 |
| 12 | Mantar | 2 |
| 13 | Keçi Peyniri | 4 |
| 14 | Et | 5 |
| 15 | Soğan | 1 |
| 16 | Mısır | 2 |

Toplam = taban fiyatı + sos fiyatı. **Yalnızca bir sos** seçilebilir (aşağıdaki
"Bilinen kısıtlar" bölümüne bakın — desen çoklu sosu destekler ama arayüz sormaz).

---

## Dosyalar

| Dosya | İçerik |
|---|---|
| `bootcamp.py` | Tüm uygulama: sınıflar, dekoratörler, CSV yazımı, `main()` |
| `menu.txt` | Menü metni — **program tarafından her çalıştırmada üzerine yazılır** |
| `Orders_Database.csv` | Sipariş kayıtları (başlık satırı yok, `append` modunda büyür) |

## Sınıf yapısı

```
Pizza (temel)
├── ClassicPizza · MargheritaPizza · TurkishPizza · SadePizza
└── Decorator (Pizza'yı sarar, get_cost/get_description'ı zincirler)
    └── Olive · Mushroom · GoatCheese · Meat · Onion · Corn
```

---

## Çalıştırma

Gereksinim: **Python 3.8+** (yalnızca standart kütüphane: `csv`, `datetime`).
Ek bağımlılık yoktur, sanal ortam gerekmez.

### Intel Mac / Apple Silicon Mac / Linux

```bash
./run-mac-intel.sh
```

veya doğrudan:

```bash
python3 bootcamp.py
```

### Windows

```bat
run-windows.bat
```

veya doğrudan:

```bat
python bootcamp.py
```

Program çalıştığı dizine `menu.txt` ve `Orders_Database.csv` yazar; bu yüzden
**depo kökünden** çalıştırın.

### Örnek oturum

```
$ python3 bootcamp.py
* Lütfen Bir Pizza Tabanı Seçiniz:
1: Klasik
...
Lütfen bir pizza seçin: 3
Lütfen bir sos seçin: 14
İsim: Ali
TC Kimlik No: ...
Kredi Kartı No: ...
Şifre: ...
Ver mehteri... Sucuk, kaşar peyniri, domates ve biber ile... Et Sosu siparişiniz toplam 35.0 ₺ tutmuştur. Afiyet olsun...
```

---

## Güvenlik uyarısı (ÖNEMLİ)

Bu ödev kodu, kullanıcıdan **TC Kimlik No, kredi kartı numarası ve kart şifresi**
ister ve bunları `Orders_Database.csv` dosyasına **düz metin** olarak yazar.

- Dosya depoya **commit edilmiş** durumdadır ve içinde test verisi vardır.
- Gerçek kart/kimlik bilgisi **girmeyin**; bu program hiçbir güvenlik önlemi
  içermez (şifreleme yok, maskeleme yok, PCI-DSS uyumu yok).
- Kendi makinenizde denerken uydurma değerler kullanın.

Ayrıntı ve düzeltme önerileri: [`YAPILACAKLAR.md`](YAPILACAKLAR.md) → G1.

---

## Bilinen kısıtlar

- Tek sos seçilebilir (dekoratör zinciri çokluyu destekler, arayüz desteklemez).
- Sayı beklenen yere harf girilirse program `ValueError` ile çöker.
- `main()` dosya import edildiği anda çalışır (`if __name__ == "__main__"` yok).
- Test yoktur, CI yoktur.

Tam liste: [`YAPILACAKLAR.md`](YAPILACAKLAR.md)
Durum raporu: [`DURUM-RAPORU.md`](DURUM-RAPORU.md)
