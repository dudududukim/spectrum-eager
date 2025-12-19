# Jekyll Image Resizer Plugin
# Automatically resizes film images to max-width 800px during build
# Requires: image_processing gem (which requires vips or ImageMagick)
# 
# Usage: Add to _config.yml:
#   image_resize:
#     enabled: true
#     max_width: 800

module Jekyll
  class ImageResizer < Generator
    safe true
    priority :low

    def generate(site)
      # Check if image resizing is enabled
      image_config = site.config['image_resize'] || {}
      return unless image_config['enabled'] != false
      
      max_width = image_config['max_width'] || 800
      source_dir = File.join(site.source, 'assets/images/films')
      
      return unless Dir.exist?(source_dir)
      
      # Create destination directory in _site
      dest_dir = File.join(site.dest, 'assets/images/films')
      FileUtils.mkdir_p(dest_dir) unless Dir.exist?(dest_dir)
      
      # Supported image formats
      image_extensions = %w[.jpg .jpeg .png .JPG .JPEG .PNG .webp .WEBP]
      
      resized_count = 0
      skipped_count = 0
      error_count = 0
      
      # Try to load image processing library
      image_processor_available = false
      begin
        require 'image_processing/vips'
        image_processor_available = true
        Jekyll.logger.info "ImageResizer:", "Using image_processing/vips for image resizing"
      rescue LoadError
        begin
          require 'image_processing/mini_magick'
          image_processor_available = true
          Jekyll.logger.info "ImageResizer:", "Using image_processing/mini_magick for image resizing"
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
              if defined?(ImageProcessing::Vips)
                require 'vips'
                original = Vips::Image.new_from_file(image_path)
                original_width = original.width
              elsif defined?(ImageProcessing::MiniMagick)
                require 'mini_magick'
                image = MiniMagick::Image.open(image_path)
                original_width = image.width
              end
            rescue => dim_error
              Jekyll.logger.warn "ImageResizer:", "Could not get dimensions for #{filename}, will resize anyway: #{dim_error.message}"
            end
            
            # Only resize if image is wider than max_width (or if we couldn't get dimensions)
            if original_width.nil? || original_width > max_width
              # Resize image
              if defined?(ImageProcessing::Vips)
                ImageProcessing::Vips
                  .source(image_path)
                  .resize_to_limit(max_width, nil)
                  .call(destination: dest_path)
              elsif defined?(ImageProcessing::MiniMagick)
                ImageProcessing::MiniMagick
                  .source(image_path)
                  .resize_to_limit(max_width, nil)
                  .call(destination: dest_path)
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
end


