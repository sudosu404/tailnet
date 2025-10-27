# :brain: Tailnet Labs — "Where Caddy Meets Tailscale and Chaos Ensues" :unicorn:

[![status: experimental](https://img.shields.io/badge/status-chaotic-red)](https://tailscale.com/kb/1167/release-stages/#experimental)  
*"It works on my machine™" – you, probably.*

---

## :rocket: What is This?

So you like **Caddy**, and you like **Tailscale**, but you hate the idea of *running two things*?  
Say no more, brave sysadmin — **this plugin shoves a full Tailscale node right inside Caddy**.  
Yes, you heard that right. One binary to rule your tailnet, serve your sites, and occasionally confuse you. :mage:

With **Tailnet Labs**, you can:
- :fire: Serve sites directly on your **Tailnet**
- :detective: Proxy requests between Tailscale nodes (yes, through the magic tunnel)
- :lock: Authenticate users by their Tailscale identity
- :whale: Run the whole circus inside Docker, because of course you can

*(Caution: extremely experimental. Side effects may include enlightenment, panic, or both.)*

---

## :toolbox: Requirements

- :onion: [Tailscale](https://tailscale.com/download) installed  
  (*Or not, if you like living dangerously with the built-in version.*)
- :whale2: Docker, obviously.  
- :technologist: A DevContainer-compatible editor, so your AI assistant can silently judge your YAML.

---

## :checkered_flag: Getting Started (a.k.a. The Fun Part)

Clone it, pray a little, and run:

```bash
docker compose up -d
```

Boom :boom: — your Tailnet proxy is alive.

If you forget to set your `TS_AUTHKEY`, don’t worry:  
we’ll just name your node something like `tailnet.gnx` and hope for the best.  
*(Nothing could possibly go wrong.)*

You can also manually run Caddy with your Tailscale config like a real hacker:

```bash
TS_AUTHKEY=tskey-auth-XXX ./caddy run -c tsconfig/tailnet-labs.caddyfile
```

If it works, congrats. If not — hey, you’ve got logs now. :smirk:

---

## :fire: Example Use (a.k.a. Why It’s Kinda Cool)

Want to serve a private site on your tailnet?  
Just slap this into your `Caddyfile`:

```caddyfile
:443 {
  bind tailscale/myhost
  tls {
    get_certificate tailscale
  }
  reverse_proxy localhost:8080
}
```

That’s it. HTTPS handled, access control automatic,  
and your friends on the tailnet can now see your glorious HTML mistakes.

---

## :whale2: Docker Quickie

Because we know you’ll just skip to this part anyway:

```bash
docker run -it --rm   -e TS_AUTHKEY="tskey-auth-XXX"   -v ./Caddyfile:/etc/caddy/Caddyfile   -v ./config:/config   ghcr.io/sudosu404/tailnet-proxy
```

This launches Caddy + Tailscale + good vibes.  
Mount `/config` if you want persistence — or don’t, and watch it vanish like your motivation on a Monday.

---

## :gear: Build It Yourself (for the true believers)

Feeling adventurous? Compile it manually using [xcaddy](https://github.com/caddyserver/xcaddy):

```bash
xcaddy build v2.9.1 --with github.com/sudosu404/tailnet-proxy
```

Or go the full “mad scientist” route:

```bash
go build ./cmd/caddy
```

Then whisper softly to your binary:  
> “Please don’t segfault.”

---

## :mag: Debugging (or Accepting Your Fate)

Logs live under the `tailscale` logger in Caddy.  
Turn up the heat with:

```caddyfile
{
  log tailscale {
    level DEBUG
  }
}
```

Expect approximately **400 lines per second** of “totally helpful” output.

---

## :smile: TL;DR

| You want to…                        | You should…                                           |
|------------------------------------|-------------------------------------------------------|
| Serve private sites on your tailnet | `bind tailscale/myapp` in your Caddyfile              |
| Proxy to another node               | Use `transport tailscale <node>`                      |
| Authenticate via Tailscale          | Drop `tailscale_auth` in your site block              |
| Pretend you know what you’re doing  | `docker compose up -d` and post it on LinkedIn        |

---

## :test_tube: Experimental Disclaimer

This project is *alpha, beta, gamma*, and probably **a cosmic experiment**.  
If it breaks, you get to keep both pieces.

> “It’s not a bug, it’s a distributed feature.”  
> — someone at Tailnet Labs, probably.

---

## :smile: Contribute

Fork it, break it, PR it.  
We welcome chaos as long as it compiles.

---

## :parrot: License

AGPL-3.0 — because sharing is caring (and slightly legally enforced).  

---

Made with :heart:, and at least 2 cups of coffee by [Tailnet Labs](https://github.com/sudosu404/).