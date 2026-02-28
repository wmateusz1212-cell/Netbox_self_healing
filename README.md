# 🌐 NetDevOps: Autonomous Self-Healing Network Infrastructure

[![NetDevOps](https://img.shields.io/badge/Network-Automation-blue.svg)](https://github.com/wmateusz1212-cell/Netbox_self_healing)
[![Ansible](https://img.shields.io/badge/Ansible-2.15+-red.svg)](https://www.ansible.com/)
[![NetBox](https://img.shields.io/badge/Source%20of%20Truth-NetBox-green.svg)](https://netbox.dev/)
[![CI/CD](https://img.shields.io/badge/Pipeline-GitHub%20Actions-black.svg)](https://github.com/features/actions)

## 🚀 Executive Summary
This project showcases a production-grade **NetDevOps** ecosystem designed to eliminate manual configuration errors and guarantee 100% network consistency. By adopting an **Infrastructure as Code (IaC)** approach, the platform implements a **Closed-Loop Automation** cycle that autonomously detects, reports, and remediates unauthorized configuration changes (Configuration Drift) in real-time.

Built with **NetBox** as the Single Source of Truth (SSoT) and **Ansible** as the orchestration engine, the system features a robust **Fail-Safe "Dead Man's Switch"** powered by Cisco EEM, ensuring the network remains resilient even under catastrophic management failures.
<img width="1470" height="123" alt="image" src="https://github.com/user-attachments/assets/a43be603-848f-406b-a8ea-447c2371036b" />


---

## 🏗 System Architecture
The platform integrates four critical layers of modern infrastructure management:

1.  **Source of Truth (NetBox):** The authoritative data store for all network intent (IP addressing, device roles, and site metadata).
2.  **Automation Engine (Ansible):** Orchestrates idempotent state enforcement using custom dynamic inventory mapping.
3.  **GitOps Pipeline (GitHub Actions):** Manages the full CI/CD lifecycle, triggering validation and deployment on every commit.
4.  **Edge Intelligence (Cisco EEM):** On-box event-driven scripts providing a final layer of autonomous defense.

---

## 🔥 Key Technical Capabilities

### 1. Dynamic SSoT-Driven Inventory
Gone are the fragile static host files. A Python-based **Dynamic Inventory** engine interfaces directly with the NetBox API to fetch real-time device states. 
*   *Outcome:* Any change in NetBox intent is instantly reflected across the entire automation surface without manual code updates.

### 2. Autonomous Drift Remediation
Leveraging Ansible's state-based logic, the system continuously monitors the running configuration of Cisco IOS devices.
*   **Detection:** Instantly identifies unauthorized manual overrides (e.g., removal of OSPF processes).
*   **Remediation:** Automatically re-provisions missing configuration blocks to align the physical state with the documented intent.

### 3. Fail-Safe "Dead Man's Switch" (Cisco EEM)
To mitigate the risk of accidental lockouts during automation, I engineered a **Cisco Embedded Event Manager (EEM)** safeguard:
*   Devices perform continuous connectivity heartbeats to the Automation Server.
*   If connectivity is lost for 60 seconds, the device autonomously triggers a **rollback to the last-known-good configuration** ().
*   *Innovation:* This ensures the infrastructure remains "self-reachable," allowing Ansible to re-establish control and finish repairs.

### 4. Continuous Validation & ChatOps
Modern networking requires proof of operation. This pipeline includes **Post-Deployment Validation**:
*   Verifies operational states (e.g., OSPF neighbor adjacencies) post-configuration.
*   Provides real-time **ChatOps** alerts via Webhooks, keeping the engineering team informed of all autonomous remediation events.

---

## 🛠 Tech Stack
*   **Networking:** Cisco IOS (Multi-tier Routing & Switching)
*   **SSoT:** NetBox (Containerized via Docker)
*   **Orchestration:** Ansible (cisco.ios collection)
*   **CI/CD:** GitHub Actions with Self-Hosted Runners
*   **Scripting:** Python (API integration), Jinja2, Bash, Cisco EEM

---

## 📖 The NetDevOps Lifecycle
1.  **State Definition:** Update network intent within NetBox.
2.  **Commit & Push:** Deploy automation logic or policy updates to Git.
3.  **CI/CD Execution:** GitHub Actions initiates the pipeline on the local lab environment.
4.  **Policy Enforcement:** Ansible synchronizes the live environment with the intended state.
5.  **Validation:** The system confirms technology health and reports success/remediation.

---

## 📈 Strategic Value
*   **Zero-Deviation Compliance:** Guarantees the live network is always a 1:1 reflection of documentation.
*   **Extreme Resilience:** Minimizes MTTR (Mean Time to Recovery) through autonomous edge-based healing.
*   **Scalable Operations:** Enables consistent management of complex environments through standardized, reusable code.

---
*Authored as a comprehensive demonstration of Advanced Network Automation and DevOps Engineering.*
