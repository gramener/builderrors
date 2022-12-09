import { promises as fs } from "fs";
import { JSDOM, VirtualConsole } from "jsdom";

const virtualConsole = new VirtualConsole();

async function reportNoModules(paths) {
  for await (const path of paths) {
    const html = await fs.readFile(path);
    let dom: JSDOM;
    // Try parsing the HTML. If it fails, skip and log error
    try {
      dom = new JSDOM(html, { includeNodeLocations: true, virtualConsole });
    } catch (e) {
      console.error(`${path}: ${e}`);
      continue;
    }
    // Log <script> with type="text/javascript" or nothing
    for (const script of dom.window.document.querySelectorAll("script")) {
      if (script.type === "text/javascript" || !script.type) {
        const location = dom.nodeLocation(script);
        const attrs = Array.from(script.attributes as NamedNodeMap)
          .map((a) => ` ${a.name}="${a.value.replace(/\s+/gis, " ")}"`)
          .join("");
        console.log(
          `${path}:${location?.startLine}:${location?.startCol}: <script${attrs}>`
        );
      }
    }
  }
}

reportNoModules(process.argv.slice(2));
