# Vernon Miles Kerr's Blog using Jekyll Theme Chirpy


## Installation

Install rbenv and ruby-build to manage ruby versions.

```bash
brew install rbenv ruby-build
```

Run rbenv init and follow the instructions to set up rbenv integration with your shell.

```bash
rbenv init
```

Install specified ruby version for this repo:

```bash
rbenv install $(cat .ruby-version)
```

Run `bundle install` to install the dependencies specified in the Gemfile.

```bash
bundle install
```

## Creating Posts

Write a post by creating a markdown file in the `_posts` directory. The filename should follow the convention `YYYY-MM-DD-title.md`.
Copy the frontmatter from an existing post and fill out the title, date, and any other metadata such as tags and categories.
e.g.
````markdown
---
author: clearkerr
date: 2021-12-23 01:34:54+00:00
slug: mini-review-being-the-ricardos
title: Mini-Review  |  Being the Ricardos
categories:
- Movie Reviews
tags:
- Being the Ricardos
- I Love Lucy
- Television History
---
````

If you want to quickly make a new post file with todays date you can use the shortcut
```
jekyll compose "Title of Post"
```
But this is going to be fairly barebones so you probably want to copy some frontmatter from an existing post (tags, categories, etc.)

Please see the [theme's docs](https://chirpy.cotes.page/posts/write-a-new-post) for more information
on creating new posts. Ignore the theme docs on linking to image assets as we have our own macros
for that described below.
  
### Static file macros (vmk_img, vmk_filepath)

We have two macros for including static files such as images and pdfs for download. Those are respectively: `vmk_img` and `vmk_filepath`.

What these do is to create a URL to the static file directly in the raw github repository. This is
useful for including images in posts and for linking to pdfs for download without requiring those
files be copied into the static directory of the site for every deployment as that would bloat the
github sites generated archive so that every push would create a > 1GB archive.

By placing files in _static and then referencing them through the macros, we can keep the size of
the archive down to a manageable size while still keeping the uploaded files in the same repository.

Example usage:

Create a text link to a pdf file in _static:
```markdown
[Edelbach's Odyssey - PDF Version]({% vmk_filepath 2018/03/edelbachs-odyssey-pdf-version2.pdf %})
```

Show an image that exists in _static inline in a post (This will become an <img> tag in the html):
```markdown
{% vmk_img 2016/08/bullettrain_kyotoscenes_2013_022-1.jpg %}
```

## Running Locally

To test the site locally, run `bundle exec jekyll serve` and navigate to the url shown in the output (on mac you can command click the link which will look something like `Server address: http://127.0.0.1:4000/`)

```bash
jekyll serve
```

## Publishing

Once you're happy with your changes, commit them to the `main` branch and push to github. Github will automatically build and deploy the site.


## License & Copyright

The [Chirpy][chirpy] Jekyll Theme is published under the [MIT][mit] License.  
[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)](https://rubygems.org/gems/jekyll-theme-chirpy)

Blog contents (mainly in `_posts`, `_static`, `_data`) are copyright Vernon Miles Kerr and
[vernonmileskerr.com](https://vernonmileskerr.com).  

[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE

