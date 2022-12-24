import { promises as fs } from "fs";
import { JSDOM, VirtualConsole } from "jsdom";

const virtualConsole = new VirtualConsole();

async function reportNoModules(paths) {
  for await (const path of paths) {
    const html = await fs.readFile(path);
    let dom: JSDOM;
    // Parse the HTML. Log error and skip if it fails
    try {
      dom = new JSDOM(html, { includeNodeLocations: true, virtualConsole });
    } catch (e) {
      console.error(`${path}: ${e}`);
      continue;
    }
    for (const script of dom.window.document.querySelectorAll("script")) {
      // <script type="text/javascript"> or <script> without type are non-module scripts.
      // Ignore <script type="text/html">, etc. They're not scripts.
      const nonModuleScript = script.type === "text/javascript" || !script.type;
      // Ignore external scripts. Developers can't control them.
      const externalSource = script.src?.match(/^https?:\/\//);
      if (nonModuleScript && !externalSource) {
        // Print the line number and script with attributes
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
