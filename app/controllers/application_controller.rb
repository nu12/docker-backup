class ApplicationController < ActionController::Base

    private
    def pull_image(image)
        i = Docker::API::Image.new
        i.create( fromImage: image )
    end

    def launch_container(container)
        c = Docker::API::Container.new
        c.start(container)
        c.wait(container)
        c.remove(container)
    end
end
