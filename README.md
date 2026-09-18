# GoSecureShare — 30-Day Evaluation / Trial Package

> **Enterprise Self-Hosted Zero-Knowledge Secret Sharing Platform**  
> **Repository:** [https://github.com/kisa-ops/GSS-trial](https://github.com/kisa-ops/GSS-trial)  
> **Evaluation Period:** 30 Days (Auto-activated upon installation)  
> **Architecture:** 100% Offline Cryptographic Verification (No live license server required)

---

## Quick Start (One-Line Install)

Run the automated installer on a clean server (Ubuntu 20.04+, Debian 11+, or Rocky/RHEL 8+):

```bash
curl -fsSL https://raw.githubusercontent.com/kisa-ops/GSS-trial/main/install.sh | sudo bash
```

> **Zero Credentials Required:**  
> No GitHub Personal Access Token (PAT), user registration, or repository permissions are needed to download and run this trial.

---

## Key Features in Trial

- **Full Enterprise Feature Access:** All core encryption, sharing, recipient link generation, and audit logging features are completely unlocked.
- **Auto-Activation:** The 30-day evaluation clock starts automatically on the date and time of installation.
- **100% Offline & Private:** Operates entirely within your infrastructure without any outbound phone-home network requests.
- **Seamless In-Place Upgrade:** When ready for production, enter your purchased enterprise license key directly in the Admin Console (**Platform Settings → License**) to upgrade instantly without reinstalling.

---

## Default Network Ports

| Service | Protocol | Default Port | Description |
|---|---|---|---|
| **Platform Console** | HTTP / HTTPS | `8181` / `443` | Admin & Sender Management Portal |
| **Recipient Links** | HTTP / HTTPS | `80` / `443` | Public One-Time Secret Retrieval Portal |
| **PostgreSQL** | Internal | `5434` (host) / `5432` | Internal isolated database |

---

## Service Management

After installation at `/opt/gosecureshare`:

```bash
# View stack status
cd /opt/gosecureshare && docker compose ps

# View service logs
docker compose logs -f

# Restart services
docker compose restart
```

---

## Upgrading to a Licensed Version

To transition from the 30-day trial to a perpetual or subscription enterprise license:
1. Log in to the Platform Console as an administrator (`https://<your-server>:8181`).
2. Navigate to **Platform Settings** → **License**.
3. Upload your signed `license.json` file.
4. Your platform will instantly switch from **Trial Mode** to **Licensed Active Mode** with no downtime and all existing secrets intact.
