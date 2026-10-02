export default {
  async fetch(request, env) {
    const requested = new URL(request.url);

    // Keep the browser on one origin while the API remains an independently
    // deployed Worker. The service binding forwards the original request,
    // including the administrator's Authorization header and streamed PDF
    // upload body, without exposing a second public API URL to the app.
    if (
      requested.pathname === "/api" ||
      requested.pathname.startsWith("/api/") ||
      requested.pathname === "/pdf" ||
      requested.pathname.startsWith("/pdf/")
    ) {
      return env.API.fetch(request);
    }

    // Stable public image endpoint for rich WhatsApp/social previews. The
    // Flutter build places the source image under its generated assets path.
    if (requested.pathname === "/share/dhairysheel-mohite-patil.jpg") {
      requested.pathname = "/assets/assets/images/madha_loksabha_banner.jpg";
      return env.ASSETS.fetch(new Request(requested, request));
    }

    if (["/pdf-viewer", "/pdf-viewer/", "/print-slip", "/print-slip/"].includes(requested.pathname)) {
      requested.pathname = requested.pathname.startsWith("/print-slip") ? "/print-slip/" : "/pdf-viewer/";
      return env.ASSETS.fetch(new Request(requested, request));
    }
    const lastSegment = requested.pathname.split("/").pop() || "";
    if (request.method === "GET" && requested.pathname !== "/" && !lastSegment.includes(".")) {
      requested.pathname = "/";
      return env.ASSETS.fetch(new Request(requested, request));
    }

    const response = await env.ASSETS.fetch(request);
    if (response.status !== 404 || request.method !== "GET") return response;

    const url = new URL(request.url);
    url.pathname = "/";
    return env.ASSETS.fetch(new Request(url, request));
  },
};
