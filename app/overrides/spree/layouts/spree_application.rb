Deface::Override.new(virtual_path:  "spree/layouts/spree_application",
                     insert_bottom: "head[data-hook='inside_head']",
                     text:          "<%= scrivito_head_tags %>",
                     name:          "add_scrivito_head_tags")

Deface::Override.new(virtual_path:  "spree/layouts/spree_application",
                     insert_bottom: "body[data-hook='body']",
                     text:          "<%= scrivito_body_tags %>",
                     name:          "add_scrivito_body_tags")
