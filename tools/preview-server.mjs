// Serves the Flutter web build (build/web) so the v0 preview can display the app.
// Production is still deployed to Cloudflare; this file is only for previewing UI changes.
import { createServer } from "node:http";
import { existsSync, readFileSync, statSync } from "node:fs";
import { spawn } from "node:child_process";
import { extname, join, normalize } from "node:path";

const root = join(process.cwd(), "build", "web");
const sdkDir = "/vercel/share/flutter-sdk";
const flutterBin = join(sdkDir, "bin", "flutter");
const requiredBuildFiles = ["index.html", "flutter_bootstrap.js", "main.dart.js"];
let buildStatus = "starting";
let buildReady = false;

function run(cmd, args, opts = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(cmd, args, { stdio: "inherit", ...opts });
    child.on("exit", (code) => (code === 0 ? resolve() : reject(new Error(`${cmd} exited with ${code}`))));
    child.on("error", reject);
  });
}

// The sandbox can be reset, wiping the SDK and the gitignored build output,
// so install Flutter and rebuild on demand while the server is already listening.
async function ensureBuild() {
  if (requiredBuildFiles.every((fileName) => existsSync(join(root, fileName)))) {
    buildReady = true;
    buildStatus = "ready";
    return;
  }
  try {
    if (!existsSync(flutterBin)) {
      buildStatus = "Installing Flutter SDK (first run only)...";
      console.log(buildStatus);
      await run("git", ["clone", "--depth", "1", "-b", "stable", "https://github.com/flutter/flutter.git", sdkDir]);
    }
    buildStatus = "Building Flutter web app...";
    console.log(buildStatus);
    await run(flutterBin, ["build", "web", "--release"], { env: { ...process.env, CI: "true" } });
    buildStatus = "ready";
    buildReady = true;
    console.log("Flutter web build complete");
  } catch (error) {
    buildStatus = `Build failed: ${error.message}`;
    console.error(buildStatus);
  }
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
void ensureBuild();

createServer(async (req, res) => {
  // Keep the socket responsive while Flutter installs/builds. Serving a
  // partial bundle makes browsers parse the loading HTML as JavaScript and
  // abort Wasm compilation.
  if (!buildReady) {
    res.writeHead(503, {
      "Content-Type": "text/html; charset=utf-8",
      "Cache-Control": "no-store",
      "Retry-After": "5",
    }).end(`<!doctype html><meta http-equiv="refresh" content="5"><body style="font-family:system-ui;background:#111;color:#eee;display:grid;place-items:center;height:100vh;margin:0"><p>${buildStatus} Refreshing...</p></body>`);
    return;
  }

  const urlPath = decodeURIComponent((req.url || "/").split("?")[0]);
  let file = normalize(join(root, urlPath));
  if (!file.startsWith(root)) {
    res.writeHead(403).end();
    return;
  }
  const requestedPath = urlPath === "/" ? "" : urlPath;
  const hasFileExtension = extname(requestedPath) !== "";
  if (!existsSync(file) || statSync(file).isDirectory()) {
    // Only application routes should fall back to Flutter's shell. Returning
    // index.html for a missing JavaScript or font asset causes the browser to
    // report `Unexpected token '<'` when it tries to parse the HTML as code.
    if (hasFileExtension) {
      res.writeHead(404, { "Content-Type": "text/plain; charset=utf-8", "Cache-Control": "no-cache" }).end("Not found");
      return;
    }
    file = join(root, "index.html");
  }
  if (!existsSync(file)) {
    res
      .writeHead(503, { "Content-Type": "text/html; charset=utf-8", "Cache-Control": "no-cache" })
      .end(
        `<!doctype html><meta http-equiv="refresh" content="10"><body style="font-family:system-ui;background:#111;color:#eee;display:flex;align-items:center;justify-content:center;height:100vh;margin:0"><p>${buildStatus === "ready" ? "Preparing preview..." : buildStatus} This page refreshes automatically.</p></body>`,
      );
    return;
  }
  const body = readFileSync(file);
  res.writeHead(200, {
    "Content-Type": types[extname(file)] || "application/octet-stream",
    "Content-Length": body.byteLength,
    "Cache-Control": "no-cache",
    "Accept-Ranges": "bytes",
  });
  if (req.method !== "HEAD") res.end(body);
  else res.end();
}).listen(port, "0.0.0.0", () => {
  console.log(`Flutter web preview on http://localhost:${port}`);
});
