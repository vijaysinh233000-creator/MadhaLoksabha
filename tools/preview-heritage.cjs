const http = require('http');
const fs = require('fs');
const path = require('path');
const {chromium} = require('../cloudflare/worker/node_modules/playwright-core');
const root = path.resolve(__dirname, '../build/web');
const types = {'.js':'application/javascript','.wasm':'application/wasm','.html':'text/html','.png':'image/png','.json':'application/json'};
const server = http.createServer((req,res) => {
  let file = path.join(root, decodeURIComponent(req.url.split('?')[0]));
  if (!file.startsWith(root)) {res.writeHead(403);res.end();return;}
  if (!fs.existsSync(file) || fs.statSync(file).isDirectory()) file=path.join(root,'index.html');
  res.setHeader('Content-Type',types[path.extname(file)] || 'application/octet-stream');
  fs.createReadStream(file).pipe(res);
});
(async()=>{
  await new Promise(resolve=>server.listen(8765,'127.0.0.1',resolve));
  const browser=await chromium.launch({channel:'msedge',headless:true});
  try {
    for(const width of [390,1280]) {
      const page=await browser.newPage({viewport:{width,height:1000}});
      await page.goto('http://127.0.0.1:8765');
      await page.waitForTimeout(12000);
      await page.mouse.move(width/2,650);
      await page.mouse.wheel(0,900);
      await page.waitForTimeout(1800);
      await page.screenshot({path:path.resolve(__dirname,`../heritage-${width}.png`)});
      await page.mouse.wheel(0,500);
      await page.waitForTimeout(1800);
      await page.screenshot({path:path.resolve(__dirname,`../heritage-lower-${width}.png`)});
      await page.mouse.wheel(0,1200);
      await page.waitForTimeout(1800);
      await page.screenshot({path:path.resolve(__dirname,`../heritage-chapters-${width}.png`)});
      await page.close();
    }
    for(const width of [390,1280]) {
      const page=await browser.newPage({viewport:{width,height:1000}});
      await page.goto('http://127.0.0.1:8765/sector/culture');
      await page.waitForTimeout(8000);
      await page.screenshot({path:path.resolve(__dirname,`../sector-culture-${width}.png`)});
      await page.close();
    }
    for(const width of [390,1280]) {
      const page=await browser.newPage({viewport:{width,height:1000}});
      await page.goto('http://127.0.0.1:8765/profile/jaysinh');
      await page.waitForTimeout(8000);
      await page.screenshot({path:path.resolve(__dirname,`../profile-jaysinh-${width}.png`)});
      await page.close();
    }
    for(const width of [390,1280]) {
      const page=await browser.newPage({viewport:{width,height:1000}});
      await page.goto('http://127.0.0.1:8765/sector/water');
      await page.waitForTimeout(8000);
      await page.screenshot({path:path.resolve(__dirname,`../sector-water-${width}.png`)});
      await page.close();
    }
  } finally {await browser.close();server.close();}
})().catch(error=>{console.error(error);server.close();process.exitCode=1;});
