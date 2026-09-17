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

## Shared header and footer contract

The shared theme owns the common Productive K3S documentation chrome:

- `material-overrides/main.html`;
- `material-overrides/partials/header.html`;
- `material-overrides/partials/footer.html`;
- `material-overrides/partials/logo.html`;
- `material-overrides/partials/toc.html`;
- `material-overrides/assets/stylesheets/extra.css`;
- shared brand assets under `material-overrides/assets/images/`.

Consuming repositories should not fork header or footer behavior for normal
product-site differences. Product identity and copy belong in `mkdocs.yml`,
mostly under `site_name`, `repo_url`, `extra.social`, and `extra.pk3s`.

### Header behavior

The shared header expects:

| Field | Required | Purpose |
| --- | --- | --- |
| `site_name` | yes | Product/site title rendered in the header and logo accessibility text. |
| `repo_url` | no | Enables the Material source/repository link when present. |
| `theme.features` | yes | Controls Material navigation behavior such as `navigation.tabs`, `navigation.tabs.sticky`, and `navigation.footer`. |
| `plugins.search` | no | Enables the shared search button when Material search is configured. |

The header language switch is convention-based:

- pages under `en/` link to the corresponding `es/` path;
- pages under `es/` link to the corresponding `en/` path;
- pages outside those prefixes link to the site root and `?lang=es`.

Repositories that need bilingual switching should keep English and Spanish page
paths aligned. Repositories that are not bilingual still receive a harmless
header; they should not copy a custom header just to remove the switch.

### Footer behavior

Footer product copy is configured through `extra.pk3s`:

| Field | Required | Default |
| --- | --- | --- |
| `footer_slogan_en` | recommended | `site_name` |
| `footer_slogan_es` | recommended | `site_name` |
| `contact_label_en` | optional | `Contact` |
| `contact_label_es` | optional | `Contacto` |
| `newsletter_label_en` | optional | `Newsletter` |
| `newsletter_label_es` | optional | `Newsletter` |
| `newsletter_placeholder_en` | optional | `E-mail` |
| `newsletter_placeholder_es` | optional | `E-mail` |
| `newsletter_api_base_url` | recommended | Productive K3S newsletter Worker fallback |
| `newsletter_success_en` | optional | `Thanks for subscribing.` |
| `newsletter_success_es` | optional | `Gracias por suscribirte.` |
| `newsletter_duplicate_en` | optional | `You are already subscribed.` |
| `newsletter_duplicate_es` | optional | `Ya estabas suscripto.` |
| `newsletter_invalid_en` | optional | `Enter a valid e-mail address.` |
| `newsletter_invalid_es` | optional | `Ingresa un e-mail valido.` |
| `newsletter_error_en` | optional | `Could not submit right now. Please try again.` |
| `newsletter_error_es` | optional | `No se pudo enviar ahora. Intenta nuevamente.` |
| `argentina_credit_en` | optional | `Made in Argentina` |
| `argentina_credit_es` | optional | `Hecho en Argentina` |

The footer also consumes `extra.social` when a site wants social links. Contact
currently renders as a non-navigating shared label; a future contact URL should
be added as a shared `extra.pk3s` field instead of patching individual footers.

### Minimal consuming site example

```yaml
site_name: Productive K3S Example
repo_url: https://github.com/productive-k3s/example

theme:
  name: material
  custom_dir: docs/src/overrides
  features:
    - navigation.tabs
    - navigation.footer

extra_css:
  - assets/stylesheets/extra.css

extra:
  pk3s:
    footer_slogan_en: "Example Productive K3S documentation."
    footer_slogan_es: "Documentacion de ejemplo de Productive K3S."
    newsletter_api_base_url: "https://newsletter.productive-k3s.io"
  social:
    - icon: fontawesome/brands/github
      link: https://github.com/productive-k3s/example
```

### Local override boundary

Consuming repositories may keep repo-specific pages and non-shared overrides
such as `home.html`, `tabs.html`, or `path.html` when needed. They should not
edit synced copies of the shared header, footer, logo, table of contents,
shared CSS, or shared image assets. Changes to those files belong in this
theme repository and should be propagated by each repository's
`docs/sync-shared-theme.sh`.

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
