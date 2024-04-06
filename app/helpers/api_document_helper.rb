module ApiDocumentHelper
  ApiDoc = Struct.new(:api, :method, :params, :notes)

  def process_split_api(raw_doc, position_controller_in_path)
    raw_doc = raw_doc.map do |doc|
      doc = doc.strip
      doc[0] = '' if doc.start_with?('/')

      ApiDoc.new(*doc.split('|').map { |e| e.to_s.strip })
    end

    raw_doc = raw_doc.sort_by { |doc| doc.api }

    raw_doc.group_by { |doc| doc.api.split('/')[position_controller_in_path].strip }
  end

  def action_label_api(action)
    case action.strip.downcase
    when 'post'
      'success'
    when 'get'
      'primary'
    when 'put'
      'warning'
    when 'delete'
      'danger'
    else
      'success'
    end
  end
end
