// Serves the Flutter web build (build/web) so the v0 preview can display the app.
// Production is still deployed to Cloudflare; this file is only for previewing UI changes.
import { createServer } from "node:http";
import { existsSync, readFileSync, statSync } from "node:fs";
import { execSync } from "node:child_process";
import { extname, join, normalize } from "node:path";

const root = join(process.cwd(), "build", "web");
const flutterBin = "/vercel/share/flutter-sdk/bin/flutter";

if (!existsSync(join(root, "index.html")) && existsSync(flutterBin)) {
  console.log("Building Flutter web...");
  execSync(`${flutterBin} build web --release`, { stdio: "inherit" });
}

const types = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript",
  ".mjs": "text/javascript",
  ".json": "application/json",
  ".css": "text/css",
  ".wasm": "application/wasm",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".svg": "image/svg+xml",
  ".ico": "image/x-icon",
  ".ttf": "font/ttf",
  ".otf": "font/otf",
  ".woff2": "font/woff2",
};

const port = Number(process.env.PORT) || 3000;

createServer((req, res) => {
  const urlPath = decodeURIComponent((req.url || "/").split("?")[0]);
  let file = normalize(join(root, urlPath));
  if (!file.startsWith(root)) {
    res.writeHead(403).end();
    return;
  }
  if (!existsSync(file) || statSync(file).isDirectory()) {
    file = join(root, "index.html");
  }
  if (!existsSync(file)) {
    res.writeHead(503, { "Content-Type": "text/plain" }).end("Flutter web build not found. Run: flutter build web");
    return;
  }
  res.writeHead(200, {
    "Content-Type": types[extname(file)] || "application/octet-stream",
    "Cache-Control": "no-cache",
  });
  res.end(readFileSync(file));
}).listen(port, "0.0.0.0", () => {
  console.log(`Flutter web preview on http://localhost:${port}`);
});
