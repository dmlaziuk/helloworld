require 'set'
require 'mechanize'

class JobsDevBy
  def initialize
    @agent = Mechanize.new
    @technologies = Set.new
  end

  def run
    @page = @agent.get('https://jobs.dev.by')
    parse('//*[@class="all list-style-tags"]//a')
    parse('//*[@class="list-style-tags"]//a')
    next_page = @page.links_with(xpath: '//*[@class="next-posts"]//a').first
    while next_page
      @page = next_page.click
      parse('//*[@class="all list-style-tags"]//a')
      parse('//*[@class="list-style-tags"]//a')
      next_page = @page.links_with(xpath: '//*[@class="next-posts"]//a').first
    end
    puts SortedSet.new(@technologies.to_a).to_a
  end

  def parse(xpath)
    info = @page.xpath(xpath)
    info.each do |item|
      @technologies << item.text
    end
  end
end
