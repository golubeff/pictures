namespace :import do
  task :lolpix => :environment do
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    host = "http://www.lolpix.com"
    page = agent.get("#{host}/pictures.asp")

    page.search('.gallery li a').each do |link|
      uri = link.attribute('href')

      referral_url = "#{host}#{uri}"
      date_page = agent.get(referral_url)
      date_page.search('.gallery li a img').each do |img|
        image_url = "#{host}#{img.attribute('src').to_s.gsub(/_s\./, '.')}"
        exit if ImportLog.exists?(:key => "lolpix", :url => image_url)

        Picture.create :source_url => image_url, :referral_url => referral_url
        ImportLog.create :key => "lolpix", :url => image_url
      end
    end
  end
end
