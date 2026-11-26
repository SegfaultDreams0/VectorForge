# Domain validation backlog

Runtime and analytic testing are deferred. There are 300 topic modules across 15 domains. Each test must require its target ModuleScript, invoke its public API, and compare against a known analytic or textbook value using an explicit tolerance. A test that bypasses the module or only checks constants is invalid.

Recommended layout: `tests/<domain>/<Module>.test.lua`.

Before calling the domains production-ready, run the Luau compiler/type checker, all analytic tests, the duplicate-body gate, and the static dependency scan.
