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
# {% vmk_img pirate.mov %}
#
# Output:
# <img src="https://raw.githubusercontent.com/vernonmileskerr/vernonmileskerr.github.io/main/assets/img/vmk.png"/>
# Jekyll plugin.
module Jekyll

  # Returns the path to the specified asset.
  class VmkImageTag < Liquid::Tag
    GITHUB_IMG_ROOT =
      "https://raw.githubusercontent.com/vernonmileskerr/" +
      "vernonmileskerr.github.io/main/assets/vmk_img/"
    @markup = nil

    def initialize(tag_name, markup, tokens)
      # strip leading and trailing spaces
      @markup = markup.strip
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
      if context.registers[:site].config['baseurl'].include? 'github.io'
        img_src = "#{GITHUB_IMG_ROOT}/#{filename}"
      else
        img_src = "#{context.registers[:site].config['baseurl']}/assets/vmk_img/#{filename}"
      end
      # return the img tag
      "<img src=\"#{img_src}\"/>"
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
      if site.config['baseurl'].include? 'github.io'
        return
      end
      system('mkdir -p _site/assets/vmk_img');
      system('rsync --archive --delete _vmk_img/ _site/assets/vmk_img/');
    end
  end
end

Liquid::Template.register_tag('vmk_img', Jekyll::VmkImageTag)