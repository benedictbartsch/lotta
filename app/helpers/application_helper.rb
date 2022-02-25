module ApplicationHelper

    def application_title
        if @workspace && @workspace.persisted?
            "#{ @workspace.name } | Lotta"
        else
            "Lotta"
        end
    end
end
