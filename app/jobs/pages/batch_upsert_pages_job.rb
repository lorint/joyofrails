module Pages
  class BatchUpsertPagesJob < ApplicationJob
    queue_as :default

    def perform
      [
        SitepressArticle,
        SitepressSlashPage
      ].each do |sitepress_collection|
        sitepress_collection.all.each do |sitepress_resource|
          Page.find_or_create_by!(request_path: sitepress_resource.request_path)
        end
      end
    end
  end
end
