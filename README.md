# SEFS Lab website

This is a plain HTML/CSS rebuild of the SEFS Lab website. There is no build step, no
templating engine, and no config files to learn — every page is a single `.html` file
you can open and edit directly. One shared stylesheet (`css/style.css`) controls the
look of the whole site.

## Structure

```
site/
├── index.html            Homepage
├── research.html         Research themes
├── news.html              News posts
├── people.html             People
├── workshops.html           Workshops & webinars
├── publications.html         Publications
├── books.html                 Books
├── software.html               Software
├── teaching.html                 Teaching
├── opportunities.html             Open positions & contact
├── css/
│   └── style.css          One shared stylesheet — colors, fonts, layout all live here
├── images/
│   ├── people/             Headshots
│   ├── news/                 News post images
│   ├── research/               Research theme figures
│   ├── books/                   Book covers
│   └── software/                  Package hex logos
└── files/
    ├── Doser_CV.pdf
    ├── pubs/                  Publication PDFs hosted locally
    ├── spoccupancy-web/        Pre-built spOccupancy package documentation site
    └── spabundance-web/         Pre-built spAbundance package documentation site
```

There are no hidden files elsewhere — what you see is what gets deployed.

## Editing an existing page

Open the relevant `.html` file in any text editor (VS Code, etc.) and edit the text
directly. Each page is plain HTML: headings are `<h1>`/`<h2>`/`<h3>`, paragraphs are
`<p>...</p>`, links are `<a href="...">...</a>`, images are `<img src="...">`.

You do not need to touch `css/style.css` for routine content edits — only edit it if
you want to change colors, fonts, or spacing site-wide.

## Adding a new news post

Open `news.html` and copy one existing post block (everything from `<div class="card"`
or `<div class="card no-image"` down to the matching `</div>`), paste it at the top of
the list (most recent first), and edit the title, date, and body text. If the post has
a photo, put the image file in `images/news/` and point `src="images/news/your-file.jpg"`
at it; if not, use the `card no-image` version (see existing examples like the Alexa
and Darius post).

If you want the post to also show on the homepage, do the same thing in `index.html`
under the `<h2>News</h2>` section, and remove the oldest of the three homepage entries
to keep it at three.

## Adding a new publication

Open `publications.html`. Copy one `<div class="pub" id="...">...</div>` block, paste
it under the correct year heading (`<p class="pub-year">2026</p>`, etc. — add a new year
heading if needed), and edit title, authors, venue, and links. Give it a unique `id`
(lowercase, no spaces) if you want to be able to link to it from other pages, e.g. from
a news post.

**Publication numbers:** each entry has a `<div class="pub-title-row">` with a
`<span class="pub-number">N.</span>` before the title. These numbers count up from 1 at
the oldest paper (bottom of the page) to the total count at the newest (top). They are
typed directly into the HTML, not generated automatically, so when you add a new paper
at the top of the list you'll need to bump every number above it by one. If that gets
tedious, it's fine to leave gaps or renumber in a batch every so often — the numbers are
cosmetic and don't need to be perfect between edits.

## Link styling

All links are bold and underlined by default (see `a { ... }` near the top of
`css/style.css`) so they're easy to spot in body text. On the Publications, Software,
and Workshops pages, the PDF/Code/Materials links use a `pub-links` or `software-links`
wrapper class that renders them as small pill-shaped buttons instead — if you add new
link groups in that style elsewhere, wrap them in a `<p class="pub-links">` the same way.

## Homepage section bands

`index.html` is structured differently from the other pages: instead of one `<main>`,
it uses `<main class="home">` containing a few full-width `<section class="home-section
home-XXX">` bands (hero, research, news) with alternating background colors, each with
an inner `<div class="home-section-inner">` that keeps the text readable-width. If you
add a new homepage section, copy this same `home-section` / `home-section-inner` pattern
rather than adding content straight into `<main>`.

## Adding a new software package

`software.html` also uses `<main class="wide">` (a slightly wider page than the default,
so three hex-logo tiles can sit side by side). Each package is a `<div class="software-tile">`
containing a linked hex logo image, a heading, **one short sentence** describing the
package, and a `<p class="software-links">` row of Docs/GitHub/CRAN pill links. Copy an
existing tile to add a new package, and drop its hex logo image in `images/software/`.
Keep the description to one sentence — that's a deliberate style choice to match the
tile format; put any longer description on the package's own documentation site instead.

## Adding a new book

`books.html` uses a `<div class="book">` with the cover image (`.book-cover`, inside a
`.book-cover-link`) on the left and a `.book-body` with title/authors/description/links
on the right. The cover gets an automatic drop shadow from the `.book-cover` CSS class —
you don't need to add any styling to the image tag itself, just point `src` at the cover
file in `images/books/`. Copy the existing `.book` block to add a second book.

## Adding a new person

Open `people.html`, copy one `<div class="person">...</div>` block under the right
group heading (Principal Investigator / Current Lab Members / Alumni), and edit the
name, role, education, and bio. Put their photo in `images/people/`.

When someone leaves the lab, move their block from "Current Lab Members" to "Alumni."

## Colors and fonts

All design variables are at the top of `css/style.css` in the `:root { ... }` block:

```css
--color-bg: #fafaf7;        /* page background */
--color-text: #1f2320;      /* body text */
--color-accent: #2f5233;    /* green accent — links, headings highlight */
--color-nav-bg: #7a1014;    /* nav bar background — NC State red */
--color-nav-text: #f5ece4;  /* nav bar text */
```

Change a value here and it updates everywhere on the site — no need to hunt through
individual pages.

## Known follow-ups

- **rFIA documentation site** — if not already done, copy your `static/rFIA/` folder
  from the old repo into `files/rfia/` so the link from the Software page works.
- **FOR875 textbook** — if you still want it linked from the Teaching page, copy
  `static/for875/_book/` from the old repo into `files/for875/_book/`.
- **Duplicate publication IDs** — in the "In review" section of `publications.html`,
  two `id` attributes are reused (`dkasg25` appears twice, `fbdi23` appears twice).
  This doesn't break anything visually since nothing currently links to those specific
  anchors, but if you want to link to one of those papers from elsewhere later, give
  each a unique `id` first.

## Deploying (Netlify)

Since the site is already hosted on Netlify pointed at your GitHub repo, deployment is
simpler than before:

1. Replace the contents of your repo with this `site/` folder's contents (commit the
   whole thing — there's no `public/` build output to gitignore anymore).
2. In Netlify's site settings → Build & deploy → Build settings, clear out the **build
   command** (leave it blank) and set the **publish directory** to the repo root (`/` or
   `.`, depending on where you put the files).
3. Push to GitHub. Netlify will redeploy automatically on every push — there's no Hugo
   build step running anymore, so deploys will be close to instant.

If you'd rather keep the site in a subfolder of the repo, just point Netlify's publish
directory at that subfolder instead.

## Local preview

No build step means no local server is required — just open `index.html` directly in
a browser to preview your changes. (A couple of browsers restrict `file://` access to
other local files in stricter ways; if images don't load locally, run any simple local
server from the site folder, e.g. `python3 -m http.server`, then visit
`http://localhost:8000`.)
