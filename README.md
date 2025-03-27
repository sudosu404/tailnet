# Tailgate

**An easy-to-deploy [Tailscale](https://tailscale.com/) + [Caddy](https://caddyserver.com/) container with plugins.**

- **Expose** Caddy services through Tailscale for secure, private connections.
- Optionally run Caddy with **Cloudflare DNS challenges**, or any other [Caddy plugins](https://caddyserver.com/download).
  - Now includes an image with [Sablier](https://sablierapp.dev/) out-of-the-box!

The idea was to make a container that would allow you to simply follow this tutorial: [Remotely access and share your self-hosted services](https://www.youtube.com/watch?v=Vt4PDUXB_fg⁠). I decided to create this project after having trouble with existing solutions. 

The container on [Docker Hub](https://hub.docker.com/r/valentemath/tailgate) is built with the Cloudflare plugin preinstalled, but if you need different plugins, you can build your own image by following the instructions [below](#building-with-other-plugins).

## Getting Started

If you want to use the Cloudflare plugin:

### 1) Pull & Run

See [Environment Variable](#environment-variables) below and set your own values here before running. The only mandatory variable is `TAILSCALE_AUTHKEY`. 

#### With `docker run`


```bash
docker run -d \
  --name tailgate \
  -e TAILSCALE_AUTHKEY=tskey-abc123 \
  -e TAILSCALE_HOSTNAME=tailgate \
  -e TAILNET_NAME=my-tailnet.ts.net \
  -e CLOUDFLARE_API_TOKEN=abc123 \
  -v tailscale-state:/tailscale \
  -v caddy-config:/etc/caddy \
  valentemath/tailgate:latest
```

#### With `docker compose`

```yaml
services:
  tailgate:
    image: valentemath/tailgate:latest
    container_name: tailgate

    environment:
      - TAILSCALE_AUTHKEY=tskey-abc123
      - TAILNET_NAME=my-tailnet.ts.net
      - TAILSCALE_HOSTNAME=tailgate
      - CLOUDFLARE_API_TOKEN=abc123

    volumes:
      - tailscale-state:/tailscale
      - caddy-config:/etc/caddy

volumes:
  tailscale-state:
  caddy-config:
```


### 2) Create a Caddyfile

This container tries to load `/etc/caddy/Caddyfile` at launch, which you can mount at deployment. However, if you do not provide one, you can create one later. Just shell into the container after deployment and use `vim` to create the Caddyfile. **Make sure to put your Caddyfile in `/etc/caddy/` if you want it to persist after restart.** Check out the tutorial in the introduction to help you get started with integrating Tailscale with Caddy in the Caddyfile. 

## Environment Variables

- **TAILSCALE_AUTHKEY**  
  The [auth key](https://tailscale.com/kb/1085/auth-keys/) used to join your Tailnet. Once authenticated, you typically do not need this again (it’s stored in `/tailscale/tailscaled.state`).

- **TAILSCALE_HOSTNAME (optional)**  
  Hostname for your Tailscale node. Defaults to "tailgate."

- **TAILNET_NAME (optional)**
  Your Tailnet name for [MagicDNS](https://tailscale.com/kb/1081/magicdns).

- **CADDY_WATCH (optional)**
  Sets the caddy `--watch` option to automatically reload the configuration when changes are made to the Caddyfile. 

- **CLOUDFLARE_API_TOKEN (optional)**  
  If you’re using the Cloudflare plugin for [ACME challenges](https://caddyserver.com/docs/caddyfile/directives/tls#dns-providers), set your token here. Then in your `Caddyfile` add:
  
  ```
  (cloudflare) {
      tls {
          dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
  }
  yourdomain.com {
      import cloudflare
      # Whatever you want, e.g.
      # reverse_proxy my-server.my-tailnet.ts.net:80
  }
  ```


## Building with Other Plugins

1. **Clone** this repo:
   ```bash
   git clone https://github.com/mr-valente/tailgate.git
   ```

2. Open `docker-compose.yaml`

3. Comment out the `image` tag:
    ```yaml
    # image: valentemath/tailgate:latest
    ```

4. Set the `args/PLUGINS` tag to include whichever plugins you want:
    ```yaml
    args:
        PLUGINS: "github.com/caddy-dns/duckdns github.com/caddy-dns/route53"
    ```

5. Build and run: 
    ```bash
    docker compose up -d --build
    ```

## Notes

I am new to Docker, so this container might be a bit "chubby." It's built on Debian Bookworm and includes some debugging tools that you might find helpful (`ping`, `dig`, and `nslookup`), should any issues arise. As such, any bug reports or pull requests with improvements are most welcome! 

## Thanks

- [Tailscale](https://tailscale.com) for secure, peer-to-peer networking.  
- [Caddy](https://caddyserver.com) for automatic HTTPS and powerful config.  
- Contributors like you!
