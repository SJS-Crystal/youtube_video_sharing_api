class Api::User::V1::VideosController < Api::User::V1::BaseController
  skip_before_action :authenticate, only: %i[index]

  $user_desc << 'api/user/v1/videos | POST | Authorization(header), url | Share a video'
  def create
    video_info = Youtube.get_video_info(params[:url])
    return render json: {message: 'Invalid youtube url'}, status: :bad_request unless video_info

    @current_user.videos.create!(video_info)
    render json: {}, status: :created
  end

  def index
  end
end
