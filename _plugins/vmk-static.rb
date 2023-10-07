# frozen_string_literal: true

# Title: Image tag for VMK blog images so that they can be hotlinked to
# https://raw.githubusercontent.com/... instead of copied as part of the static site bundle as that
# would be too much data to copy on every build.
#
# Description: Output an img tag with the correct path for a VMK blog image. During local development
# the image is loaded from the local file system. On GitHub Pages the image is loaded from the
# GitHub repository's master branch via a raw.githubusercontent.com URL.
#
# Syntax
#    {% vmk_img filename %}
#    {% vmk_img "filename with whitespace" %}
#
# Examples:
# {% vmk_img vmk.png %}
#
# Output:
# <img src="https://raw.githubusercontent.com/vernonmileskerr/vernonmileskerr.github.io/main/_static/vmk.png"/>

# Examples:
# {% vmk_filepath vmk.pdf %}
#
# Output:
# https://raw.githubusercontent.com/vernonmileskerr/vernonmileskerr.github.io/main/_static/vmk.pdf
# Jekyll plugin.
module Jekyll
  # If LOCAL_IN_DEV is true it will do an expensive rsync to set up the local copy of the assets
  # directory. It's not recommended however. Instead just pre-submit images in _static on the
  # main branch before referencing them. The images will be hotlinked to the github main branch
  # as they are in production.
  LOCAL_IN_DEV = false

  # Returns the path to the specified asset.
  class VmkImageTag < Liquid::Tag
    GITHUB_IMG_ROOT =
      "https://raw.githubusercontent.com/vernonmileskerr/" +
      "vernonmileskerr.github.io/main/_static/"
    @markup = nil
    @tag = nil

    def initialize(tag_name, markup, tokens)
      # strip leading and trailing spaces
      @markup = markup.strip
      @tag = tag_name
      super
    end

    def render(context)
      if @markup.empty?
        return 'Error processing input, expected syntax: ' \
               '{% vmk_img [filename relative to vmk_imgs]  %}'
      end

      # render the markup
      filename = parse_parameters context

      # If base url includes github.io, then we are on GitHub Pages and should use the raw
      # url.
      if Jekyll.env == "production" or LOCAL_IN_DEV == false
        # remove leading slash from filename if it exists
        filename = filename[1..] if filename.start_with? '/'
        file_src = "#{GITHUB_IMG_ROOT}/#{filename}"
      else
        file_src = "#{context.registers[:site].config['baseurl']}/assets/_static/#{filename}"
      end
      # return the img tag
      if @tag == 'vmk_img'
        return "<img src=\"#{file_src}\"/>"
      else
        return file_src
      end
    end

    private

    def parse_parameters(context)
      parameters = Liquid::Template.parse(@markup).render context
      parameters.strip!

      if ['"', "'"].include? parameters[0]
        # Quoted filename
        last_quote_index = parameters.rindex(parameters[0])
        filename = parameters[1...last_quote_index]
        return filename
      end
      # Unquoted filename
      parameters.split(/\s+/)[0]
    end
  end

  class RsyncImageGenerator < Generator
    def generate(site)
      if Jekyll.env == "production" or LOCAL_IN_DEV == false
        if LOCAL_IN_DEV == false
          puts "Skipping rsync of local images."
          puts "Any changes to images should be submitted first or they will not show up."
        end
        return
      end
      system('mkdir -p _site/assets/_static');
      system('rsync --archive --delete _static/ _site/assets/_static/');
    end
  end
end

Liquid::Template.register_tag('vmk_img', Jekyll::VmkImageTag)
Liquid::Template.register_tag('vmk_filepath', Jekyll::VmkImageTag)
