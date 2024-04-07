require 'net/http'
require 'json'

class Youtube
  class << self
    def get_video_info(url)
      youtube_id = url.match(/(?<=v=|v\/|vi=|vi\/|youtu.be\/|\/v\/|\/embed\/|\/shorts\/|\/channel\/|\/user\/|\/c\/|\/watch\?v=|\/watch\?vi=|\/watch\?feature=player_embedded&v=|\/watch\?feature=player_embedded&vi=|\/watch\?feature=player_embedded&list=|\/watch\?feature=player_embedded&index=|\/watch\?feature=player_embedded&list=PL|\/watch\?feature=player_embedded&index=PL|\/watch\?feature=player_embedded&list=LL|\/watch\?feature=player_embedded&index=LL|\/watch\?feature=player_embedded&list=FL|\/watch\?feature=player_embedded&index=FL|\/watch\?feature=player_embedded&list=TL|\/watch\?feature=player_embedded&index=TL|\/watch\?feature=player_embedded&list=PL&index=|\/watch\?feature=player_embedded&list=LL&index=|\/watch\?feature=player_embedded&list=FL&index=|\/watch\?feature=player_embedded&list=TL&index=|\/watch\?feature=player_embedded&index=|\/watch\?v%3D|\/watch\?vi%3D|\/watch\?feature=player_embedded&v%3D|\/watch\?feature=player_embedded&vi%3D|\/watch\?feature=player_embedded&list%3D|\/watch\?feature=player_embedded&index%3D|\/watch\?feature=player_embedded&list%3DPL|\/watch\?feature=player_embedded&index%3DPL|\/watch\?feature=player_embedded&list%3DLL|\/watch\?feature=player_embedded&index%3DLL|\/watch\?feature=player_embedded&list%3DFL|\/watch\?feature=player_embedded&index%3DFL|\/watch\?feature=player_embedded&list%3DTL|\/watch\?feature=player_embedded&index%3DTL|\/watch\?feature=player_embedded&list%3DPL%26index%3D|\/watch\?feature=player_embedded&list%3DLL%26index%3D|\/watch\?feature=player_embedded&list%3DFL%26index%3D|\/watch\?feature=player_embedded&list%3DTL%26index%3D|\/watch\?feature=player_embedded&index%3D|\/watch\?v%3D|\/watch\?vi%3D|\/watch\?feature=player_embedded&v%3D|\/watch\?feature=player_embedded&vi%3D|\/watch\?feature=player_embedded&list%3D|\/watch\?feature=player_embedded&index%3D|\/watch\?feature=player_embedded&list%3DPL%26index%3D|\/watch\?feature=player_embedded&list%3DLL%26index%3D|\/watch\?feature=player_embedded&list%3DFL%26index%3D|\/watch\?feature=player_embedded&list%3DTL%26index%3D)[\w-]{11}/)
      return nil unless youtube_id

      api_url = "https://www.googleapis.com/youtube/v3/videos?id=#{youtube_id}&key=#{ENV["YOUTUBE_API_KEY"]}&part=snippet"
      response = Net::HTTP.get(URI(api_url))
      json = JSON.parse(response)

      if json['items'].empty?
        nil
      else
        title = json['items'][0]['snippet']['title']
        description = json['items'][0]['snippet']['description']

        {youtube_id: youtube_id.to_s, title: title, description: description}
      end
    end
  end
end
