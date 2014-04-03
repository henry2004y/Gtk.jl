if gtk_version == 3
@gtktype GtkCssProvider
GtkCssProvider_new() = GtkCssProvider_new(ccall((:gtk_css_provider_get_default,libgtk),Ptr{GObject},()))

function GtkCssProvider_new(;data=nothing,filename=nothing)
    source_count = (data!==nothing) + (filename!==nothing)
    @assert(source_count <= 1,
        "GtkCssProvider must have at most one data or filename argument")
    provider = GtkCssProvider_new(ccall((:gtk_css_provider_get_default,libgtk),Ptr{GObject},()))
    if data !== nothing
        GError() do error_check
          ccall((:gtk_css_provider_load_from_data,libgtk), Bool,
            (Ptr{GObject}, Ptr{Uint8}, Clong, Ptr{Ptr{GError}}),
            provider, bytestring(data), -1, error_check)
        end
    elseif filename !== nothing
        GError() do error_check
          ccall((:gtk_css_provider_load_from_path,libgtk), Bool,
            (Ptr{GObject}, Ptr{Uint8}, Clong, Ptr{Ptr{GError}}),
            provider, bytestring(filename), error_check)
        end
    end
    return provider
end

@Giface GtkStyleProvider Gtk.libgtk gtk_style_provider


@gtktype GtkStyleContext
GtkStyleContext_new() = GtkStyleContext_new(ccall((:gtk_style_context_new,libgtk),Ptr{GObject},()))

push!(context::GtkStyleContext, provider::GtkStyleProvider, priority::Integer) =
  ccall((:gtk_style_context_add_provider,libgtk),Void,(Ptr{GObject},Ptr{GObject},Cuint), 
         context,provider,priority)
else
    type GtkCssProvider end
    type GtkStyleContext end
    GtkCssProvider_new(x...) = error("GtkStyleContext is not available until Gtk3.0")
    GtkStyleContext_new(x...) = error("GtkStyleContext is not available until Gtk3.0")
end
