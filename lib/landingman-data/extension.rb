# Require core library
require 'middleman-core'
require 'pathname'

####
# TODO:
# Tried to load in data in the same way as Middleman, but the internal APIs are changing
# so this static load the data in and does not attempt to use a "SourceWatcher".
####
module Landingman
  class DataExtension < ::Middleman::Extension
    DATA_DIR = File.expand_path(File.join('..', '..', 'data'), __FILE__)
    # DATA_FILE_MATCHER = /^(.*?)[\w-]+\.(yml|yaml|json)$/
    # option :data1_dir, '../_data',  'Global Data Directory #1'
    # option :data2_dir, '../data',   'Global Data Directory #2'

    def initialize(app, options_hash={}, &block)
      super
    end

    def after_configuration
      self.load_dir_into_data_store(DATA_DIR)
    end

    protected

      # def configure_data_files
      #   # Global Data Directory: ../_data or ../data

      #   if Dir.exist?(DATA_DIR) then
      #     watcher = app.files.watch :global_data0, path: DATA_DIR, only: DATA_FILE_MATCHER
      #     app.files.on_change(:global_data0, &method(:update_data))
      #     watcher.poll_once!
      #   end

      #   if !options.data1_dir.nil? && !options.data1_dir.blank? then
      #     data1_dir = File.expand_path(File.join(app.root, options.data1_dir))
      #     if Dir.exist?(data1_dir) then
      #       watcher = app.files.watch :global_data1, path: data1_dir, only: DATA_FILE_MATCHER
      #       app.files.on_change(:global_data1, &method(:update_data))
      #       watcher.poll_once!
      #     end
      #   end

      #   if !options.data2_dir.nil? && !options.data2_dir.blank? then
      #     data2_dir = File.expand_path(File.join(app.root, options.data2_dir))
      #     if Dir.exist?(data2_dir) then
      #       watcher = app.files.watch :global_data2, path: data2_dir, only: DATA_FILE_MATCHER
      #       app.files.on_change(:global_data2, &method(:update_data))
      #       watcher.poll_once!
      #     end
      #   end
      # end

      # # Updates DataStore with modified files
      # def update_data(updated_files, removed_files)
      #   updated_files.each do |file|
      #     app.extensions[:data].data_store.touch_file(file)
      #   end
      #   removed_files.each do |file|
      #     app.extensions[:data].data_store.remove_file(file)
      #   end
      # end

      def load_dir_into_data_store(dir_path)
        return unless Dir.exist?(dir_path)
        Dir.glob(File.join(dir_path, '*.{yaml,yml,json}')).each do |file_path|
          self.load_file_into_data_store(file_path)
        end
      end

      def load_file_into_data_store(data_path)
        extension = File.extname(data_path)
        basename  = File.basename(data_path, extension)
        return unless %w(.yaml .yml .json).include?(extension)

        file = ::Middleman::SourceFile.new(Pathname(data_path).relative_path_from(app.source_dir), Pathname(data_path), app.source_dir, Set.new([:source]), 0)
        if %w(.yaml .yml).include?(extension)
          data, postscript = ::Middleman::Util::Data.parse(file, app.config[:frontmatter_delims], :yaml)
          data[:postscript] = postscript if !postscript.nil? && data.is_a?(Hash)
        elsif extension == '.json'
          data, _postscript = ::Middleman::Util::Data.parse(file, app.config[:frontmatter_delims], :json)
        end
        app.extensions[:data].data_store.store(basename.to_sym, data)
      end
  end
end