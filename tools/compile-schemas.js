#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const fg = require('fast-glob');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');

function readJson(p) {
  return JSON.parse(fs.readFileSync(p, 'utf8'));
}

function uniq(arr) { return Array.from(new Set(arr)); }

async function main() {
  const repoRoot = process.cwd();
  const cfgPath = path.join(repoRoot, 'schema', 'schema-compile.config.json');
  if (!fs.existsSync(cfgPath)) {
    console.error('Config not found:', cfgPath);
    process.exit(1);
  }
  const cfg = readJson(cfgPath);

  // Build file list from folders + include patterns
  const includeGlobs = [];
  for (const key of Object.keys(cfg.folders)) {
    includeGlobs.push(path.join(cfg.folders[key], '**/*.json'));
  }
  for (const extra of cfg.include || []) {
    includeGlobs.push(extra);
  }
  const excludeGlobs = cfg.exclude || [];

  const files = uniq(await fg(includeGlobs, { cwd: repoRoot, ignore: excludeGlobs, absolute: true }));
  if (files.length === 0) {
    console.error('No schema files found to compile.');
    process.exit(1);
  }

  const ajv = new Ajv({ strict: false, allErrors: true });
  addFormats(ajv);

  const schemas = [];
  const problems = [];

  // Load schemas and register with Ajv
  for (const f of files) {
    try {
      const schema = readJson(f);
      const sid = schema.$id;
      if (!sid) {
        problems.push({ file: f, error: 'Missing $id' });
        continue;
      }
      schemas.push({ id: sid, file: f, schema });
      ajv.addSchema(schema, sid);
    } catch (e) {
      problems.push({ file: f, error: `Parse error: ${e.message}` });
    }
  }

  // Attempt to compile each loaded schema
  const compileErrors = [];
  for (const s of schemas) {
    try {
      ajv.compile(s.schema);
    } catch (e) {
      compileErrors.push({ id: s.id, file: s.file, error: e.message });
    }
  }

  // Report
  if (problems.length || compileErrors.length) {
    console.log('Schema compile finished with issues.');
    if (problems.length) {
      console.log('\nProblems (missing $id / parse):');
      for (const p of problems) console.log('-', p.file, '=>', p.error);
    }
    if (compileErrors.length) {
      console.log('\nCompile errors:');
      for (const c of compileErrors) console.log('-', c.file, `(${c.id}) =>`, c.error);
    }
    process.exit(2);
  }

  console.log(`OK: Compiled ${schemas.length} schemas with no unresolved refs.`);
}

main().catch(err => { console.error(err); process.exit(1); });

