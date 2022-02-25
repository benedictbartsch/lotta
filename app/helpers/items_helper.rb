module ItemsHelper
    include Pagy::Frontend

    def item_icon(item)
        case item.item_type
        when "task"
            "✔"
        when "note"
            '<span class="icon is-small">
                  <i class="fas fa-sticky-note"></i>
                </span>'.html_safe
        when "bullet"
            "•"
        end
    end

    def strikethrough?(item)
        item.task? && item.completed?
    end

    def format_content(item)
        text = item.note? ? item.markdown_content : item.content

        text = text.gsub(URI.regexp(['http', 'https']), '<a href="\0" target="_blank" class="is-link">\0</a>')
        text = text.gsub(/\B(\#[a-zA-Z0-9]+\b)(?!;)/) { |m| link_to(m, workspace_items_url(item.workspace, tag: m[1..-1]), target: "_top", class: "tag-link") }
        text.gsub(/\B(\@[a-zA-Z0-9]+\b)(?!;)/) { |m| link_to(m, workspace_items_url(item.workspace, project: m[1..-1]), target: "_top", class: "tag-link") }.html_safe
    end

    def render_item_header(item)
        if item.group.present? && @group.nil?
            true
        elsif item.due_at.present?
            true
        else
            false
        end
    end

    def current_sorting_string(selected_param = current_page_params[:sorting])
        "items.index.sorting.#{ selected_param || 'created_at_desc' }"
    end

    def sorting_link_helper(workspace, selected_param)
        link_to t(current_sorting_string(selected_param)), workspace_items_path(workspace, current_page_params.merge(sorting: selected_param)), class: "dropdown-item #{ 'is-active' if (current_page_params[:sorting] == selected_param) || (current_page_params[:sorting].blank? && selected_param == "created_at_desc") }"
    end

        
    def current_page_params
        request.params.slice("tag", "project", "sorting", "filter")
    end
end
