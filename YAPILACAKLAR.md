# Yapılacaklar — AkbankPythonBootcamp

Bu liste denetim sırasında **kod okunarak ve program çalıştırılarak** çıkarıldı.
Her madde: neden gerekli, hangi dosya/satır, ne yapılmalı.

Öncelik: 🔴 kritik · 🟡 orta · 🟢 düşük

---

## G1 🔴 Hassas veri düz metin saklanıyor (ve commit edilmiş)

**Nerede:** `bootcamp.py` → `save_order()` (satır ~146) ve `main()` (satır ~186)
**Kanıt:** `Orders_Database.csv` içinde 4 satır, her birinde TC no + kart no + şifre.

```python
save_order(name, tc_no, credit_card_no, cc_pass, ...)
```

**Neden sorun:** Kart şifresi hiçbir sistemde saklanmaz — PCI-DSS Req. 3.2 bunu
yasaklar. TC Kimlik No ise KVKK kapsamında kişisel veridir; şifresiz, erişim
denetimsiz bir CSV'de tutulamaz.

**Yapılacak (seçeneklerden biri):**

- **Seçenek A (önerilen, ödev bütünlüğünü bozmaz):** Kart şifresi sorusunu
  tamamen kaldır. Kart numarasının yalnızca **son 4 hanesini** sakla
  (`****-****-****-1111`). TC no yerine sıra numarası üret.
- **Seçenek B:** Alanları sormaya devam et ama **hiçbirini diske yazma**;
  yalnızca sipariş açıklaması + tutar + zaman damgası kaydet.
- **Seçenek C:** Ödevin orijinal hâlini korumak isteniyorsa kod değişmesin, ama
  `Orders_Database.csv` depodan çıkarılsın ve `.gitignore`'a eklensin.

**Ek adım (her seçenekte):** Depoda hâlihazırda duran `Orders_Database.csv`
içeriği temizlensin. İçindeki veriler test verisi olsa da depo geçmişinde kalır.

---

## K1 🟡 Hatalı girdi programı çökertiyor

**Nerede:** `bootcamp.py` satır ~157 ve ~170 — `int(input(...))`
**Kanıt (denetimde çalıştırıldı):**

```
$ printf 'abc\n' | python3 bootcamp.py
ValueError: invalid literal for int() with base 10: 'abc'
```

**Yapılacak:** Girdi okumayı bir döngü + `try/except ValueError` içine al;
geçersiz girişte kullanıcıya tekrar sor. Örneğin:

```python
def sayi_sor(soru, gecerli):
    while True:
        try:
            d = int(input(soru))
        except ValueError:
            print("Lütfen bir sayı girin.")
            continue
        if d in gecerli:
            return d
        print(f"Geçersiz seçim. Seçenekler: {sorted(gecerli)}")
```

`Ctrl+C` / `Ctrl+D` (`KeyboardInterrupt`, `EOFError`) da yakalanmalı ki program
yığın izi basmadan kapansın.

---

## K2 🟡 `main()` modül seviyesinde çağrılıyor — test yazılamıyor

**Nerede:** `bootcamp.py` son satırı: `main()`

**Neden sorun:** `import bootcamp` demek programı başlatır ve `input()` bekler.
Bu yüzden tek bir birim testi bile yazılamaz.

**Yapılacak:**

```python
if __name__ == "__main__":
    main()
```

---

## K3 🟢 `menu.txt` her çalıştırmada üzerine yazılıyor

**Nerede:** `bootcamp.py` satır ~13 — `with open("menu.txt", "w") as file:`

**Neden sorun:** Menü hem kodda hem dosyada duruyor; dosya sürüm kontrolünde
tutuluyor ama program onu her açılışta eziyor. Elle yapılan bir menü düzenlemesi
ilk çalıştırmada kaybolur. Ayrıca menü metnindeki fiyatlar kodda tanımlı
`*_PRICE` sabitleriyle **senkron değil** (menüde fiyat hiç yazmıyor).

**Yapılacak (seçenekli):**

- Menü dosyası yoksa yaz, varsa dokunma (`if not os.path.exists("menu.txt")`), veya
- Menüyü tamamen koddaki fiyat sabitlerinden **üret** — tek doğruluk kaynağı kod olsun.

---

## K4 🟢 Yalnızca tek sos seçilebiliyor

**Nerede:** `main()` içinde sos seçimi tek seferlik.

**Neden sorun:** Decorator deseninin ana faydası **zincirleme** sarmalamadır
(`Meat(Olive(TurkishPizza()))` gibi). Mevcut arayüz bu gücü kullanmıyor.

**Yapılacak:** Sos seçimini "0 girilene kadar sor" döngüsüne çevir ve her seçimde
mevcut nesneyi yeniden sar:

```python
urun = pizza
while True:
    s = sayi_sor("Sos seçin (bitirmek için 0): ", {0, 11, 12, 13, 14, 15, 16})
    if s == 0:
        break
    urun = SOSLAR[s](urun)
```

---

## K5 🟢 Kullanılmayan import

**Nerede:** `bootcamp.py` satır 11 — `import datetime`, hiç kullanılmıyor.

**Yapılacak:** Ya kaldır, ya da sipariş satırına zaman damgası ekleyerek kullan
(ikincisi daha faydalı: siparişin ne zaman verildiği CSV'de yok).

---

## K6 🟢 `Orders_Database.csv` başlık satırı yok

Dosya doğrudan veri satırıyla başlıyor. Bir tabloya aktarıldığında ilk sipariş
başlık sanılır.

**Yapılacak:** Dosya yoksa/boşsa önce başlık satırı yaz:
`ad,musteri_no,kart_son4,siparis,tutar,tarih`

---

## K7 🟢 Test ve CI yok

**Yapılacak (K2 çözüldükten sonra mümkün olur):** `tests/test_pizza.py` altında
`pytest` ile fiyat/açıklama zinciri testleri:

```python
def test_turk_pizza_et_sosu_35_tl():
    assert Meat(TurkishPizza()).get_cost() == 35.0

def test_cift_sos_zincirlenir():
    assert Olive(Meat(SadePizza())).get_cost() == 20 + 5 + 2
```

CI için `.github/workflows/test.yml` (ubuntu-latest, python 3.11, `pytest`).

---

## K8 🟢 Kod stili

- Sabitler (`KLASIK_DESC`, `KLASIK_PRICE`, …) modül seviyesinde dağınık; bir
  `PIZZALAR` / `SOSLAR` sözlüğü hem `main()` içindeki `if/elif` zincirini hem de
  menü üretimini tek yerden besleyebilir.
- `KLASIK_PRICE = 25` int, diğerleri float (`30.0`). Hepsi aynı tipte olsun —
  para hesabında `decimal.Decimal` daha doğrudur.
- Dosya başındaki "Automatically generated by Colaboratory" yorum bloğu artık
  doğru değil, temizlenebilir.

---

## Öncelik sırası önerisi

1. **G1** — hassas veri (kod değişikliği + CSV temizliği)
2. **K2** — `if __name__ == "__main__"` (tek satır, K7'nin önkoşulu)
3. **K1** — girdi doğrulama
4. **K8 + K4** — sözlük tabanlı yeniden yapılandırma + çoklu sos
5. **K3, K5, K6** — küçük temizlikler
6. **K7** — testler + CI
