# Revive Adserver – Instrukcja obsługi

### 1. Kluczowe pojęcia

- **Advertiser:** Klient, którego reklamy chcemy wyświetlać. W naszym przypadku nieuzywane, choć konieczne aby istniał przynajmniej jeden.
- **Campaign:** "Teczka" na reklamy danego klienta. Tutaj ustawiasz daty startu/końca oraz ogólne limity.
- **Banner:** Konkretna reklama (plik graficzny / HTML), którą widzi użytkownik.
- **Website:** Strona internetowa, na której wyświetlamy reklamy.
- **Zone:** Konkretne miejsce na stronie (np. "Top Banner 750x100" lub "Box w prawym menu"). To tutaj wpinane są bannery.

---

### 2. Jak to działa?

Aby reklama się wyświetliła, muszą zostać spełnione trzy warunki:

1.  Mamy **Kampanię** z aktywnym **Bannerem**.
2.  Mamy zdefiniowaną **Strefę (Zone)** na stronie.
3.  **Najważniejsze:** Kampania lub Banner są **połączone (Linked)** z tą Strefą.

**Priorytety wyświetlania:**
System wybiera reklamy w następującej kolejności (ważne przy planowaniu):

1.  **Override:** Kampanie priorytetowe (muszą się wyświetlić, ignorują inne).
2.  **Contract:** Kampanie standardowe (mogą mieć z określony cel np. 1000 odsłon).
3.  **Remnant:** Kampanie "wypełniacze" (wyświetlają się, gdy nie ma nic ważniejszego).

---

### 3. Dodawanie nowej reklamy

#### Krok A: Utwórz Reklamodawcę i Kampanię

1.  Wybierz zakładkę **Inventory**.
2.  Jeśli klienta nie ma, dodaj go (**Add new advertiser**).
3.  Dodaj nową kampanię (**Add new campaign**).
    - Wybierz jej typ.
    - Mozna ustawić datę startu i końca, priorytet.

#### Krok B: Dodaj Banner

1.  Wejdź w **Inventory > Banners**.
2.  Wybierz kampanię, dla której chcesz stworzyć baner.
3.  Kliknij **Add new banner**.
4.  Wybierz typ (zazwyczaj interesują Cię dwa):
    - **Web:** Jeśli wgrywasz plik z dysku (JPG, PNG, GIF).
    - **HTML:** Mozna dodać bardziej zaawansowane banery z interakcjami, animacjami etc. - potrzebny do zaprojektowania tego dev.
5.  Wgraj plik lub wklej kod.
6.  W polu **Destination URL** wpisz adres, na który ma kierować reklama (landing page). Sprawdz czy adres zawiera https:// (a nie http://).
7.  Zapisz zmiany (**Save Changes**).

---

### 4. Zarządzanie miejscami emitowania banerów

Tę konfigurację wykonuje się rzadziej – zazwyczaj raz dla danej strony.

1.  **Inventory > Websites:** Tutaj dodajesz stronę (wpisujesz jej URL i nazwę).
2.  **Inventory > Zones:** Tutaj definiujesz miejsca na wybranej stronie.
    - Wybierz typ (Banner, Rectangle, Popup itp.).
    - Ustal wymiary (np. 300x250).
    - **Ważne:** Jeśli strefa ma wymiar "gwiazdka" (*), przyjmie każdy rozmiar reklamy. Jeśli ma sztywne wymiary (np. 728x90), wyświetli *tylko\* bannery o tym rozmiarze.

---

### 5. Łączenie banerów ze strefami

To moment, w którym reklama "idzie na żywo". Bez tego kroku nic się nie wyświetli.

1.  Będąc w widoku **Kampanii** lub konkretnego **Bannera**, przejdź do zakładki **Linked Zones**.
2.  Zobaczysz listę dostępnych stref na stronach.
3.  Zaznacz strefy, w których ta reklama ma się pojawiać (widoczne tylko te zgodne wymiarami z wybranym banerem).
4.  Kliknij **Save Changes**.

**Targetowanie (Opcjonalne):**
Jeśli reklama ma się wyświetlać tylko w określonych warunkach (np. tylko użytkownikom z Polski/USA, albo tylko 3 razy na użytkownika):

- Wejdź w ustawienia Bannera -> zakładka **Delivery Options**.
- Tu możesz ustawić **Capping** (limit wyświetleń na sesję/użytkownika) oraz reguły geolokalizacji.

---

### 6. Raportowanie (Statystyki)

Aby sprawdzić wyniki kampanii:

1.  Przejdź do zakładki **Statistics**.
2.  Wybierz poziom: Reklamodawcy, Kampanie lub Bannery.
3.  Kluczowe metryki, które zobaczysz:
    - **Requests:** Ile razy strona "poprosiła" o reklamę.
    - **Impressions:** Ile razy reklama faktycznie się załadowała.
    - **Clicks:** Liczba kliknięć.
