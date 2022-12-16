interface NpmAudit {
  auditReportVersion: 2;
  vulnerabilities: { [key: string]: NpmAuditVulnerability };
}
interface NpmAuditVulnerability {
  name: string;
  severity: "high" | "moderate" | "low" | "info";
  isDirect: boolean;
  range: string;
  fixAvailable: boolean | NpmAuditFixAvailable;
}
interface NpmAuditFixAvailable {
  name: string;
  version: string;
  isSemVerMajor: boolean;
}

// read all input from stdin pipe
process.stdin.resume();
process.stdin.setEncoding("utf8");
const chunks: string[] = [];
process.stdin.on("data", (chunk: string) => {
  chunks.push(chunk);
});

process.stdin.on("end", () => {
  // Parse the chunks as npm audit JSON
  const audit: NpmAudit = JSON.parse(chunks.join(""));
  // Loop through each vulnerability and print a summary
  for (const [name, vulnerability] of Object.entries(audit.vulnerabilities)) {
    console.log(
      [
        name,
        vulnerability.range,
        vulnerability.severity.toUpperCase(),
        vulnerability.fixAvailable ? "fixable" : "",
        vulnerability.isDirect ? "(direct)" : "",
      ].join(" ")
    );
  }
});
