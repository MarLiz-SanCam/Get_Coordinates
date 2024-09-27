export default function (request: Request): Response {
    console.log(request.url);
    return new Response("Home page!");
}