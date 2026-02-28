# 🌐 NetDevOps: Self-Healing Network Infrastructure & Source of Truth

[![NetDevOps](https://img.shields.io/badge/Network-Automation-blue.svg)](https://github.com/wmateusz1212-cell/Netbox_self_healing)
[![Ansible](https://img.shields.io/badge/Ansible-2.15+-red.svg)](https://www.ansible.com/)
[![NetBox](https://img.shields.io/badge/Source%20of%20Truth-NetBox-green.svg)](https://netbox.dev/)
[![CI/CD](https://img.shields.io/badge/Pipeline-GitHub%20Actions-black.svg)](https://github.com/features/actions)

## 🚀 O Projekcie
Ten projekt to zaawansowana demonstracja nowoczesnego podejścia **NetDevOps** do zarządzania infrastrukturą sieciową. Zamiast ręcznej konfiguracji przez CLI, sieć jest traktowana jak kod (**Infrastructure as Code**), a jej stan jest wymuszany przez zautomatyzowaną pętlę zwrotną (**Closed-Loop Automation**).

Projekt rozwiązuje krytyczne problemy współczesnych działów IT:
*   **Configuration Drift:** Automatyczne wykrywanie i naprawa ręcznych, nieudokumentowanych zmian.
*   **Single Source of Truth:** NetBox jako jedyne, nadrzędne źródło wiedzy o sieci.
*   **Human Error:** Mechanizm "Dead Man's Switch" chroniący przed odcięciem dostępu do urządzeń.

---

## 🏗 Architektura Systemu
1.  **Source of Truth (NetBox):** Przechowuje pożądany stan sieci (IP, role, urządzenia).
2.  **Automation Engine (Ansible):** Dynamicznie generuje inwentarz z NetBoxa i wdraża konfigurację na urządzenia Cisco IOS.
3.  **GitOps Workflow (GitHub Actions):** Każdy commit wyzwala pipeline sprawdzający spójność sieci.
4.  **Local Runner:** Umożliwia bezpieczną komunikację między chmurą GitHub a fizycznym laboratorium.

---

## 🔥 Kluczowe Funkcjonalności

### 1. Dynamic Inventory & Source of Truth
System nie korzysta ze statycznych list hostów. Skrypt `netbox_inventory.sh` odpytuje API NetBoxa w czasie rzeczywistym, pobierając aktualne adresy IP i role urządzeń. Zmiana w NetBox = automatyczna aktualizacja w Ansible.

### 2. Closed-Loop Automation (Samonaprawa)
Playbook `deploy_lab.yml` monitoruje konfigurację OSPF. Jeśli inżynier wykona `no router ospf 1` poza systemem automatyzacji, Ansible wykryje zmianę (Drift Registration) i w ciągu minut **automatycznie przywróci trasowanie**.

### 3. Network Resiliency (Cisco EEM Safeguard)
Wdrożony mechanizm **Dead Man's Switch** za pomocą Cisco Embedded Event Manager. Urządzenia co 5 minut pingują serwer Ansible. W przypadku utraty łączności (np. błąd w ACL lub OSPF), urządzenie samo przywraca ostatnią dobrą konfigurację z pamięci `startup-config`.

### 4. Post-Deployment Validation
Pipeline nie kończy się na "ok". System wykonuje komendy operacyjne (np. `show ip ospf neighbor`), weryfikując, czy zmiany przyniosły zakładany skutek technologiczny.

---

## 🛠 Stack Technologiczny
*   **Infrastructure:** Cisco IOS (Routers & Switches)
*   **SSoT:** NetBox (Dockerized)
*   **Automation:** Ansible (cisco.ios collection)
*   **CI/CD:** GitHub Actions
*   **Language:** Python, Bash, YAML
*   **Security:** GitHub Secrets (Environment Variable Injection)

---

## 📖 Jak to działa? (The Workflow)
1.  **Zdefiniuj:** Dodaj/zmień parametry urządzenia w NetBoxie.
2.  **Commit:** Wyślij zmiany w playbookach do repozytorium.
3.  **Verify:** GitHub Actions uruchamia pipeline na lokalnym runnerze.
4.  **Enforce:** Ansible synchronizuje stan urządzeń z NetBoxem.
5.  **Alert:** W przypadku wykrycia dryfu (ręcznych zmian), system naprawia sieć i (opcjonalnie) wysyła alert ChatOps.

---

## 📈 Wartość Biznesowa
*   **Redukcja Downtime:** Samonaprawa sieci skraca czas przestojów wywołanych błędami ludzkimi.
*   **Zgodność (Compliance):** Gwarancja, że stan faktyczny sieci jest w 100% zgodny z dokumentacją w NetBoxie.
*   **Skalowalność:** Możliwość zarządzania setkami urządzeń z jednego, scentralizowanego miejsca bez konieczności logowania się na każde z osobna.

---
*Projekt przygotowany jako demonstracja umiejętności z zakresu Automatyzacji Sieci, DevOps oraz Inżynierii Infrastruktury.*
