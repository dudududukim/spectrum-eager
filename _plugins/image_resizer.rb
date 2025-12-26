# Jekyll Image Resizer Plugin
# Automatically resizes images in assets/images/* to max-width 1200px during build
# Requires: image_processing gem (which requires vips or ImageMagick)
# 
# Usage: Add to _config.yml:
#   image_resize:
#     enabled: true
#     max_width: 1200  # Default max width for all directories
#     per_dir:  # Optional: per-directory overrides
#       musics: 800  # musics folder images will be resized to max 800px
#
# Note: Uses Jekyll Hook to run after static files are copied to _site
# This ensures resized images are not overwritten by original files
# Processes all subdirectories under assets/images/ (e.g., films, musics, etc.)

module Jekyll
  class ImageResizer
    def self.process_images(site)
      # Check if image resizing is enabled
      image_config = site.config['image_resize'] || {}
      return unless image_config['enabled'] != false
      
      max_width = image_config['max_width'] || 1200
      base_images_dir = File.join(site.source, 'assets/images')
      
      return unless Dir.exist?(base_images_dir)
      
      # Get list of directories to exclude originals (only deploy resized versions)
      exclude_originals = image_config['exclude_originals'] || []
      
      # Initialize image processor (only once, reuse for all directories)
      image_processor_available, processor_type = initialize_image_processor
      
      # Process all subdirectories under assets/images/
      subdirs = Dir.glob(File.join(base_images_dir, '*')).select { |path| File.directory?(path) }
      
      subdirs.each do |source_dir|
        # Get relative directory name (e.g., 'films', 'musics')
        rel_path = File.basename(source_dir)
        
        # Check if this directory should have originals excluded
        is_excluded = exclude_originals.include?(rel_path)
        
        process_directory(site, source_dir, max_width, image_config, image_processor_available, processor_type, is_excluded)
      end
    end
    
    def self.initialize_image_processor
      processor_available = false
      processor_type = nil
      
      # Try vips first
      begin
        require 'image_processing/vips'
        require 'vips'
        # Test if vips library is actually available
        # Just check if Vips module is defined, don't try to open a file
        if defined?(Vips) && Vips.respond_to?(:get_suffixes)
          processor_available = true
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
          processor_available = true
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
      
      [processor_available, processor_type]
    end
    
    def self.process_directory(site, source_dir, max_width, image_config, image_processor_available, processor_type, is_excluded = false)
      # Get relative path from assets/images/ to preserve subdirectory structure
      base_images_dir = File.join(site.source, 'assets/images')
      rel_path = source_dir.sub(/^#{Regexp.escape(base_images_dir)}\//, '')
      
      # Get directory-specific max_width if configured, otherwise use default
      dir_max_width = image_config.dig('per_dir', rel_path) || max_width
      
      # Destination directory in _site
      dest_dir = File.join(site.dest, 'assets/images', rel_path)
      FileUtils.mkdir_p(dest_dir) unless Dir.exist?(dest_dir)
      
      # For excluded directories, use resize/ subfolder as cache
      if is_excluded
        resize_cache_dir = File.join(source_dir, 'resize')
        FileUtils.mkdir_p(resize_cache_dir) unless Dir.exist?(resize_cache_dir)
      end
      
      # Supported image formats
      image_extensions = %w[.jpg .jpeg .png .JPG .JPEG .PNG .webp .WEBP]
      
      resized_count = 0
      cached_count = 0
      skipped_count = 0
      error_count = 0
      
      # Get list of images to process
      images_to_process = if is_excluded
        # For excluded dirs: process originals from source_dir (not from resize/)
        Dir.glob(File.join(source_dir, '*')).select do |path|
          File.file?(path) && image_extensions.include?(File.extname(path))
        end
      else
        # For non-excluded dirs: process from source_dir as before
        Dir.glob(File.join(source_dir, '*')).select do |path|
          File.file?(path) && image_extensions.include?(File.extname(path))
        end
      end
      
      images_to_process.each do |image_path|
        filename = File.basename(image_path)
        dest_path = File.join(dest_dir, filename)
        
        begin
          if is_excluded
            # EXCLUDED DIRECTORY LOGIC: Use resize cache
            resize_cache_path = File.join(source_dir, 'resize', filename)
            
            # Check if we need to generate/update cached resize
            need_resize = !File.exist?(resize_cache_path) || 
                         File.mtime(image_path) > File.mtime(resize_cache_path)
            
            if need_resize && image_processor_available
              # Generate resized image to cache
              if processor_type == :vips
                ImageProcessing::Vips
                  .source(image_path)
                  .resize_to_limit(dir_max_width, nil)
                  .call(destination: resize_cache_path)
              elsif processor_type == :mini_magick
                ImageProcessing::MiniMagick
                  .source(image_path)
                  .resize_to_limit(dir_max_width, nil)
                  .call(destination: resize_cache_path)
              end
              
              resized_count += 1
              Jekyll.logger.info "ImageResizer:", "Generated cache #{rel_path}/resize/#{filename}"
            elsif need_resize && !image_processor_available
              Jekyll.logger.error "ImageResizer:", "Cannot cache #{rel_path}/#{filename}: no image processor available"
              error_count += 1
              next
            else
              cached_count += 1
              Jekyll.logger.debug "ImageResizer:", "Using cached #{rel_path}/resize/#{filename}"
            end
            
            # Copy cached resize to _site (hide resize path)
            FileUtils.cp(resize_cache_path, dest_path)
            
          else
            # NON-EXCLUDED DIRECTORY LOGIC: Original behavior
            if image_processor_available
              # Get original image dimensions
              original_width = nil
              begin
                if processor_type == :vips
                  require 'vips'
                  original = Vips::Image.new_from_file(image_path)
                  original_width = original.width
                elsif processor_type == :mini_magick
                  require 'mini_magick'
                  image = MiniMagick::Image.open(image_path)
                  original_width = image.width
                end
              rescue => dim_error
                Jekyll.logger.warn "ImageResizer:", "Could not get dimensions for #{rel_path}/#{filename}, will resize anyway: #{dim_error.message}"
              end
              
              # Only resize if image is wider than dir_max_width
              should_resize = original_width.nil? || original_width > dir_max_width
              
              if should_resize
                # Resize image
                if processor_type == :vips
                  ImageProcessing::Vips
                    .source(image_path)
                    .resize_to_limit(dir_max_width, nil)
                    .call(destination: dest_path)
                elsif processor_type == :mini_magick
                  ImageProcessing::MiniMagick
                    .source(image_path)
                    .resize_to_limit(dir_max_width, nil)
                    .call(destination: dest_path)
                end
                
                resized_count += 1
                if original_width
                  Jekyll.logger.info "ImageResizer:", "Resized #{rel_path}/#{filename} (#{original_width}px -> #{dir_max_width}px)"
                else
                  Jekyll.logger.info "ImageResizer:", "Resized #{rel_path}/#{filename} (max-width: #{dir_max_width}px)"
                end
              else
                # Copy original if it's already small enough
                FileUtils.cp(image_path, dest_path) unless File.exist?(dest_path) && File.mtime(dest_path) >= File.mtime(image_path)
                skipped_count += 1
                Jekyll.logger.debug "ImageResizer:", "Skipped #{rel_path}/#{filename} (already #{original_width}px <= #{dir_max_width}px)"
              end
            else
              # Fallback: just copy the original image
              FileUtils.cp(image_path, dest_path) unless File.exist?(dest_path) && File.mtime(dest_path) >= File.mtime(image_path)
              skipped_count += 1
            end
          end
          
        rescue => e
          Jekyll.logger.error "ImageResizer:", "Failed to process #{rel_path}/#{filename}: #{e.message}"
          Jekyll.logger.debug "ImageResizer:", "Error details: #{e.backtrace.first(3).join("\n")}"
          
          # Fallback: For excluded dirs, we can't copy originals
          if is_excluded
            Jekyll.logger.error "ImageResizer:", "Cannot deploy #{rel_path}/#{filename}: directory uses resize cache only"
            error_count += 1
          else
            # For non-excluded, try to copy original
            begin
              FileUtils.cp(image_path, dest_path) unless File.exist?(dest_path)
              error_count += 1
            rescue => copy_error
              Jekyll.logger.error "ImageResizer:", "Failed to copy #{rel_path}/#{filename}: #{copy_error.message}"
            end
          end
        end
      end
      
      # Summary log
      if is_excluded
        if resized_count > 0 || cached_count > 0 || error_count > 0
          Jekyll.logger.info "ImageResizer:", "Processed #{rel_path}/ [CACHE MODE]: #{resized_count} generated, #{cached_count} cached, #{error_count} errors"
        end
      else
        if resized_count > 0 || skipped_count > 0 || error_count > 0
          Jekyll.logger.info "ImageResizer:", "Processed #{rel_path}/: #{resized_count} resized, #{skipped_count} copied, #{error_count} errors"
        end
      end
    end
  end

  # Register hook to run after site is written (after static files are copied)
  Hooks.register(:site, :post_write) do |site|
    ImageResizer.process_images(site)
  end
end


