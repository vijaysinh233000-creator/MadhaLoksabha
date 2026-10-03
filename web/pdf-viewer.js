import * as pdfjsLib from "./pdfjs/pdf.mjs";

pdfjsLib.GlobalWorkerOptions.workerSrc = "./pdfjs/pdf.worker.mjs";

const query = new URLSearchParams(location.search);
const fileUrl = query.get("file") || "";
const requestedPage = Math.max(
  1,
  Number.parseInt(query.get("page") || "1", 10) || 1,
);
const voterId = Number.parseInt(query.get("voter") || "0", 10) || 0;
const canvas = document.querySelector("#pdf-canvas");
const context = canvas.getContext("2d", { alpha: false });
const stage = document.querySelector("#stage");
const loader = document.querySelector("#loader");
const errorBox = document.querySelector("#error");
const status = document.querySelector("#status");
const pageInput = document.querySelector("#page-number");
const pageCount = document.querySelector("#page-count");
const previous = document.querySelector("#previous");
const next = document.querySelector("#next");
const zoomLevel = document.querySelector("#zoom-level");
const download = document.querySelector("#download");
const pageWrap = document.querySelector("#page-wrap");
const voterHighlight = document.querySelector("#voter-highlight");
const focusVoter = document.querySelector("#focus-voter");

let pdf = null;
let pageNumber = requestedPage;
let zoom = 1;
let renderTask = null;
let resizeTimer = null;
let locator = null;
let focusMode = false;

function downloadUrl(url) {
  return url.replace("/pdf/view/", "/pdf/download/");
}

function setLoading(value) {
  loader.classList.toggle("hidden", !value);
  canvas.style.visibility = value ? "hidden" : "visible";
}

function updateControls() {
  pageInput.value = String(pageNumber);
  pageInput.max = String(pdf?.numPages || 1);
  pageCount.textContent = `/ ${pdf?.numPages || "—"}`;
  previous.disabled = !pdf || pageNumber <= 1;
  next.disabled = !pdf || pageNumber >= pdf.numPages;
  zoomLevel.textContent = `${Math.round(zoom * 100)}%`;
  focusVoter.disabled = !locator?.box || locator.page !== pageNumber;
  focusVoter.textContent = focusMode ? "▣" : "◎";
  focusVoter.title = focusMode
    ? "संपूर्ण पान पहा"
    : "मतदारावर लक्ष केंद्रित करा";
  status.textContent = pdf
    ? `पान ${pageNumber} / ${pdf.numPages}${locator?.name ? ` · शोधलेला मतदार: ${locator.name}` : ""}`
    : "PDF उघडत आहे…";
}

function positionHighlight() {
  if (!locator?.box || locator.page !== pageNumber) {
    voterHighlight.hidden = true;
    return;
  }
  const box = locator.box;
  // Keep the marker tightly around the card instead of overshooting the printed
  // field by a wide margin, which makes the same voter appear to drift away
  // from the actual OCR box on dense pages.
  const gap = 4;
  voterHighlight.style.left = `calc(${box.x * 100}% - ${gap}px)`;
  voterHighlight.style.top = `calc(${box.y * 100}% - ${gap}px)`;
  voterHighlight.style.width = `calc(${box.width * 100}% + ${gap * 2}px)`;
  voterHighlight.style.height = `calc(${box.height * 100}% + ${gap * 2}px)`;
  voterHighlight.setAttribute(
    "aria-label",
    `शोधलेला मतदार: ${locator.name || ""}`,
  );
  voterHighlight.hidden = false;
  voterHighlight.style.animation = "none";
  void voterHighlight.offsetWidth;
  voterHighlight.style.animation = "";
}

async function render() {
  if (!pdf) return;
  if (renderTask) renderTask.cancel();
  setLoading(true);
  errorBox.hidden = true;
  try {
    const page = await pdf.getPage(pageNumber);
    const base = page.getViewport({ scale: 1 });
    const available = Math.max(
      280,
      stage.clientWidth - (stage.clientWidth < 500 ? 16 : 32),
    );
    const fitScale = Math.min(2, available / base.width);
    const cssScale = fitScale * zoom;
    const pixelRatio = Math.min(window.devicePixelRatio || 1, 2);
    const viewport = page.getViewport({ scale: cssScale * pixelRatio });
    canvas.width = Math.floor(viewport.width);
    canvas.height = Math.floor(viewport.height);
    canvas.style.width = `${Math.floor(viewport.width / pixelRatio)}px`;
    canvas.style.height = `${Math.floor(viewport.height / pixelRatio)}px`;
    renderTask = page.render({ canvasContext: context, viewport });
    await renderTask.promise;
    renderTask = null;
    stage.scrollTo({ top: 0, left: 0 });
    updateControls();
    positionHighlight();
    setLoading(false);
    if (locator?.page === pageNumber) {
      const top =
        pageWrap.offsetTop +
        voterHighlight.offsetTop +
        voterHighlight.offsetHeight / 2 -
        stage.clientHeight * 0.42;
      const left =
        pageWrap.offsetLeft +
        voterHighlight.offsetLeft +
        voterHighlight.offsetWidth / 2 -
        stage.clientWidth / 2;
      stage.scrollTo({
        top: Math.max(0, top),
        left: Math.max(0, left),
        behavior: "smooth",
      });
    }
  } catch (error) {
    if (error?.name === "RenderingCancelledException") return;
    setLoading(false);
    errorBox.hidden = false;
    errorBox.textContent = `PDF पान उघडता आले नाही. ${error?.message || error}`;
  }
}

function goTo(value) {
  if (!pdf) return;
  pageNumber = Math.min(
    pdf.numPages,
    Math.max(1, Number.parseInt(value, 10) || 1),
  );
  updateControls();
  render();
}

previous.addEventListener("click", () => goTo(pageNumber - 1));
next.addEventListener("click", () => goTo(pageNumber + 1));
pageInput.addEventListener("change", () => goTo(pageInput.value));
pageInput.addEventListener("keydown", (event) => {
  if (event.key === "Enter") goTo(pageInput.value);
});
document.querySelector("#zoom-in").addEventListener("click", () => {
  focusMode = false;
  zoom = Math.min(2.5, zoom + 0.25);
  render();
});
document.querySelector("#zoom-out").addEventListener("click", () => {
  focusMode = false;
  zoom = Math.max(0.5, zoom - 0.25);
  render();
});
focusVoter.addEventListener("click", () => {
  if (!locator?.box || locator.page !== pageNumber) return;
  focusMode = !focusMode;
  zoom = focusMode
    ? Math.min(2.5, Math.max(1, 0.84 / Math.max(locator.box.width, 0.05)))
    : 1;
  render();
});
window.addEventListener("resize", () => {
  clearTimeout(resizeTimer);
  resizeTimer = setTimeout(render, 180);
});

async function start() {
  if (!fileUrl) throw new Error("PDF address is missing.");
  download.href = downloadUrl(fileUrl);
  if (voterId) {
    const apiOrigin = new URL(fileUrl).origin;
    const response = await fetch(`${apiOrigin}/api/voters/${voterId}/locator`);
    if (response.ok) {
      locator = await response.json();
      pageNumber = Math.max(1, Number(locator.page) || requestedPage);
      if (locator?.box?.width) {
        focusMode = true;
        zoom = Math.min(
          2.5,
          Math.max(1, 0.84 / Math.max(locator.box.width, 0.05)),
        );
      }
    }
  }
  const loadingTask = pdfjsLib.getDocument({
    url: fileUrl,
    rangeChunkSize: 262144,
  });
  pdf = await loadingTask.promise;
  pageNumber = Math.min(pageNumber, pdf.numPages);
  updateControls();
  await render();
}

start().catch((error) => {
  setLoading(false);
  errorBox.hidden = false;
  errorBox.textContent = `PDF उघडता आले नाही. ${error?.message || error}`;
  status.textContent = "PDF त्रुटी";
});
