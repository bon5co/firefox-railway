# firefox-railway

A thin wrapper over [`jlesage/firefox`](https://github.com/jlesage/docker-firefox)
that makes it deploy correctly on [Railway](https://railway.com):

- **Honours Railway's injected `$PORT`.** jlesage's web server reads
  `WEB_LISTENING_PORT`; the entrypoint maps `$PORT` onto it so Railway's HTTP
  healthcheck (which dials the injected port) passes.
- **No published-known credential.** Web authentication is on by default and the
  web-auth password and VNC password are per-deploy secrets, refusing to boot if
  either is empty — instead of a `Change-Password-Here` literal anyone can read.
- **Profile persists.** The Railway volume is mounted at the real `/config`, so
  the Firefox profile (bookmarks, saved logins, cookies, extensions, downloads)
  survives a redeploy.
- **CJK fonts on** via the correctly-spelled `ENABLE_CJK_FONT=1`.

Pinned to `jlesage/firefox` digest `sha256:193ef86…` (Firefox 151.0.3).
Published to `ghcr.io/bon5co/firefox-railway`.
