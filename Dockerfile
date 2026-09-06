# Firefox web desktop (jlesage/firefox) wrapped for Railway so the deploy form
# carries no blank required fields and no published-known credential, the
# service honours Railway's injected $PORT, and the profile persists on the
# volume mounted at the real /config (not a literal "/config:rw" directory).
#
# Pinned by digest: jlesage/firefox, Firefox 151.0.3, pushed 2026-08-26.
FROM jlesage/firefox@sha256:193ef860a97b161f5f92dde0476550673e9905a6eaf12f376fd1f059068ab45b

# Baked defaults. templateGenerate drops literal defaultValues (they publish as
# blank required fields), so every value that is not a per-deploy secret is set
# here rather than as a template variable. A user-set variable still wins.
#   ENABLE_CJK_FONT      : the leader ships the mangled "ENABLE_CJK_FONTENABLE_CJK_FONT",
#                          so CJK glyphs render as tofu; the correct name is this.
#   WEB_AUTHENTICATION   : real HTTP-layer auth gating the whole web desktop,
#                          not just a raw-VNC password. Railway terminates TLS at
#                          its edge, so the container speaks plain HTTP and web
#                          auth over insecure HTTP is explicitly allowed.
ENV APP_NAME="Firefox" \
    ENABLE_CJK_FONT=1 \
    WEB_AUDIO=1 \
    WEB_FILE_MANAGER=1 \
    WEB_AUTHENTICATION=1 \
    WEB_AUTHENTICATION_ALLOW_INSECURE=1 \
    WEB_AUTHENTICATION_USERNAME=admin

COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

# jlesage sets no ENTRYPOINT and CMD ["/init"] (its s6 supervisor). We prepend a
# thin entrypoint that maps $PORT and validates credentials, then exec /init.
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
CMD ["/init"]
