class Api::User::V1::VideosController < Api::User::V1::BaseController
  skip_before_action :authenticate, only: %i[index]

  $user_desc << 'api/user/v1/videos | POST | Authorization(header), url | Share a video'
  def create
    video_info = Youtube.get_video_info(params[:url])
    return render json: {message: 'Invalid youtube url'}, status: :bad_request unless video_info

    @current_user.videos.create!(video_info)
    render json: {}, status: :created
  end

  $user_desc << 'api/user/v1/videos | GET | Authorization(header), page, items | List videos'
  def index
    videos = Video.includes(:user).joins(:user).select('videos.*, users.name as shared_by').order(created_at: :desc)
    pagy, videos = pagy(videos, page: params[:page], items: params[:items])
    render json: {data: videos, page_metadata: pagy_metadata(pagy)}
  end
end
