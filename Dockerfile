# syntax=docker/dockerfile:1
# ---- build the static site ----
FROM python:3.12-slim-bookworm AS site
WORKDIR /site
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY mkdocs.yml ./
COPY docs ./docs
RUN mkdocs build --strict --site-dir /out

# ---- build the static server (stdlib only) ----
FROM golang:1.25-bookworm AS server
WORKDIR /src
COPY server/go.mod ./
COPY server/*.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /server .

# ---- runtime: distroless/static, nonroot (uid 65532), read-only friendly ----
FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=server /server /server
COPY --from=site /out /site
ENV SITE_DIR=/site \
    PORT=8080
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/server"]
