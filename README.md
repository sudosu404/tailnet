<h1 align="center">GnX</h1>

<div align="center">
  <a href="https://github.com/sudosu404/tailnet">
    <img src="https://raw.githubusercontent.com/sudosu404/tailnet/refs/heads/main/.gitea/logo.png" title="Logo" width="128" />
  </a>
</div>

<h2 align="center">🧠 Tailnet Labs — "Where Caddy Meets Tailscale and Chaos Ensues" 🦄</h2>

<p align="center">
  <a href="https://tailscale.com/kb/1167/release-stages/#experimental">
    <img src="https://img.shields.io/badge/status-chaotic-red" alt="status: chaotic" />
  </a><br>
  <em>"It works on my machine™" – you, probably.</em>
</p>

---

This is the upfront setup for the **developer environment** — needed to build, test, and publish the first binaries of Tailnet Labs.  
It currently relies heavily on internal infra, still marked as  
[![status: experimental](https://shields.io/badge/status-experimental-yellow)](https://github.com/sudosu404/tailnet-node).  

We’re merging and compiling several projects under one roof. Because why not?

---

## 🚀 What is This?

So you like **Caddy**, and you like **Tailscale**, but hate *running two things*?  
Say no more — meet **Tailnet**.

This plugin **shoves a full Tailscale node inside Caddy**.  
Yes, you read that right: *one binary to rule your tailnet*, serve your sites, and occasionally confuse you. 🧙‍♂️

With **Tailnet Labs**, you can:
- 🔥 Serve sites directly on your **Tailnet**
- 🕵️ Proxy requests between Tailscale nodes (yes, through the magic tunnel)
- 🔒 Authenticate users via their Tailscale identity
- 🐋 Run everything inside Docker, because of course you can

> ⚠️ *Extremely experimental. Side effects may include enlightenment, panic, or both.*

---

## 🧰 Requirements

- 🧅 [Tailscale](https://tailscale.com/download)  
  *(Or skip it and trust the built-in one — chaos mode.)*
- 🐳 Docker (you knew this was coming)
- 👨‍💻 A DevContainer-compatible editor  
  *(So your AI assistant can silently judge your YAML.)*
- 🔒 Devpod installed

---

## 🏁 Getting Started (a.k.a. The Fun Part)

Example `compose.yml` included.

Clone it, pray a little, and run:

```bash
git clone https://github.com/sudosu404/tailnet.git
cd tailnet && source init.sh
```

Then set your environment:
```bash
echo -e "TAILSCALE_AUTHKEY=tskey-auth-example-own-key\nTAILNET_NAME=your-own.ts.net\nTAILSCALE_HOSTNAME=pve-tty\nSABLIER_PORT=8006" > .env
```

Login to Docker (optional but recommended):
```bash
docker login
```

And finally, lift off 🚀
```bash
docker compose up -d
```

Boom 💥 — your Tailnet proxy is alive.

If you forget your `TAILSCALE_AUTHKEY`, no worries —  
we’ll just name your node `pve-tty.your-tailnet.ts.net` and hope for the best.  
*(What could possibly go wrong?)*

You can also run it manually like a real hacker:
```bash
TAILSCALE_AUTHKEY=tskey-auth-XXX ./caddy run -c tsconfig/tailnet-labs.caddyfile
```

If it works: congrats 🎉  
If not: at least you have logs now 😏

---

## 🔥 Example Usage (Why It’s Kinda Cool)

Want to serve a private site on your Tailnet?  
Drop this into your `Caddyfile`:

```caddyfile
:443 {
  bind tailscale/myhost
  tls {
    get_certificate tailscale
  }
  reverse_proxy localhost:8080
}
```

That’s it — HTTPS handled, access control automatic,  
and your Tailnet friends can now see your glorious HTML mistakes.

---

## 🐳 Docker Quickie

Because we know you’ll skip to this part anyway:

```bash
docker run -it --rm   -e TAILSCALE_AUTHKEY="tskey-auth-XXX"   -v ./Caddyfile:/etc/caddy/Caddyfile   -v ./config:/config   sudosu404/tailnet
```

This launches **Caddy + Tailscale + good vibes**.  
Mount `/config` for persistence — or don’t, and watch your setup vanish like motivation on Monday.

---

## ⚙️ Build It Yourself (for the True Believers)

Using [xcaddy](https://github.com/caddyserver/xcaddy):
```bash
xcaddy build v2.9.1 --with github.com/sudosu404/tailnet
```

Or the full DIY route:
```bash
go build ./cmd/caddy
```

Then whisper to your binary:
> “Please don’t segfault.”

---

## 🔍 Debugging (a.k.a. Accepting Your Fate)

Caddy logs under the `tailscale` logger.  
Crank up verbosity with:

```caddyfile
{
  log tailscale {
    level DEBUG
  }
}
```

Expect approximately **400 lines per second** of “totally helpful” output.

---

## 😎 TL;DR

| You want to…                        | You should…                                           |
|------------------------------------|-------------------------------------------------------|
| Serve private sites on Tailnet     | `bind tailscale/myapp` in your Caddyfile              |
| Proxy to another node              | Use `transport tailscale <node>`                      |
| Authenticate via Tailscale         | Add `tailscale_auth` in your site block               |
| Pretend you know what you’re doing | `docker compose up -d` and post it on LinkedIn        |

---

## 🧪 Experimental Disclaimer

This project is **alpha, beta, gamma**, and probably a **cosmic experiment**.  
If it breaks, you get to keep both pieces.

> “It’s not a bug, it’s a distributed feature.”  
> — someone at Tailnet Labs, probably.

---

## 🤝 Contribute

Fork it, break it, PR it.  
We welcome chaos — as long as it compiles.

---

## 🦜 License

**AGPL-3.0** — because sharing is caring (and legally encouraged).

---

Made with ❤️ and at least ☕☕ by [Tailnet Labs](https://github.com/sudosu404/).