class Item < ApplicationRecord
  acts_as_taggable_on :tags
  acts_as_taggable_tenant :workspace_id
  belongs_to :project, optional: true, counter_cache: true
  belongs_to :group, optional: true
  belongs_to :workspace

  enum item_type: %i[bullet task note]
  before_save :set_tags_and_projects
  validates :content, presence: true

  def completed?
    status == 1 && item_type == 'task'
  end

  def extract_tag_names
    hashtags = content.split(' ').select { |w| w.first == '#' && w.length > 1 && w[1, 1] != '#' }
    return if hashtags.empty?

    hashtags.map { |t| t.gsub(/[^[:word:]\s]/, '').downcase }
  end

  def extract_project_name
    project = content.split(' ').detect { |w| w.first == '@' && w.length > 1 }
    return if project.blank?

    project.gsub(/[^[:word:]\s]/, '').downcase
  end

  def set_tags_and_projects
    tag_list.replace(extract_tag_names) if extract_tag_names

    set_project(extract_project_name)
  end

  def set_project(project_name)
    self.project = (Project.find_or_create_by(name: project_name, workspace: workspace) if project_name.present?)
  end

  def has_tags?
    tag_list.any?
  end

  def markdown_content
    self.class.markdown.render(content)
  end

  class << self
    def markdown
      Redcarpet::Markdown.new(Redcarpet::Render::HTML, lax_spacing: true, space_after_headers: true,
                                                       underline: true, strikethrough: true, highlight: true)
    end
  end
end
