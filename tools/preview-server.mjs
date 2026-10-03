// Serves the Flutter web build (build/web) so the v0 preview can display the app.
// Production is still deployed to Cloudflare; this file is only for previewing UI changes.
import { createServer } from "node:http";
import { existsSync, readFileSync, statSync } from "node:fs";
import { spawn } from "node:child_process";
import { extname, join, normalize } from "node:path";

const root = join(process.cwd(), "build", "web");
const sdkDir = "/vercel/share/flutter-sdk";
const flutterBin = join(sdkDir, "bin", "flutter");
let buildStatus = "ready";

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
  if (existsSync(join(root, "index.html"))) return;
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
const buildPromise = ensureBuild();

createServer(async (req, res) => {
  // Do not let the browser start loading a partially-created Flutter bundle.
  // Otherwise the shell can return HTML for JS/Wasm requests, producing
  // `Unexpected token '<'` and aborted Wasm compilation errors.
  await buildPromise;

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
  res.writeHead(200, {
    "Content-Type": types[extname(file)] || "application/octet-stream",
    "Cache-Control": "no-cache",
  });
  res.end(readFileSync(file));
}).listen(port, "0.0.0.0", () => {
  console.log(`Flutter web preview on http://localhost:${port}`);
});
