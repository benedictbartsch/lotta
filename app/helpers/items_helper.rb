module ItemsHelper
    include Pagy::Frontend

    def item_icon(item)
        case item.item_type
        when "task"
            "✔"
        when "note"
            "📃"
        when "info"
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
end
