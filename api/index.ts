import login from "./login.ts";

Bun.serve({
  development: true,
    fetch(req) {
      const url = new URL(req.url);
      if (url.pathname === "/") return login(req);
      return new Response("404!");
    },
});