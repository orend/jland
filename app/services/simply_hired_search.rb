class SimplyHiredSearch
  require 'open-uri'
  require 'nokogiri'
  require 'ostruct'
  require 'uri'

  API_URL_BASE = "http://api.simplyhired.com/a/jobs-api/xml-v2/".freeze
  API_LOCATION = "l-LOCATION".freeze
  API_QUERY = "q-SEARCH_TERM".freeze
  API_REST = "?pshid=41106&ssty=2&cflg=r&jbd=joblander.jobamatic.com&clip=74.94.200.198".freeze

  def self.search(term, options = {})
    url = ''
    url << API_URL_BASE
    url << API_LOCATION.sub('LOCATION', options[:zipcode]) << '/' if options[:zipcode]
    url << API_QUERY.sub('SEARCH_TERM', term) << API_REST
    doc = Nokogiri::XML(open(URI.escape(url)))
    positions = doc.xpath('//r').collect do |node|

      position = OpenStruct.new
      position.title = node.xpath("jt").text
      position.url = node.xpath("src/@url").text
      position.source  = node.xpath("src").text
      position.city  = node.xpath("loc/@cty").text
      position.state  = node.xpath("loc/@st").text
      position.country  = node.xpath("loc/@country").text
      position.description = node.xpath("e").text
      position.post_date = node.xpath("dp").text
      position.job_type = node.xpath("ty").text
      position
    end
  end
end