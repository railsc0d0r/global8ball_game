module Global8ballGame
  module GameHelper
    def game_assets
      image_asset_dir = Rails.root.join('app', 'assets', 'images')

      assets = {}

      %w(.jpg .png .jpeg .gif .svg).each do |file_ext|
        Dir.glob(File.join(image_asset_dir, "**", "*#{file_ext}")).each do |absolute_path|
          file = absolute_path.sub(File.join(image_asset_dir, '/'), '')
          assets[file] = asset_path(file)
        end
      end

      assets
    end
  end
end
