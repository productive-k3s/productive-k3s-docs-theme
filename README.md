# Productive K3S Docs Theme

Shared MkDocs theme layer for the Productive K3S repositories.

This repository is the source of truth for the visual and structural parts that should remain consistent across documentation sites, such as:

- shared `main.html` theme extension;
- shared header and footer partials;
- shared logo partial;
- shared table-of-contents partial;
- shared CSS styling;
- shared branding assets used by the sites.

## Intended usage

MkDocs supports a single `theme.custom_dir` per site.

Because the Productive K3S repositories still keep some repo-specific overrides such as `home.html`, `tabs.html`, and `path.html`, the simplest stable integration is:

1. keep repo-specific overrides inside each repository;
2. sync the shared files from this repository into those local override folders before `mkdocs build` or `mkdocs serve`.

That approach preserves:

- shared header/footer styling and structure;
- local navigation and page composition where needed;
- working local builds from `make docs-build` and `make docs-up`.

## Validation

This repository includes a dedicated validation MkDocs site so the shared overrides can be validated in isolation.

```bash
make validate
```

That command:

- checks that the expected theme files and branding assets exist;
- creates a local virtualenv;
- builds the validation site with MkDocs Material in strict mode.

## Technical Notes

This repository currently includes:

- shared Material overrides under `material-overrides/`;
- shared branding assets used by consuming repositories;
- a local `Makefile` for validation and tagging;
- a GitHub Actions workflow that runs `make validate` on `push` to `main` and on pull requests;
- semantic versioning through plain tags such as `0.1.0`, without a `v` prefix;
- a dedicated validation site used as a build fixture for the shared theme.

## Versioning

Use plain semantic tags without a `v` prefix.

Examples:

- `0.1.0`
- `0.2.0`

Suggested release flow:

```bash
make validate
make tag VERSION=0.1.0
make push-tag VERSION=0.1.0
```

## Layout

```text
.
├── .github/workflows/
├── validation-site/
├── Makefile
├── requirements.txt
└── material-overrides/
```

Core theme files:

```text
material-overrides/
├── main.html
├── assets/
│   ├── images/
│   └── stylesheets/
├── partials/
│   ├── footer.html
│   ├── header.html
│   ├── logo.html
│   └── toc.html
```
