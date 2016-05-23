# Require core library
require 'middleman-core'

module Landingman
  class DataExtension < ::Middleman::Extension
    DATA_DIR = File.expand_path(File.join('..', '..', 'data'), __FILE__)
    DATA_FILE_MATCHER = /^(.*?)[\w-]+\.(yml|yaml|json)$/

    option :data1_dir, '../_data',  'Global Data Directory #1'
    option :data2_dir, '../data',   'Global Data Directory #2'

    def initialize(app, options_hash={}, &block)
      super
    end

    def after_configuration
      self.configure_data_files
    end

    protected

      def configure_data_files
        # Global Data Directory: ../_data or ../data

        if Dir.exist?(DATA_DIR) then
          watcher = app.files.watch :global_data0, path: DATA_DIR, only: DATA_FILE_MATCHER
          app.files.on_change(:global_data0, &method(:update_data))
          watcher.poll_once!
        end

        if !options.data1_dir.nil? && !options.data1_dir.blank? then
          data1_dir = File.expand_path(File.join(app.root, options.data1_dir))
          if Dir.exist?(data1_dir) then
            watcher = app.files.watch :global_data1, path: data1_dir, only: DATA_FILE_MATCHER
            app.files.on_change(:global_data1, &method(:update_data))
            watcher.poll_once!
          end
        end

        if !options.data2_dir.nil? && !options.data2_dir.blank? then
          data2_dir = File.expand_path(File.join(app.root, options.data2_dir))
          if Dir.exist?(data2_dir) then
            watcher = app.files.watch :global_data2, path: data2_dir, only: DATA_FILE_MATCHER
            app.files.on_change(:global_data2, &method(:update_data))
            watcher.poll_once!
          end
        end
      end

      # Updates DataStore with modified files
      def update_data(updated_files, removed_files)
        updated_files.each do |file|
          app.extensions[:data].data_store.touch_file(file)
        end
        removed_files.each do |file|
          app.extensions[:data].data_store.remove_file(file)
        end
      end
  end
end