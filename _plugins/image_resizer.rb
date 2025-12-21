# Jekyll Image Resizer Plugin
# Automatically resizes film images to max-width 1200px during build
# Requires: image_processing gem (which requires vips or ImageMagick)
# 
# Usage: Add to _config.yml:
#   image_resize:
#     enabled: true
#     max_width: 1200
#
# Note: Uses Jekyll Hook to run after static files are copied to _site
# This ensures resized images are not overwritten by original files

module Jekyll
  class ImageResizer
    def self.process_images(site)
      # Check if image resizing is enabled
      image_config = site.config['image_resize'] || {}
      return unless image_config['enabled'] != false
      
      max_width = image_config['max_width'] || 1200
      source_dir = File.join(site.source, 'assets/images/films')
      
      return unless Dir.exist?(source_dir)
      
      # Destination directory in _site (static files already copied here)
      dest_dir = File.join(site.dest, 'assets/images/films')
      FileUtils.mkdir_p(dest_dir) unless Dir.exist?(dest_dir)
      
      # Process images from source, but write to destination (overwriting copied static files)
      
      # Supported image formats
      image_extensions = %w[.jpg .jpeg .png .JPG .JPEG .PNG .webp .WEBP]
      
      resized_count = 0
      skipped_count = 0
      error_count = 0
      
      # Try to load image processing library
      image_processor_available = false
      processor_type = nil
      
      # Try vips first
      begin
        require 'image_processing/vips'
        require 'vips'
        # Test if vips library is actually available
        # Just check if Vips module is defined, don't try to open a file
        if defined?(Vips) && Vips.respond_to?(:get_suffixes)
          image_processor_available = true
          processor_type = :vips
          Jekyll.logger.info "ImageResizer:", "Using image_processing/vips for image resizing"
        else
          raise "Vips module not properly initialized"
        end
      rescue LoadError, StandardError => e
        # vips not available, try mini_magick
        begin
          require 'image_processing/mini_magick'
          require 'mini_magick'
          # Test if ImageMagick CLI is actually available by checking if convert/identify commands exist
          # We'll test during actual image processing, but log that we're using mini_magick
          image_processor_available = true
          processor_type = :mini_magick
          Jekyll.logger.info "ImageResizer:", "Using image_processing/mini_magick for image resizing"
          if !e.is_a?(LoadError)
            Jekyll.logger.debug "ImageResizer:", "vips failed: #{e.class} - #{e.message}, falling back to mini_magick"
          end
        rescue LoadError
          Jekyll.logger.warn "ImageResizer:", "image_processing gem not available."
          Jekyll.logger.warn "ImageResizer:", "Install with: gem install image_processing"
          Jekyll.logger.warn "ImageResizer:", "Also install either: libvips (brew install vips) or ImageMagick (brew install imagemagick)"
          Jekyll.logger.warn "ImageResizer:", "Falling back to copying original images without resizing."
        end
      end
      
      Dir.glob(File.join(source_dir, '*')).each do |image_path|
        next unless File.file?(image_path)
        
        ext = File.extname(image_path)
        next unless image_extensions.include?(ext)
        
        filename = File.basename(image_path)
        dest_path = File.join(dest_dir, filename)
        
        begin
          if image_processor_available
            # Get original image dimensions using image_processing
            original_width = nil
            begin
              if processor_type == :vips
                require 'vips'
                original = Vips::Image.new_from_file(image_path)
                original_width = original.width
              elsif processor_type == :mini_magick
                require 'mini_magick'
                begin
                  image = MiniMagick::Image.open(image_path)
                  original_width = image.width
                rescue => magick_error
                  # ImageMagick CLI error (e.g., executable not found)
                  Jekyll.logger.warn "ImageResizer:", "ImageMagick CLI error for #{filename}: #{magick_error.message}"
                  raise magick_error # Re-raise to trigger fallback
                end
              end
            rescue => dim_error
              Jekyll.logger.warn "ImageResizer:", "Could not get dimensions for #{filename}, will resize anyway: #{dim_error.message}"
            end
            
            # Only resize if image is wider than max_width (or if we couldn't get dimensions)
            if original_width.nil? || original_width > max_width
              # Resize image
              if processor_type == :vips
                ImageProcessing::Vips
                  .source(image_path)
                  .resize_to_limit(max_width, nil)
                  .call(destination: dest_path)
              elsif processor_type == :mini_magick
                begin
                  ImageProcessing::MiniMagick
                    .source(image_path)
                    .resize_to_limit(max_width, nil)
                    .call(destination: dest_path)
                rescue => magick_error
                  # ImageMagick CLI error (e.g., executable not found: "identify", "convert")
                  Jekyll.logger.error "ImageResizer:", "ImageMagick CLI error while resizing #{filename}: #{magick_error.message}"
                  raise magick_error # Re-raise to trigger fallback copy
                end
              end
              
              if original_width
                resized_count += 1
                Jekyll.logger.info "ImageResizer:", "Resized #{filename} (#{original_width}px -> #{max_width}px)"
              else
                resized_count += 1
                Jekyll.logger.info "ImageResizer:", "Resized #{filename} (max-width: #{max_width}px)"
              end
            else
              # Copy original if it's already small enough
              FileUtils.cp(image_path, dest_path) unless File.exist?(dest_path) && File.mtime(dest_path) >= File.mtime(image_path)
              skipped_count += 1
              Jekyll.logger.debug "ImageResizer:", "Skipped #{filename} (already #{original_width}px <= #{max_width}px)"
            end
          else
            # Fallback: just copy the original image
            FileUtils.cp(image_path, dest_path) unless File.exist?(dest_path) && File.mtime(dest_path) >= File.mtime(image_path)
            skipped_count += 1
          end
        rescue => e
          Jekyll.logger.error "ImageResizer:", "Failed to process #{filename}: #{e.message}"
          # Fallback: copy original image
          begin
            FileUtils.cp(image_path, dest_path) unless File.exist?(dest_path)
            error_count += 1
          rescue => copy_error
            Jekyll.logger.error "ImageResizer:", "Failed to copy #{filename}: #{copy_error.message}"
          end
        end
      end
      
      if resized_count > 0 || skipped_count > 0 || error_count > 0
        Jekyll.logger.info "ImageResizer:", "Processed images: #{resized_count} resized, #{skipped_count} copied, #{error_count} errors"
      end
    end
  end

  # Register hook to run after site is written (after static files are copied)
  Hooks.register(:site, :post_write) do |site|
    ImageResizer.process_images(site)
  end
end


