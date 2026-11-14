# Book template

A starting point for a novel written in Markdown and built with [Pandoc](https://pandoc.org/). One repository is one book.

## New book

On GitHub, open this repository’s **Settings** and check **Template repository**.

For each new book, use **Use this template**. That starts a fresh repository of your own. A fork stays attached to this one.

Then:

1. Put the title and your name in `metadata.yaml`.
2. Replace the two sample chapters in `manuscript/` with your own.
3. Keep the outline, world, and character notes in `notes/`. The build reads only `manuscript/`.

## Write

- One chapter per file. The `#` heading is the chapter title.
- Name files so they sort: `01-the-gate.md`, `02-the-count.md`. Zero-pad the numbers.
- A scene break is a line containing `* * *`, with a blank line above and below.
- *Italics* and **bold** work as usual.
- Subfolders are included. Name them so they sort too, for example `01-part/01-chapter.md`.

## Build

Install [Pandoc](https://pandoc.org/installing.html). A PDF also needs XeLaTeX, which comes with [TeX Live](https://www.tug.org/texlive/) or [MiKTeX](https://miktex.org/). An EPUB does not.

From this folder, in PowerShell:

```powershell
.\build.cmd          # EPUB and PDF
.\build.cmd epub
.\build.cmd pdf
```

Finished files land in `output/`. Git ignores that folder.

Pushing `manuscript/` or `metadata.yaml` to `main` runs the same build on GitHub. Download the EPUB and PDF from the workflow run, under **Artifacts**. You can also run the workflow by hand from the **Actions** tab.

## Layout

```
metadata.yaml     title and author
manuscript/       the book, in filename order
notes/            outline, world, characters
build.ps1         calls pandoc
output/           generated EPUB and PDF
```

The paperback PDF is a 6×9 trade book. Change the page size in `build.ps1` if you want something else.
