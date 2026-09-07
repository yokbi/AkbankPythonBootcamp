# Durum Raporu — AkbankPythonBootcamp

**Denetim tarihi:** 2026-09-07
**Denetleyen:** Claude Code (otomatik depo denetimi)
**Depo:** https://github.com/yokbi/AkbankPythonBootcamp

---

## 1. Özet

| | |
|---|---|
| Tür | Eğitim ödevi (Akbank Python Bootcamp bitirme projesi) |
| Dil / sürüm | Python 3 (yalnızca standart kütüphane) |
| Satır sayısı | `bootcamp.py` — 195 satır, tek dosya |
| Durum | **Çalışıyor.** Ödev kapsamı tamamlanmış. |
| Üretime hazır mı | **Hayır** — ve olması da amaçlanmamış (bkz. §5) |
| Test | Yok |
| CI | Yok |
| Bağımlılık | Yok (`pip install` gerekmez) |

**Bir cümleyle:** Decorator tasarım desenini gösteren, terminalden çalışan
pizza sipariş uygulaması; ödev olarak tamamlanmış ve çalışır durumda, ancak
hassas veriyi düz metin saklaması nedeniyle gerçek veriyle kullanılmamalıdır.

---

## 2. Doğrulanan çalışma kanıtı

Denetim sırasında program gerçekten çalıştırıldı (Linux, Python 3.11.15):

```
$ printf '3\n14\nTestAdi\n11111111111\n4111111111111111\n0000\n' | python3 bootcamp.py
... Et Sosu siparişiniz toplam 35.0 ₺ tutmuştur. Afiyet olsun...
EXIT=0
```

`Orders_Database.csv` dosyasına beklenen satır yazıldı:

```
TestAdi,11111111111,4111111111111111,0000,"Ver mehteri... ... Et Sosu",35.0
```

Fiyat hesabı doğrulandı: Türk Pizza (30) + Et Sosu (5) = **35.0 ₺** ✔

Hatalı girdi davranışı da doğrulandı:

```
$ printf 'abc\n' | python3 bootcamp.py
ValueError: invalid literal for int() with base 10: 'abc'
```

→ Program hatalı girdide çöküyor (hata yakalama yok). Bkz. `YAPILACAKLAR.md` K1.

---

## 3. Mimari

Ödevin istediği **Decorator (Dekoratör)** deseni doğru kurulmuş:

```
Pizza                         → _description, _cost + get_description(), get_cost()
├── ClassicPizza (25₺)
├── MargheritaPizza (30₺)
├── TurkishPizza (30₺)
└── SadePizza (20₺)

Decorator(Pizza)              → bir Pizza sarar; maliyeti ve açıklamayı zincirler
├── Olive (2₺) · Mushroom (2₺) · GoatCheese (4₺)
└── Meat (5₺) · Onion (1₺) · Corn (2₺)
```

`Decorator.get_cost()` içindeki `self._component.get_cost() + Pizza.get_cost(self)`
çağrısı zincirlemeyi doğru yapıyor — sarılan nesnenin maliyeti + dekoratörün
kendi maliyeti. Yapı doğru; **arayüz** bu yapıyı tam kullanmıyor (tek sos).

---

## 4. Dal envanteri

`git ls-remote --heads origin` çıktısına göre uzak dallar:

| Dal | Durum |
|---|---|
| `main` | Varsayılan dal, tüm iş burada |
| `claude/repo-audit-docs-e1dail` | Bu denetim/dokümantasyon dalı |

**Başka dalda saklı iş yoktur.** `main` üzerindeki commit geçmişi 3 commit:
`#First init` → `Update bootcamp.py` → `#hotfix`.

---

## 5. Bulgular

### 🔴 Kritik — hassas veri düz metin saklanıyor

`save_order()` fonksiyonu TC Kimlik No, kredi kartı numarası ve kart şifresini
`Orders_Database.csv` içine **hiçbir şifreleme/maskeleme olmadan** yazıyor.
Dosya depoya commit edilmiş ve içinde 4 satır test verisi bulunuyor.

Bu, bir bootcamp ödevi bağlamında beklenen bir eksiklik; ancak:

- Depo **herkese açıksa** bu dosya da açıktır.
- Gerçek veri girilmemelidir.
- Gerçek bir üründe kart şifresini **saklamak hiçbir koşulda meşru değildir**
  (PCI-DSS bunu açıkça yasaklar).

Öneri: `YAPILACAKLAR.md` → G1.

### 🟡 Orta — hatalı girdide çökme
Sayı beklenen alana metin girilirse `ValueError` ile çöküyor. → K1

### 🟡 Orta — `main()` modül seviyesinde çağrılıyor
Dosyanın son satırı koşulsuz `main()`. Bu yüzden `import bootcamp` demek bile
programı başlatır — test yazmayı imkânsız kılar. → K2

### 🟢 Düşük — `menu.txt` her çalıştırmada üzerine yazılıyor
Program açılışta `menu.txt`'i `"w"` modunda yeniden yazıyor; dosyanın depoda
tutulmasının bir anlamı kalmıyor ve elle yapılan menü düzenlemeleri kayboluyor. → K3

### 🟢 Düşük — kullanılmayan import
`import datetime` var, hiç kullanılmıyor. → K5

### 🟢 Düşük — tek sos kısıtı
Dekoratör deseni çoklu sos sarmalamayı destekliyor ama `main()` yalnızca bir
kez sos soruyor. Ödev kapsamı için yeterli, ürün için değil. → K4

---

## 6. Yarınki test için hazırlık (Intel Mac)

Bu depo Intel Mac'te **hiçbir kurulum gerektirmez**. macOS'ta sistem Python'u
(`python3`) yeterlidir.

```bash
git clone https://github.com/yokbi/AkbankPythonBootcamp
cd AkbankPythonBootcamp
./run-mac-intel.sh
```

Beklenen: menü ekrana gelir, seçim sorulur, sipariş CSV'ye eklenir.

**Uyarı:** İstenen TC/kart bilgisi alanlarına **uydurma değer** girin.

---

## 7. Sonraki adım

Kod tarafında yapılacak işlerin madde madde listesi: [`YAPILACAKLAR.md`](YAPILACAKLAR.md)
